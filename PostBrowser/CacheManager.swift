//
//  FileManagerHelper.swift
//  PostBrowser
//
//  Created by Ulaş Sancak on 21.02.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation

class CacheManager {
    
    static let sharedManager = CacheManager()
    
    private let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    func write(data: Data, with key: String) throws {
        if let fileURL = dir?.appendingPathComponent(key) {
            try data.write(to: fileURL)
        }
        else {
            throw ErrorHelper.crateError(type: .fileError)
        }
    }
    
    func read(from key: String) throws -> Data? {
        if let fileURL = dir?.appendingPathComponent(key) {
            return try Data(contentsOf: fileURL)
        }
        throw ErrorHelper.crateError(type: .fileError)
    }
    
}
