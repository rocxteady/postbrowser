//
//  PostsRequest.swift
//  PostBrowser
//
//  Created by Ulaş Sancak on 18.02.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import UIKit

class PostsRequest: NetworkRequest<[Post]> {

    override init() {
        super.init()
        self.path = "/posts"
    }
    
}
