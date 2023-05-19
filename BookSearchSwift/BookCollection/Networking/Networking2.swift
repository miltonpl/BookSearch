//
//  Networking2.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 5/19/23.
//  Copyright © 2023 Milton. All rights reserved.
//

import Foundation

class Networking2 {
    enum State {
    case running
    case suspended
    }

    struct QueueRequest {
        let request: URLRequest
        let promise: (URLRequest) -> Void
        func send() {
            promise(request)
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
    
    init(session: URLSession = .shared) {
        self.session = session
    }

    func suspend() {
        state = .suspended
    }

    func resume() {
        state = .running
    }

    func request(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) {
        switch state {
        case .running:
            responseRequest(with: request, completionHandler: completionHandler)
        case .suspended:
            queueRequest(with: request, completionHandler: completionHandler)
        }
    }

    private func queueRequest(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) {
        Self.stateQueue.sync {
            self.requests.append(.init(request: request, promise: { [weak self] request in
                self?.sendRequest(with: request, completionHandler: completionHandler)
            }))
        }
    }

    private func sendRequest(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) {
        let completion: @Sendable(Data?, URLResponse?, Error?) -> Void = { data, response, error in
            Self.stateQueue.async {
                completionHandler(data, response, error)
            }
        }

        Self.networkQueue.async {
            self.responseRequest(with: request, completionHandler: completion)
        }
    }

    private func responseRequest(with request: URLRequest, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) {
        let dataTask = session.dataTask(with: request, completionHandler: completionHandler)
        dataTask.resume()
    }
}
