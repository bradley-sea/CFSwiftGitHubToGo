//
//  Repo.swift
//  CFSwiftGitHubToGo
//
//  Created by Bradley Johnson on 9/24/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import Foundation


class Repo {
    
    var name = ""
    var repoURL = ""
    var isPrivate = false
    var starGazers = 0
    var forks = 0
    var repoDescription = ""
    
    class func parseJSONIntoRepos(json : NSDictionary) -> [Repo] {
        var repos = [Repo]()
        var jsonArray = json["items"] as NSArray
        
        for jsonObject in jsonArray {
            if let jsonRepo = jsonObject as? NSDictionary {
            var repo = Repo()
            repo.name = jsonRepo.objectForKey("name") as String
            repo.isPrivate = jsonRepo.objectForKey("private") as Bool
            repo.forks = jsonRepo.objectForKey("forks_count") as Int
            repo.starGazers = jsonRepo.objectForKey("stargazers_count") as Int
            if jsonRepo.objectForKey("description") is NSNull {
                    repo.repoDescription = " "
            } else {
            repo.repoDescription = jsonRepo.objectForKey("description") as String
                }
            repos.append(repo)
            }
        }
        return repos
    }
}