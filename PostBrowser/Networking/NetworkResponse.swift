//
//  NetworkResponse.swift
//  PostBrowser
//
//  Created by Ulaş Sancak on 18.02.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation

class NetworkResponse {
    
    var data: Data?
    
    var response: URLResponse?
    
    var error: Error?
    
    init(data: Data, response: URLResponse?, error: Error?) {
        self.data = data
        self.response = response
        self.error = error
    }
    
}
