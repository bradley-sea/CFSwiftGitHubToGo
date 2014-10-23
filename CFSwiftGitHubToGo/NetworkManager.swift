//
//  NetworkManager.swift
//  CFSwiftGitHubToGo
//
//  Created by Bradley Johnson on 9/24/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import UIKit

class NetworkManager {
    
    var urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    var token : String?
    var oAuthCompletionHandler : (() -> ())?
    let imageQueue = NSOperationQueue()
    
    let GITHUB_CLIENT_ID = "client_id=b44b4d51dff4208800d0&"
    let GITHUB_CLIENT_SECRET = "dfc5f54502dc651cea4dc8bb8b006cc1e1aff7fb"
    let GITHUB_CALLBACK_URI = "redirect_uri=cfswiftgithubtogo://git_callback&"
    let GITHUB_OAUTH_URL = "https://github.com/login/oauth/authorize?"
    let GITHUB_API_URL = "https://api.github.com/"
    let GITHUB_SCOPE = "scope=user,repo"

    init() {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        self.token = userDefaults.valueForKey("token") as? String
        if self.token != nil {
            var configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
            configuration.HTTPAdditionalHeaders = ["Authorization" : "token \(self.token!)"]
            self.urlSession = NSURLSession(configuration: configuration)
            
        }
       println(self.token?)
    }
    
    func requestOauthAccessWithCompletion(completionClosure: () -> ()) {
        self.oAuthCompletionHandler = completionClosure
        var urlString : String = GITHUB_OAUTH_URL + GITHUB_CLIENT_ID + GITHUB_CALLBACK_URI + GITHUB_SCOPE
        UIApplication.sharedApplication().openURL(NSURL(string: urlString)!)
    }
    
    func handleOAuthCallbackWithURL(callbackURL : NSURL)
    {
        var query = callbackURL.query
        var components = query!.componentsSeparatedByString("code=") as [String]
        let code = components.last
        let postQuery = GITHUB_CLIENT_ID + "client_secret=" + GITHUB_CLIENT_SECRET + "&code=\(code!)" as String
        println(postQuery)
        var postData = postQuery.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: true)
        var postLength = "\(postData!.length)"
        
        var request = NSMutableURLRequest(URL: NSURL(string: "https://github.com/login/oauth/access_token")!)
        request.HTTPMethod = "POST"
        request.setValue(postLength, forHTTPHeaderField: "Content-Length")
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.HTTPBody = postData
        
        
        let postTask = self.urlSession.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println(error.localizedDescription  )
            } else {
                
                let httpResponse = response as NSHTTPURLResponse
                
                switch httpResponse.statusCode {
                case 200:
                    var tokenResponse = NSString(data:data, encoding: NSASCIIStringEncoding)
                    var tokenComponents = tokenResponse?.componentsSeparatedByString("&") as [String]
                    var accessTokenWithCode = tokenComponents[0]
                    var accessTokens = accessTokenWithCode.componentsSeparatedByString("=") as [String]
                    var accessToken = accessTokens[1]
                    self.token = accessToken
                    let userDefaults = NSUserDefaults.standardUserDefaults()
                    userDefaults.setValue(self.token!, forKey: "token")
                default:
                    println(httpResponse)
                }
                
               
            }
 
        })
        postTask.resume()
        
       
    }
    
    func fetchRepositoriesWithSearchTerm(searchTerm : String, completionHandler : (errorDescription : String?, results : [Repo]?) -> (Void)) {
        let url = NSURL(string: "https://api.github.com/search/repositories?q=\(searchTerm)&sort=stars&order=desc")
        let dataTask = self.urlSession.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println(error.localizedDescription)
                completionHandler(errorDescription: "Something went wrong, please try again", results: nil)
            } else {
                let httpResponse = response as NSHTTPURLResponse
                switch httpResponse.statusCode {
                case 200:
                    println(httpResponse)
                    var jsonError : NSError?
                    var rawJSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &jsonError) as NSDictionary
                    if error != nil {
                        completionHandler(errorDescription: "Something went wrong, please try again", results: nil)
                    } else {
                        var repos = Repo.parseJSONIntoRepos(rawJSON)
                        println(repos.count)
                        completionHandler(errorDescription: nil, results: repos)
                    }
                    
                default:
                    println(httpResponse.statusCode)
                    println(httpResponse)
                }
            }
        })
        dataTask.resume()
    }
    
    func fetchUsersWithSearchTerm(searchTerm : String, completionHandler : (errorDescription : String?, results : [User]?) -> (Void)) {
        
        let url = NSURL(string: "https://api.github.com/search/users?q=\(searchTerm)")
        let dataTask = self.urlSession.dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                println(error.localizedDescription)
                completionHandler(errorDescription: "Something went wrong, please try again", results: nil)
            } else {
                let httpResponse = response as NSHTTPURLResponse
                switch httpResponse.statusCode {
                case 200:
                    println(httpResponse)
                    var jsonError : NSError?
                    var rawJSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.AllowFragments, error: &jsonError) as NSDictionary
                    if error != nil {
                        completionHandler(errorDescription: "Something went wrong, please try again", results: nil)
                    } else {
                        var users = User.parseJSONIntoUsers(rawJSON)
                        completionHandler(errorDescription: nil, results: users)
                    }
                default:
                    println(httpResponse.statusCode)
                    println(httpResponse)
                }
            }
        })
        dataTask.resume()
    }
    
    func fetchAvatarImageWithURLString(urlString: String, completionHandler : (userImage : UIImage) -> (Void)) {
        
        let url = NSURL(string: urlString)
        
        self.imageQueue.addOperationWithBlock { () -> Void in
            let imageData = NSData(contentsOfURL: url!)
            let image = UIImage(data: imageData!)
            completionHandler(userImage: image!)
        }
    }
   
}
