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

    init(networking: Networking2) {
        self.networking = networking
    }
    
    func request(url: URL, completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void) {
        networking.request(with: .init(url: url), completionHandler: completionHandler)
    }
}
