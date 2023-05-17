//  Networking.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 9/23/20.
//  Copyright © 2020 Milton. All rights reserved.

import Combine
import Foundation

class Networking {
    enum State {
    case running
    case suspended
    }

    struct QueueRequest {
        let request: URLRequest
        let promise: (Result<URLRequest, Never>) -> Void
        func send() {
            promise(.success(request))
        }
    }

    static let networkQueue = DispatchQueue(label: "com.networking")
    static let stateQueue = DispatchQueue(label: "com.networking.state")
    private var state: State {
        get {
            Self.stateQueue.sync { _state }
        } set {
            Self.stateQueue.sync {
                switch(_state, newValue) {
                case (.suspended, .running):
                    requests.forEach { $0.send() }
                    requests.removeAll()
                default:
                        break
                }
            }
        }
    }

    private let session: URLSession
    private var requests = [QueueRequest]()
    private var _state: State = .running
    private var dataTask: URLSessionDataTask?
    
    init(session: URLSession = .shared) {
        self.session = session
    }

    func suspend() {
        state = .suspended
        dataTask?.suspend()
    }

    func resume() {
        state = .running
        dataTask?.resume()
    }

    func request(url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) {
        
        dataTask = session.dataTask(with: url, completionHandler: completionHandler)
        dataTask?.resume()
    }

    func dataTaskPublisher(url: URL) -> AnyPublisher<URLSession.DataTaskPublisher.Output, Error> {
        switch state {
        case .running:
            return requestPublisher(request: .init(url: url))
        case .suspended:
            return queuePublisher(request: .init(url: url))
        }
    }

    func queuePublisher(request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, Error> {
        Future<URLRequest, Never> { promise in
            Self.stateQueue.sync {
                self.requests.append(.init(request: request, promise: promise))
            }
        }
        .setFailureType(to: Error.self)
        .flatMapWeakly { [weak self] request in
            return self?.requestPublisher(request: request)
        }
        .eraseToAnyPublisher()
    }

    private func requestPublisher(request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, Error> {
        return responsePublisher(request: request)
            .subscribe(on: Self.networkQueue)
            .receive(on: Self.stateQueue)
            .eraseToAnyPublisher()
    }

    private func responsePublisher(request: URLRequest) -> AnyPublisher<URLSession.DataTaskPublisher.Output, Error> {
        session
            .dataTaskPublisher(for: request)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

extension Publisher {
    /// To avoid retain cycle
    /// flatMapWeakly accepts a nil return to send an empty publisher
    public func flatMapWeakly<T, P: Publisher>(maxPublisher: Subscribers.Demand = .unlimited,
                                               _ transform: @escaping (Output) -> P?)
    -> Publishers.FlatMap<AnyPublisher<P.Output, P.Failure>, Self> where T == P.Output, Failure == P.Failure {
        flatMap(maxPublishers: maxPublisher) { output in
            transform(output)?.eraseToAnyPublisher() ?? Empty<P.Output, P.Failure>(completeImmediately: false).eraseToAnyPublisher()
        }
    }
}
