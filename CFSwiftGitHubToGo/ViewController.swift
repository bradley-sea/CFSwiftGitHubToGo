//
//  ViewController.swift
//  CFSwiftGitHubToGo
//
//  Created by Bradley Johnson on 9/24/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       var networkManager = NetworkManager()
        networkManager.fetchRepositoriesWithSearchTerm("Brad", completionHandler: { (errorDescription, results) -> (Void) in
            if errorDescription != nil {
                println(errorDescription)
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

