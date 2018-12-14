//
//  HomeFeedViewController.swift
//  Instagram
//
//  Created by Jorge Alejandre on 12/6/18.
//  Copyright © 2018 Jorge Alejandre. All rights reserved.
//

import UIKit
import Parse

class HomeFeedViewController: UIViewController, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    var posts: [Post?] = []
    var refreshControl: UIRefreshControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.rowHeight = 300
        //self.navigationController?.navigationBar.isHidden = false
        tableView.reloadData()
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(HomeFeedViewController.didPullToRefresh(_:)), for: .valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        fetchPosts()
        
        refreshControl.endRefreshing()
    }
    
    @IBAction func onLogout(_ sender: Any) {
        PFUser.logOutInBackground { (error) in
            if (error != nil) {
                print(error.debugDescription)
                print(error!.localizedDescription)
            }
        }
        self.performSegue(withIdentifier: "logoutSegue", sender: nil)
    }
    
    @IBAction func onCamera(_ sender: Any) {
        self.performSegue(withIdentifier: "cameraSegue", sender: nil)
    }
    @objc func didPullToRefresh(_ refreshControl: UIRefreshControl) {
        fetchPosts()
    }
    func fetchPosts() {
        let query = Post.query()
        query?.order(byDescending: "createdAt")
        query?.includeKey("author")
        query?.includeKey("createdAt")
        query?.limit = 20
        
        query?.findObjectsInBackground { (posts ,error) in
            if let posts = posts {
                print("Posts were found!")
                self.posts = posts as! [Post]
                self.tableView.reloadData()
            } else {
                print(error!.localizedDescription)
            }
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotoCell
        if let post = posts[indexPath.row] {
            print("Individual post opened!")
            let image = post.media
            
            image.getDataInBackground(block: {(data, error) in
                if (error != nil) {
                    print(error!.localizedDescription)
                } else {
                    print("Image was found!")
                    cell.photoImage.image = UIImage(data: data!)
                }
                
            })
            cell.photoCaption.text = post.caption
        }
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let cell = sender as? UITableViewCell {
            if let indexPath = tableView.indexPath(for: cell) {
                let post = posts[indexPath.row]
                let vc = segue.destination as! DetailsViewController
                vc.post = post
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
