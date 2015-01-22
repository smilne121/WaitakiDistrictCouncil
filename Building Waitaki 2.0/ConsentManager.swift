//
//  ConsentManager.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 13/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation

class ConsentManager
{
    var consentArray: [Consent]?
    var user: String?
    
    init()
    {

    }
    
    func consentManagerInitilized()
    {
        loadConsentsFromCoreData()
        self.user = loadUserFromCoreData()
    }
    
    //load the consents from local storage into memory
    func loadConsentsFromCoreData() -> [Consent]?
    {
        var result = [Consent]()
        
        return result
    }
    
    func loadUserFromCoreData() -> String
    {
        var result = ""
        return result
    }
    
    
}

