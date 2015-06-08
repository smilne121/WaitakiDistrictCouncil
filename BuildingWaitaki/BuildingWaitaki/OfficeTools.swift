//
//  OfficeTools.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 8/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class OfficeTools {
    let managedContext: NSManagedObjectContext
    let dataTransfer: DataTransfer
    let controller: UIViewController
    
    var InspectionTypeArray = [InspectionType]()
    var InspectionTypeItemArray = [InspectionTypeItems]()
    
    init(managedContext: NSManagedObjectContext, controller: UIViewController)
    {
        self.managedContext = managedContext
        self.dataTransfer = DataTransfer(managedContext: self.managedContext)
        self.controller = controller
    }
    
    func getInspectionTypes()
    {
        var inspectionTypes: String?
        let url = NSURL(string: "http://wdcweb4.waitakidc.govt.nz:4242/buildingwaitaki/getinspectiontypes")
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in

            inspectionTypes = String(NSString(data: data, encoding: NSUTF8StringEncoding)!)
                     //   println(inspectionTypes)
            let popupMessage: String
            var popupExtra = ""
            
            if (inspectionTypes != "")
            {
                //if inspection types downloaded process them
                self.JSONInspectionTypeToObject(inspectionTypes!)
                popupMessage = "Inspection Type Sync Completed"
            }
            else
            {
                popupMessage = "Inspection Type Sync Failed"
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
    
    func JSONInspectionTypeToObject(JSONString: String)
    {
        var error: NSError?
        //remove existing inspection types
        let fetchRequest = NSFetchRequest(entityName: "InspectionType")
        fetchRequest.includesSubentities = false
        fetchRequest.returnsObjectsAsFaults = false
        
        let fetchRequest2 = NSFetchRequest(entityName: "InspectionTypeItems")
        fetchRequest2.includesSubentities = false
        fetchRequest2.returnsObjectsAsFaults = false
        let items2 = managedContext.executeFetchRequest(fetchRequest2, error: &error)!
        println(items2.count)

        
        
        let items = managedContext.executeFetchRequest(fetchRequest, error: &error)!
        
        for item in items {
            managedContext.deleteObject(item as! NSManagedObject)
        }
        if !managedContext.save(&error)
        {
            println("Could not save \(error), \(error?.userInfo)")
        }

        let items3 = managedContext.executeFetchRequest(fetchRequest2, error: &error)!
        println(items3.count)
        
        
        
        var inspectionTypeObjectArray = [InspectionType]()
        //encode data string
        let JSONData = JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        //convert into an array
        let array = NSJSONSerialization.JSONObjectWithData(JSONData!, options: NSJSONReadingOptions(0), error: nil) as? [AnyObject]
        //println(array)
        //loop throught the created array and create objects to store in core data
        
        
        for elem:AnyObject in array!
        {
            let inspectionType = NSEntityDescription.insertNewObjectForEntityForName("InspectionType", inManagedObjectContext: managedContext) as! InspectionType
            inspectionType.inspectionId = (elem["inspectionId"] as! String)
            inspectionType.inspectionName = (elem["inspectionName"] as! String)
            var inspectionTypeItemsArray = (elem["inspectionItems"] as! NSArray)
            
            
            //init the array of items for an inspection
            var inspectionItems = [InspectionTypeItems]()
            
            for inspectionTypeItem:AnyObject in inspectionTypeItemsArray
            {
                let newInspectionTypeItem = NSEntityDescription.insertNewObjectForEntityForName("InspectionTypeItems", inManagedObjectContext: managedContext) as! InspectionTypeItems
                newInspectionTypeItem.inspectionId = inspectionType.inspectionId //link back to inspection
                newInspectionTypeItem.itemId = inspectionTypeItem["itemId"] as! String
                newInspectionTypeItem.itemName = inspectionTypeItem["itemName"] as! String
                newInspectionTypeItem.itemType = inspectionTypeItem["itemType"] as! String
                newInspectionTypeItem.photosAllowed = inspectionTypeItem["photosAllowed"] as! NSNumber
                newInspectionTypeItem.required = inspectionTypeItem["required"] as! NSNumber
               // inspectionItems.append(newInspectionTypeItem)
                inspectionType.addInspectionTypeItem(newInspectionTypeItem)
                
            }
            //add inspection type to core data
            if !managedContext.save(&error)
            {
                println("Could not save \(error), \(error?.userInfo)")
            }
            }
        
    }

    
    private func ClosePopup(alert: UIAlertAction!){
    }
    
    

}
