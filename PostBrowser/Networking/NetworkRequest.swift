//
//  NetworkRequest.swift
//  PostBrowser
//
//  Created by Ulaş Sancak on 18.02.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation

typealias BaseCompletionBlock = (_ error: Error?) -> Void

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
    
    var shouldReadCache = true
    
    var cacheKey = "default"

    private(set) var currentTask: URLSessionTask?
    
    func start(completion: @escaping NetworkRequestCompletion<T>) {
        guard let url = createURL() else {
            completion(nil, ErrorHelper.crateError(type: .noData))
            return
        }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        self.currentTask = session.dataTask(with: url) { (data, response, error) in
            self.end()
            func complete(responseModel: T?, error: Error?) {
                if responseModel == nil && self.shouldReadCache {
                    do {
                        let decoder = JSONDecoder()
                        if let cacheData = try self.readFromCache() {
                            let t = try decoder.decode(T.self, from: cacheData)
                            DispatchQueue.main.async {
                                completion(t, error)
                            }
                        }
                        else {
                            DispatchQueue.main.async {
                                completion(nil, error)
                            }
                        }
                    } catch let error {
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
                    }
                }
                else {
                    DispatchQueue.main.async {
                        completion(responseModel, error)
                    }
                }
            }
            if let error = error {
                complete(responseModel: nil, error: error)
                return
            }
            if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                guard let data = data else {
                    complete(responseModel: nil, error: ErrorHelper.crateError(type: .noData))
                    return
                }
                let decoder = JSONDecoder()
                do {
                    let t = try decoder.decode(T.self, from: data)
                    try self.writeResponseData(data: data)
                    complete(responseModel: t, error: nil)
                } catch let error {
                    print(error.localizedDescription)
                    complete(responseModel: nil, error: ErrorHelper.crateError(type: .noData))
                }
                return
            }
            complete(responseModel: nil, error: ErrorHelper.crateError(type: .noData))
        }
        self.currentTask?.resume()
    }
    
    func end() {
        if let currentTask = self.currentTask {
            if currentTask.state == .running || currentTask.state == .suspended {
                currentTask.cancel()
            }
            self.currentTask = nil
        }
    }
    
    private func writeResponseData(data: Data) throws {
        try CacheManager.sharedManager.write(data: data, with: self.cacheKey)
    }
    
    private func readFromCache() throws -> Data? {
        return try CacheManager.sharedManager.read(from: self.cacheKey)
    }
}

// MARK: - NetworkRequest Creating URL
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
