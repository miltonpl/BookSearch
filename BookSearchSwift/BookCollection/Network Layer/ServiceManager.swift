// ServiceManager.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 9/23/20.
//  Copyright © 2020 Milton. All rights reserved.

import UIKit

class ServiceManager {
    static let manager = ServiceManager()
    private init() {}
    
    func request(url: URL, completionHandler: @escaping(Any?, Error?) -> Void) {
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse, (httpResponse.statusCode == 200 ), let data = data else {
                DispatchQueue.main.async { completionHandler(nil, error) }
                return
            }
            DispatchQueue.main.async { completionHandler(data, nil) }
        }
        task.resume()
    }
}
