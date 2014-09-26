//
//  WebViewController.swift
//  CFSwiftGitHubToGo
//
//  Created by Bradley Johnson on 9/26/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    

    var webView: WKWebView!
    var url : NSURL!
    
    override func loadView() {
        super.loadView()
        self.webView = WKWebView()
        self.view = webView
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.loadRequest(NSURLRequest(URL: self.url))
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
