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
        let lightBlur = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        let blurView = UIVisualEffectView(effect: lightBlur)
        blurView.frame = controller.view.bounds
        controller.view.addSubview(blurView)
        
        
        //var error: NSError?
        let fetchRequest = NSFetchRequest(entityName: "ConsentInspection")
        let resultPredicate = NSPredicate(format: "needSynced = %@", NSNumber(bool: true))
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        
        fetchRequest.predicate = resultPredicate
        
        let items = (try! managedContext.executeFetchRequest(fetchRequest)) as! [ConsentInspection]
        
        let resultConsents = ResultTransferArray(consents: items)
        
        resultsToJson(resultConsents)
    }
    
    func resultsToJson(consentInspectionItems:ResultTransferArray)
    {
       let settings = AppSettings()
      //  println(consentInspectionItems.toJson())
        post(consentInspectionItems.toJson(), url: settings.getAPIServer()! + "/buildingwaitaki/ReceiveResults")
    }
    
    func post(params : NSData, url : String)
    {
       // var result = ""
        let request = NSMutableURLRequest(URL: NSURL(string: url)!)
        request.HTTPMethod = "POST"
        request.HTTPBody = params
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                //remove blur effect
                for curView in self.controller.view.subviews
                {
                    if curView.isKindOfClass(UIVisualEffectView)
                    {
                        curView.removeFromSuperview()
                    }
                }
                print("error=\(error)")
                self.controller.sendInspectionsComplete("\"result\": \"failed\",\"error\", '\"\(error)\"");
                return
            }
            else
            {
                let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
                //remove blur effect
                for curView in self.controller.view.subviews
                {
                    if curView.isKindOfClass(UIVisualEffectView)
                    {
                        curView.removeFromSuperview()
                    }
                }
                if responseString as! String == "{\"result\": \"success\"}"
                {
                    let existingRequest = NSFetchRequest(entityName: "ConsentInspection")
                    let resultPredicate1 = NSPredicate(format: "needSynced = %@", NSNumber(bool: true))
                    existingRequest.predicate = resultPredicate1
                    let inspectionArray = (try? self.managedContext.executeFetchRequest(existingRequest)) as? [ConsentInspection]
                    for inspection: ConsentInspection in inspectionArray!
                    {
                        inspection.needSynced = NSNumber(bool: false)
                    }
                    do {
                        try self.managedContext.save()
                    } catch _ {
                    }
                }
            self.controller.sendInspectionsComplete(responseString as! String);
        }
        }
        task.resume()
            
    }
}

