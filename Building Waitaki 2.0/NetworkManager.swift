//
//  NetworkManager.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 13/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
class NetworkManager
{
    func getConsents() -> [Consent]?
    {
        var resultConsents: [Consent]? = nil
        var result: String = ""
        
        var request = HTTPTask()
        request.GET("http://wdcweb4.waitakidc.govt.nz:4242/BuildingInspection/getConsents", parameters: nil, success: {(response: HTTPResponse) in
            if response.responseObject != nil {
                let data = response.responseObject as NSData
                let str = NSString(data: data, encoding: NSUTF8StringEncoding)
                self.generateTest(str!)
                //println("response: \(str)") //prints the HTML of the page
            }
            },failure: nil)
        
       // println(result)
        
        
        return resultConsents
    }
    
    func generateTest(json: NSString)
    {
        var aPerson : Consent = Consent(JSONString: json)
        println(aPerson.consentNumber) // Output is "myUser"
    }
    
    func sendInspection(inspection: Inspection, consentNumber: String) -> (Bool)
    {
        return true
    }
}
