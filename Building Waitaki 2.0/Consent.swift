//
//  Consent.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 13/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation

class Consent : NSObject
{
    var inspectionArray: [Inspection]?
    var contactArray:[Contact]?
    var siteAddress: String?
    var consentNumber: String?
    var workDescription: String?
    var account: String?
    
    
    var otherContacts: [Contact]?
    
    
    func JSONParseArray(jsonString: String) -> [AnyObject]
    {
        if let data = jsonString.dataUsingEncoding(NSUTF8StringEncoding)
        {
            if let array = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(0), error: nil) as? [AnyObject]
            {
                return array
            }
        }
        return [AnyObject]()
    }
    
    init(JSONString: String)
    {
        super.init()
        var error : NSError?
        let JSONData = JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
      //println(1)
        
        
        let jsontest = "[{\"account\":\"101.2014.00002379.001 \",\"siteAddress\":\"41 Thames Street, Oamaru 9400 \",\"consentNumber\":\"2014/2379 \",\"description\":\"Earthquake Strengthening of existing building. New concrete floor \"}]"
        
        for elem:AnyObject in JSONParseArray(JSONString)
        {
            let name = elem["contact"] as String
            println("Here" + name)
        }
        
        for elem:AnyObject in JSONParseArray(JSONString)
        {
            let name = elem["contact"] as NSArray
                           println(name)
        //    }
        }
        
         //Loop
      //for (key, value) in JSONDictionary {
         //  let keyName = key as String
       //    let keyValue: String = value as String
       
       //     println(keyName)
            
         //   if (self.respondsToSelector(NSSelectorFromString(keyName))) {
          //      self.setValue(keyValue, forKey: keyName)
        //   }

    //   }
    }
    
}
