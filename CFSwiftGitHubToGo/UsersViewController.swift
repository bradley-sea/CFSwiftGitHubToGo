//
//  UsersViewController.swift
//  CFSwiftGitHubToGo
//
//  Created by Bradley Johnson on 9/25/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UICollectionViewDataSource, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var results = [User]()
    var networkManager : NetworkManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkManager = appDelegate.networkManager
        self.collectionView.dataSource = self
        self.searchBar.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.results.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("USER_CELL", forIndexPath: indexPath) as UserCell
        ++cell.tag
        let tag = cell.tag
        cell.imageView.image = nil
        let user = self.results[indexPath.row]
        if user.avatarImage != nil {
            cell.imageView.image = user.avatarImage
        } else {
            
            self.networkManager.fetchAvatarImageWithURLString(user.avatarURL, completionHandler: { (userImage) -> (Void) in
                if cell.tag == tag {
                    NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                        user.avatarImage = userImage
                        cell.imageView.image = userImage
                    })
                }
            })
        }
        
        return cell
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        self.networkManager.fetchUsersWithSearchTerm(searchBar.text, completionHandler: { (errorDescription, results) -> (Void) in
            
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
            
                if errorDescription != nil {
                    println("uh oh")
                } else {
                    self.results = results!
                    self.collectionView.reloadData()
                }
            })
        })
        
    }
}
