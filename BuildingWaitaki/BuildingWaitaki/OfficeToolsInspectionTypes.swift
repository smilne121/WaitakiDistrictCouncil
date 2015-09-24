//
//  OfficeToolsInspectionTypes.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 10/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class OfficeToolsInspectionTypes {
    let managedContext: NSManagedObjectContext
   // let dataTransfer: DataTransfer
    let controller: UIViewController
    
    init(managedContext: NSManagedObjectContext, controller: UIViewController)
    {
        self.managedContext = managedContext
      //  self.dataTransfer = DataTransfer(managedContext: self.managedContext)
        self.controller = controller
    }
    
    func getInspectionTypes()
    {
        //var to hold the json string from server
        var inspectionTypes: String?
        let settings = AppSettings()
        let url = NSURL(string: settings.getAPIServer()! + "/buildingwaitaki/getinspectiontypes") //update to use stored property
        let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
            print(data)
            if data != nil
            {
            inspectionTypes = String(NSString(data: data!, encoding: NSUTF8StringEncoding)!)
            let popupMessage: String
            var popupExtra = ""
            
            if (inspectionTypes != "" && (inspectionTypes!.rangeOfString("Error 404") == nil))
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
            
            var popup = UIAlertController(title: popupMessage,
                message: popupExtra,
                preferredStyle: .Alert)
            
            popup.addAction(UIAlertAction(title: "OK",
                style: .Cancel,
                handler: self.ClosePopup))
            
            popup = AppSettings().getPopupStyle(popup)

            self.controller.presentViewController(popup, animated: true, completion: nil)
            }
        }
        task.resume()
    }
    
    func JSONInspectionTypeToObject(JSONString: String)
    {
        print(JSONString)
    //    var error: NSError?
        //remove existing inspection types
        let fetchRequest = NSFetchRequest(entityName: "InspectionType")
        fetchRequest.includesSubentities = false
        fetchRequest.returnsObjectsAsFaults = false
        
        let fetchRequest2 = NSFetchRequest(entityName: "InspectionTypeItems")
        fetchRequest2.includesSubentities = false
        fetchRequest2.returnsObjectsAsFaults = false
        
        let items = try! managedContext.executeFetchRequest(fetchRequest)
        let items2 = try! managedContext.executeFetchRequest(fetchRequest2)
        
        for item in items {
            managedContext.deleteObject(item as! NSManagedObject)
        }
        
        for item in items2 {
            managedContext.deleteObject(item as! NSManagedObject)
        }
        
        print("Number of Inspection Types: " + String(items.count) + " Number of Inspection Type Items:" + String(items2.count))
        print(items2)
        
       // var inspectionTypeObjectArray = [InspectionType]()
        //encode data string
        let JSONData = JSONString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
        //convert into an array
        let array = (try? NSJSONSerialization.JSONObjectWithData(JSONData!, options: NSJSONReadingOptions(rawValue: 0))) as? [AnyObject]
        //println(array)
        //loop throught the created array and create objects to store in core data
        
        if let myarray = array
        {
        for elem:AnyObject in myarray
        {
            let inspectionType = NSEntityDescription.insertNewObjectForEntityForName("InspectionType", inManagedObjectContext: managedContext) as! InspectionType
            inspectionType.inspectionId = (elem["inspectionId"] as! String)
            inspectionType.inspectionName = (elem["inspectionName"] as! String)
            let inspectionTypeItemsArray = (elem["inspectionItems"] as! NSArray)
            
            for inspectionTypeItem:AnyObject in inspectionTypeItemsArray
            {
                let newInspectionTypeItem = NSEntityDescription.insertNewObjectForEntityForName("InspectionTypeItems", inManagedObjectContext: managedContext) as! InspectionTypeItems
                newInspectionTypeItem.inspectionId = inspectionType.inspectionId //link back to inspection
                newInspectionTypeItem.inspectionType = inspectionType
                newInspectionTypeItem.itemId = inspectionTypeItem["itemId"] as! String
                newInspectionTypeItem.itemName = inspectionTypeItem["itemName"] as! String
                newInspectionTypeItem.itemType = inspectionTypeItem["itemType"] as! String
                newInspectionTypeItem.photosAllowed = inspectionTypeItem["photosAllowed"] as! NSNumber
                newInspectionTypeItem.required = inspectionTypeItem["required"] as! NSNumber
                newInspectionTypeItem.order = inspectionTypeItem["order"] as! String
                print(inspectionType)
            }
            //add inspection type to core data
            do {
                try managedContext.save()
            } catch let error1 as NSError {
                print("Could not save \(error1), \(error1.userInfo)")
            }
        }
        }
    }
        private func ClosePopup(alert: UIAlertAction!){
        }
        
    


}
