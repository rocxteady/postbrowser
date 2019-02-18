//
//  PostsViewModel.swift
//  PostBrowser
//
//  Created by Ulaş Sancak on 18.02.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import Foundation

typealias PostsRequestCompletionBlock = (_ posts: [Post]?, _ error: Error?) -> Void

class PostsViewModel {
    
    func getPosts(completion: @escaping PostsRequestCompletionBlock) {
        let request = PostsRequest()
        request.start(completion: completion)
    }
    
}
