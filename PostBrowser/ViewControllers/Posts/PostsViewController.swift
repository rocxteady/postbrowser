//
//  ViewController.swift
//  PostBrowser
//
//  Created by Ulaş Sancak on 18.02.2019.
//  Copyright © 2019 Ulaş Sancak. All rights reserved.
//

import UIKit

class PostsViewController: UITableViewController {

    private var viewModel = PostsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupUI()
        getPosts()
    }

    private func setupUI() {
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.tableView.register(UINib(nibName: PostCell.nibName, bundle: nil), forCellReuseIdentifier: PostCell.nibName)
        self.registerForPreviewing(with: self, sourceView: self.tableView)
    }
    
    private func getPosts() {
        self.viewModel.getPosts { [weak self] (error) in
            if let error = error {
                let alertController = UIAlertController(title: NSLocalizedString("Error", comment: ""), message: error.localizedDescription, preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default, handler: nil))
                self?.present(alertController, animated: true, completion: nil)
            }
            else {
                self?.tableView.reloadData()
            }
        }
    }
    
    private func detailViewController(for indexPath: IndexPath) -> UIViewController? {
        let postDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: PostDetailViewController.identifier) as? PostDetailViewController
        postDetailViewController?.post = self.viewModel.posts![indexPath.row]
        return postDetailViewController
    }
    
}

// MARK: - UITableViewDataSource
extension PostsViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = self.viewModel.posts {
            return posts.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCell.nibName, for: indexPath) as! PostCell
        let post = self.viewModel.posts![indexPath.row]
        cell.load(post: post)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let detailViewController = self.detailViewController(for: indexPath) {
            self.navigationController?.pushViewController(detailViewController, animated: true)
        }
    }
    
}

// MARK: - UIViewControllerPreviewingDelegate
extension PostsViewController: UIViewControllerPreviewingDelegate {
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        if let indexPath = self.tableView.indexPathForRow(at: location) {
            if let cell = self.tableView.cellForRow(at: indexPath) {
                previewingContext.sourceRect = cell.frame
                return detailViewController(for: indexPath)
            }
        }
        return nil
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        self.navigationController?.pushViewController(viewControllerToCommit, animated: true)
    }
    
}
