//
//  BookSearchService.swift
//  BookCollection
//
//  Created by Milton Palaguachi on 5/16/23.
//  Copyright © 2023 Milton. All rights reserved.
//

import Foundation

class BookSearchService: HttpService {
    enum BookSearchServiceError: Error {
        case statusCode(Int)
        case unkown
    }

    func search(query: String, completionHandler: @escaping(Result<APIResponse, Error>) -> Void) {
        let strUrl = "\(Constants.api)\(Constants.endPoint)\(query)"
        guard let url = URL(string: strUrl) else { return }
        
        networking.request(url: url) { [weak self] data, response, error in
            guard let data = data, error == nil else {
                if let error = self?.handleURLResponse(response: response) {
                    completionHandler(.failure(error))
                } else if let error = error {
                    completionHandler(.failure(error))
                } else {
                    completionHandler(.failure(BookSearchServiceError.unkown))
                }
                return
            }
            do {
                let response = try JSONDecoder().decode(APIResponse.self, from: data)
                completionHandler(.success(response))
            } catch {
                completionHandler(.failure(error))
            }
        }
    }

    func handleURLResponse(response: URLResponse?) -> Error? {
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode != 200 else { return nil }
        return BookSearchServiceError.statusCode(httpResponse.statusCode)
    }
}
