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
        
        let url = NSURL(string: "http://wdcweb4:4242/BuildingInspection/getConsents")
        
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            println(NSString(data: data, encoding: NSUTF8StringEncoding))
        }
        
        task.resume()
        
        return resultConsents
    }
    
    func sendInspection(inspection: Inspection, consentNumber: String) -> (Bool)
    {
        return true
    }
}
