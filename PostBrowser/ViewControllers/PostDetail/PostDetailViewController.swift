//
//  PostDetailViewController.swift
//  PostBrowser
//
//  Created by Ulaş Sancak on 20.02.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    static let identifier = "PostDetailViewController"

    var post: Post!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadPost()
    }

    private func loadPost() {
        self.titleLabel.text = post.title
        self.bodyTextView.text = post.body
    }

}
