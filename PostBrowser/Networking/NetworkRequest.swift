//
//  NetworkRequest.swift
//  PostBrowser
//
//  Created by Ulaş Sancak on 18.02.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation

private enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol NetworkRequestProtocol {
    
    var path: String {get}
    
    var parameters: [String: Any]? {get}
    
}

class NetworkRequest: NetworkRequestProtocol {
    
    private var httpMethod: HTTPMethod = .get
    
    var path: String = ""
    
    var parameters: [String : Any]?

    var currentTask: URLSessionTask?
    
    func start() {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        self.currentTask = session.dataTask(with: createURL()) { [weak self] (data, response, error) in
            print(error?.localizedDescription)
        }
        self.currentTask?.resume()
    }
    
}

extension NetworkRequest {
    
    func createURL() -> URL {
        var urlComponents = URLComponents(string: NetworkConstants.baseURL)
        urlComponents?.path = self.path
        if self.httpMethod == .get, let parameters = self.parameters {
            urlComponents?.queryItems = parameters.map({ (object) -> URLQueryItem in
                let value = "\(object.value)"
                return URLQueryItem(name: object.key, value: value)
            })
        }
        return urlComponents!.url!
    }
    
}
