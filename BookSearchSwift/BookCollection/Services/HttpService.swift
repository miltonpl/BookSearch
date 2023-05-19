//
//  HttpService.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 5/16/23.
//  Copyright © 2023 Milton. All rights reserved.
//

import Combine
import Foundation

class HttpService {
    let networking: Networking2
    let endpoint: Endpoint

    init(networking: Networking2) {
        self.networking = networking
        endpoint = .init(enviroment: .stage)
    }
    
    func request(url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) {
        networking.request(with: .init(url: url), completionHandler: completionHandler)
    }
}

extension HttpService {
    enum Enviroment {
        case production
        case stage
        var url: URL {
            switch self {
            case .production:
                return URL(string: Constants.api)!
            case .stage:
                return URL(string: Constants.api)!
            }
        }
    }
}

extension HttpService {
    enum Path: CustomStringConvertible {
        case bookSerch(String)

        var description: String {
            switch self {
            case .bookSerch(let query):
                return "books/v1/volumes?q=\(query)"
            }
        }
    }
}

extension HttpService {
    struct Endpoint {
        let enviroment: Enviroment
        func path(_ path: Path) -> URL? {
            URL(string: path.description, relativeTo: enviroment.url)
        }
    }
}
