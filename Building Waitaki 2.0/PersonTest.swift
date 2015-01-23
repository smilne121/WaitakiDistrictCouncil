//
//  PersonTest.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 22/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
class Person : NSObject {
    var name : String?
    var email : String?
    var password : String?
    
    init(JSONString: String)
    {
        super.init()
        
        var error : NSError?
        let JSONData = JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        let JSONDictionary: Dictionary = NSJSONSerialization.JSONObjectWithData(JSONData!, options: nil, error: &error) as NSDictionary
        
        // Loop
        for (key, value) in JSONDictionary {
            let keyName = key as String
            let keyValue: String = value as String
            
            // If property exists
            if (self.respondsToSelector(NSSelectorFromString(keyName))) {
                self.setValue(keyValue, forKey: keyName)
            }
        }
        // Or you can do it with using
        // self.setValuesForKeysWithDictionary(JSONDictionary)
        // instead of loop method above
    }
}
