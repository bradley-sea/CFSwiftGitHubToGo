//
//  SplitContainerViewController.swift
//  CFSwiftGitHubToGo
//
//  Created by Bradley Johnson on 9/24/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import UIKit

class SplitContainerViewController: UIViewController, UISplitViewControllerDelegate {
    
    var splitVC : UISplitViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up split view delegate
        self.splitVC = self.childViewControllers[0] as UISplitViewController
        splitVC.delegate = self
        splitVC.preferredPrimaryColumnWidthFraction = 0.3
//        let navVC = splitVC.childViewControllers.last as UINavigationController
//        navVC.topViewController.navigationItem.leftBarButtonItem = splitVC.displayModeButtonItem()

        // Do any additional setup after loading the view.
    }
    
    func splitViewController(splitViewController: UISplitViewController!, collapseSecondaryViewController secondaryViewController:UIViewController!, ontoPrimaryViewController primaryViewController:UIViewController!) -> Bool {
        
        let primaryNavController = self.splitVC.viewControllers.first as UINavigationController
        
        if let menuVC = primaryNavController.viewControllers.first as? MenuTableViewController {
            
            if menuVC.firstLaunch {
               menuVC.firstLaunch = false
                return true
            } else {
                 return false
            }
        }
        return false
    }
}
