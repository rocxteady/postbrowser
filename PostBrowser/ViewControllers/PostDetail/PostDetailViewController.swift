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

    var viewModel: PostViewModel!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var bodyTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadPost()
    }

    private func loadPost() {
        self.titleLabel.text = self.viewModel.post.title
        self.bodyTextView.text = self.viewModel.post.body
    }

}
