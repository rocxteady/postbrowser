//
//  ViewController.swift
//  PostBrowser
//
//  Created by Ulaş Sancak on 18.02.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let viewModel = PostsViewModel()
        viewModel.getPosts { (posts, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                print(posts)
            }
        }
    }


}

