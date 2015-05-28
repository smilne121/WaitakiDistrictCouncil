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
    let consentManager: ConsentManager
    
    init(consentManager: ConsentManager)
    {
        self.consentManager = consentManager
    }
    func getConsents(context: NSManagedObjectContext) -> [Consent]?
    {
        var resultConsents: [Consent]? = nil
        var result: String = ""
        
        var request = HTTPTask()
        request.GET("http://wdcweb4.waitakidc.govt.nz:4242/BuildingInspection/getConsents", parameters: nil, success: {(response: HTTPResponse) in
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

        consentManager.loadConsentsFromServer(json, context: context)
        
    }
    
    func sendInspection(inspection: Inspection, consentNumber: String) -> (Bool)
    {
        return true
    }
}
