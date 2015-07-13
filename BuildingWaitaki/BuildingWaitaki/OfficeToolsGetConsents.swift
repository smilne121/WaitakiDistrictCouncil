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
    let controller: UIViewController
    let displayConsents: DisplayConsents
    let background: UIView
    
    init(managedContext: NSManagedObjectContext, controller: UIViewController, displayConsents:DisplayConsents, background:UIView)
    {
        self.displayConsents = displayConsents
        self.managedContext = managedContext
        self.controller = controller
        self.background = background
    }
    
    func getConcents()
    {
        var needSynced = self.needSynced()
       
            var lightBlur = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
            var blurView = UIVisualEffectView(effect: lightBlur)
            blurView.frame = background.bounds
            background.addSubview(blurView)
        
        if (needSynced == 0)
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
                    //if consents downloaded process them
                    self.JSONConsentToObject(consents!)
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
    
    func JSONConsentToObject(JSONString: String)
    {
        println(JSONString)
        var error: NSError?
        //remove existing consents contacts and inspections
       let fetchRequest = NSFetchRequest(entityName: "Consent")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        
        let fetchRequest2 = NSFetchRequest(entityName: "Contact")
        fetchRequest2.includesSubentities = true
        fetchRequest2.returnsObjectsAsFaults = false
        
        let fetchRequest3 = NSFetchRequest(entityName: "ConsentInspection")
        fetchRequest3.includesSubentities = true
        fetchRequest3.returnsObjectsAsFaults = false
        
        let fetchRequest4 = NSFetchRequest(entityName: "ConsentInspectionItem")
        fetchRequest4.includesSubentities = true
        fetchRequest4.returnsObjectsAsFaults = false
        
        let items = managedContext.executeFetchRequest(fetchRequest, error: &error)!
        let items2 = managedContext.executeFetchRequest(fetchRequest2, error: &error)!
        let items3 = managedContext.executeFetchRequest(fetchRequest3, error: &error)!
        let items4 = managedContext.executeFetchRequest(fetchRequest4, error: &error)!
        
        for item in items {
            managedContext.deleteObject(item as! NSManagedObject)
        }
        
        for item in items2 {
            managedContext.deleteObject(item as! NSManagedObject)
        }
        
        for item in items3 {
            managedContext.deleteObject(item as! NSManagedObject)
        }
        
        for item in items4 {
            managedContext.deleteObject(item as! NSManagedObject)
        }
        
        var consentObjectArray = [Consent]()
        //encode data string
        let JSONData = JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        //convert into an array
        let array = NSJSONSerialization.JSONObjectWithData(JSONData!, options: NSJSONReadingOptions(0), error: nil) as? [AnyObject]
        
        println(array)
        
        //loop throught the created array and create objects to store in core data
        for elem:AnyObject in array!
        {
            let consent = NSEntityDescription.insertNewObjectForEntityForName("Consent", inManagedObjectContext: managedContext) as! Consent
            consent.consentAddress = (elem["consentAddress"] as! String)
            consent.consentDescription = (elem["consentDescription"] as! String)
            consent.consentNumber = (elem["consentNumber"] as! String)
            var consentContactsArray = (elem["contacts"] as! NSArray)
            var consentInspectionResultsArray = (elem["InspectionResults"] as! NSArray)
            var consentInspectionsArray = (elem["Inspections"] as! NSArray)
            
            for consentContact:AnyObject in consentContactsArray
            {
                let newConsentContact = NSEntityDescription.insertNewObjectForEntityForName("Contact", inManagedObjectContext: managedContext) as! Contact
                newConsentContact.firstName = consentContact["firstName"] as! String
                newConsentContact.lastName = consentContact["lastName"] as! String
                newConsentContact.homePhone = consentContact["homePhone"] as! String
                newConsentContact.cellPhone = consentContact["cellPhone"] as! String
                newConsentContact.position = consentContact["position"] as! String
                newConsentContact.consentNumber = consent.consentNumber
                newConsentContact.consent = consent
            }
            
            
            for consentInspection:AnyObject in consentInspectionsArray
            {
                    let newConsentInspection = NSEntityDescription.insertNewObjectForEntityForName("ConsentInspection", inManagedObjectContext: managedContext) as! ConsentInspection
                    newConsentInspection.consentId = consent.consentNumber

                        newConsentInspection.inspectionName = (consentInspection["InspectionName"] as! String).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                
                    newConsentInspection.inspectionId = consentInspection["InspectionId"] as! String
                    newConsentInspection.needSynced = NSNumber(bool: false)
                    newConsentInspection.userCreated = NSNumber(bool: false)
                    newConsentInspection.consent = consent
                
                //loop through based on inspectionId
                
                //get inspection items
                let fetchRequest = NSFetchRequest(entityName: "InspectionTypeItems")
                fetchRequest.includesSubentities = true
                fetchRequest.returnsObjectsAsFaults = false
                let resultPredicate = NSPredicate(format: "inspectionId = %@", newConsentInspection.inspectionId)
                
                var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate])
                fetchRequest.predicate = compound
                
                let inspectionItems = managedContext.executeFetchRequest(fetchRequest, error: nil) as! [InspectionTypeItems]
                
                for consentInspectionItem in inspectionItems
                {
                    let newInspectionItem = NSEntityDescription.insertNewObjectForEntityForName("ConsentInspectionItem", inManagedObjectContext: managedContext) as! ConsentInspectionItem
                    newInspectionItem.consentId = consent.consentNumber
                    newInspectionItem.inspectionId = newConsentInspection.inspectionId
                    newInspectionItem.itemId = consentInspectionItem.itemId
                    newInspectionItem.itemName = consentInspectionItem.itemName
                    newInspectionItem.inspectionName = newConsentInspection.inspectionName
                   
                    println(consentInspectionResultsArray)
                    for consentInspectionResults:AnyObject in consentInspectionResultsArray
                    {
                        let resultName = (consentInspectionResults["InspectionName"] as! String).stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                        let inspectionName = newInspectionItem.inspectionName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                        if inspectionName == resultName
                        {
                            if newInspectionItem.itemId == consentInspectionResults["ItemId"] as! String
                            {
                             newInspectionItem.itemResult = consentInspectionResults["ItemResult"] as? String
                            }
                        }
                    }
                    
                    newInspectionItem.consentInspection = newConsentInspection
                }
                let checkInspectionStatus = OfficeToolsCheckInspection()
                newConsentInspection.status = checkInspectionStatus.checkInspectionStatus(newConsentInspection, managedContext: managedContext)
                if newConsentInspection.status != ""
                {
                    newConsentInspection.locked = NSNumber(bool: true)
                }
                else
                {
                    newConsentInspection.locked = NSNumber(bool: false)
                }
            }

            //add consent to core data
            if !managedContext.save(&error)
            {
                println("Could not save \(error), \(error?.userInfo)")
            }
        }
    }
    
    private func ClosePopup(alert: UIAlertAction!){
        displayConsents.displayConsents()
    
        for view in self.background.subviews
        {
            if view.isKindOfClass(UIVisualEffectView)
            {
                view.removeFromSuperview()
            }
        }
    }
    
    private func needSynced() -> Int
    {
        let syncNeededRequest = NSFetchRequest(entityName: "ConsentInspection")
        syncNeededRequest.includesSubentities = false
        syncNeededRequest.returnsObjectsAsFaults = false
        let resultPredicate = NSPredicate(format: "needSynced = %@", NSNumber(bool: true))
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate])
        syncNeededRequest.predicate = compound
        
        //check if any inspections need synced
        var results:NSArray = managedContext.executeFetchRequest(syncNeededRequest, error: nil)!
        
        return results.count
    }
    
        
    
}
