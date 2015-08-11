//
//  AppSettings.swift
//  BuildingWaitaki
// http://www.codingexplorer.com/nsuserdefaults-a-swift-introduction/ examples on using defaults and how to use found here
//  Created by Scott Milne on 28/05/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation

//Handles the saving and loading of the application defaults

 class AppSettings{
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func setUser(user: String)
    {
        defaults.setObject(user, forKey: "User")
    }
    
    func setAPIServer(APIServer: String)
    {
        defaults.setObject(APIServer, forKey: "APIServer")
    }
    
    func getUser() -> String?
    {
        if let user = defaults.stringForKey("User")
        {
        return user
        }
        else
        {
            return ""
        }
    }
    
    func getAPIServer() -> String?
    {
        if let APIServer =  defaults.stringForKey("APIServer")
        {
            return APIServer
        }
        else
        {
            return ""
        }
    }
    
    
}
