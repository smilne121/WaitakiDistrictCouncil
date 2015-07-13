//
//  OfficeToolsSendInspections.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 1/07/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class OfficeToolsSendInspections
{
    let managedContext : NSManagedObjectContext
    let controller: HomeController
    
    init(managedContext: NSManagedObjectContext, controller: HomeController)
    {
        self.managedContext = managedContext
        self.controller = controller
    }
    
    func getResults()
    {
        var lightBlur = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        var blurView = UIVisualEffectView(effect: lightBlur)
        blurView.frame = controller.view.bounds
        controller.view.addSubview(blurView)
        
        
        var error: NSError?
        let fetchRequest = NSFetchRequest(entityName: "ConsentInspection")
        let resultPredicate = NSPredicate(format: "needSynced = %@", NSNumber(bool: true))
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.predicate = resultPredicate
        
        let items = managedContext.executeFetchRequest(fetchRequest, error: &error)! as! [ConsentInspection]
        
        let resultConsents = ResultTransferArray(consents: items)
        
        resultsToJson(resultConsents)
    }
    
    func resultsToJson(consentInspectionItems:ResultTransferArray)
    {
        post(consentInspectionItems.toJson(), url: "http://wdcit02.waitakidc.govt.nz:31700/buildingwaitaki/ReceiveResults")
    }
    
    func post(params : NSData, url : String)
    {
        var result = ""
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
        
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            for curView in self.controller.view.subviews
            {
                if curView.isKindOfClass(UIVisualEffectView)
                {
                    curView.removeFromSuperview()
                }
            }
            //println(responseString)
            if responseString as! String == "{\"result\": \"success\"}"
            {
                var existingRequest = NSFetchRequest(entityName: "ConsentInspection")
                let resultPredicate1 = NSPredicate(format: "needSynced = %@", NSNumber(bool: true))
                existingRequest.predicate = resultPredicate1
                let inspectionArray = self.managedContext.executeFetchRequest(existingRequest, error: nil) as? [ConsentInspection]
                for inspection: ConsentInspection in inspectionArray!
                {
                    inspection.needSynced = NSNumber(bool: false)
                }
                self.managedContext.save(nil)
            }
            
            self.controller.sendInspectionsComplete(responseString as! String);
        }
        task.resume()
    }
}

