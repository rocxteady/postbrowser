//
//  Post.swift
//  PostBrowser
//
//  Created by Ulaş Sancak on 18.02.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation

class Post: Decodable {
    
    var userId: Int?
    
    var id: Int?
    
    var title: String?
    
    var body: String?
    
}
