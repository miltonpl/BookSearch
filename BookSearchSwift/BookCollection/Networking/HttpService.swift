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
    let networking: Networking

    init(networking: Networking) {
        self.networking = networking
    }
    
    func request(url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) {
        networking.request(url: url, completionHandler: completionHandler)
    }

    func request(url: URL) -> AnyPublisher<URLSession.DataTaskPublisher.Output, Error> {
        networking.dataTaskPublisher(url: url)
    }
}
