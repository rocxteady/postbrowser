//
//  NetworkRequest.swift
//  PostBrowser
//
//  Created by Ulaş Sancak on 18.02.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation

typealias NetworkRequestCompletion<T: Decodable> = (_ response: T?, _ error: Error?) -> ()

private enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
}

protocol NetworkRequestProtocol {
    
    var path: String {get}
    
    var parameters: [String: Any]? {get}
    
}

class NetworkRequest<T: Decodable>: NetworkRequestProtocol {
    
    private var httpMethod: HTTPMethod = .get
    
    var path: String = ""
    
    var parameters: [String : Any]?

    var currentTask: URLSessionTask?
    
    func start(completion: @escaping NetworkRequestCompletion<T>) {
        let session = URLSession(configuration: URLSessionConfiguration.default)
        self.currentTask = session.dataTask(with: createURL()) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(nil, nil)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let t = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(t, nil)
                }
            } catch let error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
            }
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
