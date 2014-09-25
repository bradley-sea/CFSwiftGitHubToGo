//
//  UserViewController.swift
//  CFSwiftGitHubToGo
//
//  Created by Bradley Johnson on 9/25/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import UIKit

class UserViewController: UIViewController,UINavigationControllerDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userImageViewTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var userNameLabel: UILabel!
    var selectedUser : User!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userNameLabel.text = selectedUser.name
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
