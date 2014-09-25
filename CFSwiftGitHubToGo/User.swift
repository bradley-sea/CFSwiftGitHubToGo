//
//  User.swift
//  CFSwiftGitHubToGo
//
//  Created by Bradley Johnson on 9/25/14.
//  Copyright (c) 2014 Brad Johnson. All rights reserved.
//

import UIKit

class User {
    
    var name : String
    var avatarURL : String
    var url : String
    var id : String
    var avatarImage : UIImage?
    
    class func parseJSONIntoUsers(json : NSDictionary) -> [User] {
        
        var users = [User]()
        
        let items = json["items"] as NSArray
        
        for jsonUser in items {
            var jsonDict = jsonUser as NSDictionary
            var user = User(jsonDict: jsonDict)
            users.append(user)
        }
        return users
    }
    
    init (jsonDict : NSDictionary) {
        self.name = jsonDict.objectForKey("login") as String
        self.avatarURL = jsonDict.objectForKey("avatar_url") as String
        self.url = jsonDict.objectForKey("url") as String
        let intID = jsonDict.objectForKey("id") as Int
        self.id = "\(intID)"
    }
}