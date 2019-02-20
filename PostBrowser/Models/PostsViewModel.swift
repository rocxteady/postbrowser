//
//  PostsViewModel.swift
//  PostBrowser
//
//  Created by Ulaş Sancak on 18.02.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation

typealias BaseCompletionBlock = (_ error: Error?) -> Void

class PostsViewModel {
    
    var posts: [Post]?
    
    func getPosts(completion: @escaping BaseCompletionBlock) {
        let request = PostsRequest()
        request.start { (posts, error) in
            self.posts = posts
            completion(error)
        }
    }
    
}
