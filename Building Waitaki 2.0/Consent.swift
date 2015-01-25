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

    override init()
    {
        super.init()
                
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
