//
//  NetworkManager.swift
//  CFSwiftGitHubToGo
//
//  Created by Bradley Johnson on 9/24/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import Foundation

class NetworkManager {
    
    var urlSession = NSURLSession(configuration: NSURLSessionConfiguration.defaultSessionConfiguration())
    
    func fetchRepositoriesWithSearchTerm(searchTerm : String, completionHandler : (errorDescription : String?, results : [Repo]?) -> (Void)) {
        let url = NSURL(string: "https://api.github.com/search/repositories?q=tetris+language:assembly&sort=stars&order=desc")
        let dataTask = self.urlSession.dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
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
                        completionHandler(errorDescription: "something went wrong, please try again", results: nil)
                    } else {
                          var repos = Repo().parseJSONIntoRepos(rawJSON)
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
    
}
