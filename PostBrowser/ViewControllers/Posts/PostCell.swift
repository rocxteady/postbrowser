//
//  PostCell.swift
//  PostBrowser
//
//  Created by Ulaş Sancak on 19.02.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    static let nibName = "PostCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    func load(post: Post) {
        self.titleLabel.text = post.title
        self.bodyLabel.text = post.body
    }
    
}
