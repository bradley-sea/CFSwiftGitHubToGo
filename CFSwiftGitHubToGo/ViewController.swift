//
//  ViewController.swift
//  CFSwiftGitHubToGo
//
//  Created by Bradley Johnson on 9/24/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate,UITableViewDataSource {
    
    var networkManager : NetworkManager!
    var alertController = UIAlertController(title: "Warning", message: "To use this app you need to authenticate to Github. We will now send you to Github for Authentication", preferredStyle: UIAlertControllerStyle.Alert)
    
    var searchResults = [Repo]()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var imageViewCenterXConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.networkManager = appDelegate.networkManager
        self.searchBar.delegate = self
        self.tableView.dataSource = self
        self.tableView.alpha = 0
        
        if  self.networkManager.token == nil {
            
            let okayAction = UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
                self.networkManager.requestOauthAccessWithCompletion({ () -> () in
                })
            })
            alertController.addAction(okayAction)
            self.presentViewController(self.alertController, animated: true, completion: nil)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        var searchTerm = searchBar.text.stringByReplacingOccurrencesOfString(" ", withString: "+", options: NSStringCompareOptions.LiteralSearch, range: nil)
        self.networkManager.fetchRepositoriesWithSearchTerm(searchTerm, completionHandler: { (errorDescription, results) -> (Void) in
            NSOperationQueue.mainQueue().addOperationWithBlock({ () -> Void in
                if results != nil {
                    if !self.imageView.hidden {
                        self.imageViewCenterXConstraint.constant = 350
                        UIView.animateWithDuration(0.3, animations: { () -> Void in
                            self.view.layoutIfNeeded()
                            }, completion: { (finished) -> Void in
                                self.searchResults = results!
                                self.tableView.reloadData()
                                UIView.animateWithDuration(0.3, animations: { () -> Void in
                                    self.tableView.alpha = 1
                            })
                        })
                    }
                }
            })
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("REPO_SEARCH_CELL", forIndexPath: indexPath) as UITableViewCell
        let repo = self.searchResults[indexPath.row]
        cell.textLabel?.text = repo.repoDescription
        return cell
    }

}

