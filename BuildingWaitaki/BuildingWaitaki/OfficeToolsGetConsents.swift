//
//  OfficeToolsGetConsents.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 10/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class OfficeToolsGetConsents {
    let managedContext: NSManagedObjectContext
    let dataTransfer: DataTransfer
    let controller: UIViewController
    
    init(managedContext: NSManagedObjectContext, controller: UIViewController)
    {
        self.managedContext = managedContext
        self.dataTransfer = DataTransfer(managedContext: self.managedContext)
        self.controller = controller
    }
    
    func getConcents()
    {
        //check if inspections need synced to server first
        var error: NSError?
        //remove existing inspection types
    
    //add inspection type to core data
    if !managedContext.save(&error)
    {
    println("Could not save \(error), \(error?.userInfo)")
    }
        
        //end of test
    
    
        let syncNeededRequest = NSFetchRequest(entityName: "ConsentInspection")
        syncNeededRequest.includesSubentities = false
        syncNeededRequest.returnsObjectsAsFaults = false
        let resultPredicate = NSPredicate(format: "needSynced = %@", NSNumber(bool: true))
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate])
        syncNeededRequest.predicate = compound
        
        
        var results:NSArray = managedContext.executeFetchRequest(syncNeededRequest, error: nil)!
        if (results.count == 0)
        {
            let popupMessage: String
            
            
            
            //var to hold the json string from server
            var consents: String?
            let url = NSURL(string: "http://wdcweb4.waitakidc.govt.nz:4242/buildingwaitaki/getconsents") //update to use stored property
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                
                consents = String(NSString(data: data, encoding: NSUTF8StringEncoding)!)
                let popupMessage: String
                var popupExtra = ""
                
                if (consents != "")
                {
                    //if inspection types downloaded process them
                    self.JSONInspectionTypeToObject(consents!)
                    popupMessage = "Consent Sync Completed"
                }
                else
                {
                    popupMessage = "Consent Sync Failed"
                    popupExtra = "Please make sure you are connected to the network via Wifi or VPN"
                }
                
                let popup = UIAlertController(title: popupMessage,
                    message: popupExtra,
                    preferredStyle: .Alert)
                
                popup.addAction(UIAlertAction(title: "OK",
                    style: .Cancel,
                    handler: self.ClosePopup))
                
                self.controller.presentViewController(popup, animated: true, completion: nil)
                
            }
            task.resume()
        }
        else
        {
            let popupMessage: String
            popupMessage = "Unsynced Inspections"
            var popupExtra = "Inspections need synced before downloading new consents"
            let popup = UIAlertController(title: popupMessage,
                message: popupExtra,
                preferredStyle: .Alert)
            
            popup.addAction(UIAlertAction(title: "OK",
                style: .Cancel,
                handler: self.ClosePopup))
            
            self.controller.presentViewController(popup, animated: true, completion: nil)
        }
        
        
        
        
      }
    
    func JSONInspectionTypeToObject(JSONString: String)
    {
    }
    
    private func ClosePopup(alert: UIAlertAction!){
    }
    
    
}
