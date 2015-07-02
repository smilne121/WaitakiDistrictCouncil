//
//  OfficeToolsSendInspections.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 1/07/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class OfficeToolsSendInspections
{
    let managedContext : NSManagedObjectContext
    
    init(managedContext: NSManagedObjectContext)
    {
        self.managedContext = managedContext
    }
    
    func getResults()
    {
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName: "ConsentInspection")
        let resultPredicate = NSPredicate(format: "needSynced %@", NSNumber(bool: true))
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.predicate = resultPredicate
        
        let items = managedContext.executeFetchRequest(fetchRequest, error: &error)! as! [ConsentInspection]
        
        var transferItems = ResultTransferItemArray()
        
        
        for item in items
        {
            if item.itemResult != nil
            {
                transferItems.append(item.toJSONItem())
            }
        }
        
        if items.count > 0
        {
            resultsToJson(transferItems)
        }

    }
    
    func resultsToJson(consentInspectionItems:ResultTransferItemArray)
    {
     //   println(consentInspectionItems.toJsonString())
        post(consentInspectionItems.toJson(), url: "http://wdcit02:31700/buildingwaitaki/ReceiveResults")
        
    }
    
    func post(params : NSData, url : String)
    {
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("responseString = \(responseString)")
        }
        task.resume()
    }
}

