//
//  NetworkManager.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 13/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class NetworkManager
{
    func getConsents(context: NSManagedObjectContext) -> [Consent]?
    {
        var resultConsents: [Consent]? = nil
        var result: String = ""
        
        var request = HTTPTask()
        request.GET("http://wdcweb4:4242/BuildingInspection/getConsents", parameters: nil, success: {(response: HTTPResponse) in
            if response.responseObject != nil {
                let data = response.responseObject as NSData
                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                self.generateTest(str!, context: context)
            }
            },failure:  {(error: NSError, responce: HTTPResponse?) in
                println("error: \(error)")
            })
        
        return resultConsents
    }
    
    func generateTest(json: NSString, context: NSManagedObjectContext )
    {
        var consents:ConsentManager = ConsentManager()
        consents.loadConsentsFromServer(json, context: context)
        
        
       //var aPerson : Consent = Consent.lo(JSONString: json)
  //      println(aPerson.consentNumber) // Output is "myUser"
    }
    
    func sendInspection(inspection: Inspection, consentNumber: String) -> (Bool)
    {
        return true
    }
}
