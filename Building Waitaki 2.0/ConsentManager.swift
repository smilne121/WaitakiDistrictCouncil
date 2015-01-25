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
    
    func loadConsentsFromServer(JSONString: String)
    {
        var error : NSError?
        let JSONData = JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        
        for elem:AnyObject in JSONParseArray(JSONString)
        {
            let consent = Consent()
            consent.siteAddress = elem["siteAddress"] as? String
            consent.account = elem["account"] as? String
            consent.consentNumber = elem["consentNumber"] as? String
            consent.workDescription = elem["description"] as? String
            let contacts = elem["contact"] as NSArray
            let inspections = elem["inspections"] as NSArray
            println(inspections)
            
            for contact:AnyObject in contacts
            {
                let newContact = Contact()
                newContact.FirstName = contact["firstName"] as? String
                newContact.LastName = contact["lastName"] as? String
                newContact.CellPhone = contact["cellPhone"] as? String
                newContact.HomePhone = contact["homePhone"] as? String
                newContact.Position = contact["position"] as? String
                consent.contactArray?.append(newContact)
            }
            
            for inspection:AnyObject in inspections
            {
                let newInspection = Inspection()
                newContact.FirstName = contact["firstName"] as? String
                newContact.LastName = contact["lastName"] as? String
                newContact.CellPhone = contact["cellPhone"] as? String
                newContact.HomePhone = contact["homePhone"] as? String
                newContact.Position = contact["position"] as? String
                consent.contactArray?.append(newContact)
            }

            

            
            
            //add consent to array
            consentArray?.append(consent)
        }
        
        for elem:AnyObject in JSONParseArray(JSONString)
        {
       //     let name = elem["contact"] as NSArray
        //    println(name)
            //    }
        }

    }
}

