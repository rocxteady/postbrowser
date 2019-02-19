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

//T for response object model
class NetworkRequest<T: Decodable>: NetworkRequestProtocol {
    
    private var httpMethod: HTTPMethod = .get
    
    var path: String = ""
    
    var parameters: [String : Any]?

    var currentTask: URLSessionTask?
    
    func start(completion: @escaping NetworkRequestCompletion<T>) {
        guard let url = createURL() else {
            completion(nil, ErrorHelper.crateError(type: .noData))
            return
        }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        self.currentTask = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                DispatchQueue.main.async {
                    completion(nil, error)
                }
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(nil, ErrorHelper.crateError(type: .noData))
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
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completion(nil, ErrorHelper.crateError(type: .noData))
                    }
                }
                return
            }
            DispatchQueue.main.async {
                completion(nil, ErrorHelper.crateError(type: .noData))
            }
        }
        self.currentTask?.resume()
    }
    
}

extension NetworkRequest {
    
    func createURL() -> URL? {
        var urlComponents = URLComponents(string: NetworkConstants.baseURL)
        urlComponents?.path = self.path
        if self.httpMethod == .get, let parameters = self.parameters {
            urlComponents?.queryItems = parameters.map({ (object) -> URLQueryItem in
                let value = "\(object.value)"
                return URLQueryItem(name: object.key, value: value)
            })
        }
        return urlComponents?.url
    }
    
}
