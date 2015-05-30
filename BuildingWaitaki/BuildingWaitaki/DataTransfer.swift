//
//  DataTransfer.swift
//  BuildingWaitaki
//http://www.raywenderlich.com/85578/first-core-data-app-using-swift
//  Created by Scott Milne on 29/05/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class DataTransfer{
    func getInspectionTypes(){
            let url = NSURL(string: "http://wdcweb4.waitakidc.govt.nz:4242/buildingwaitaki/getinspectiontypes")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url!) {(data, response, error) in
                println(NSString(data: data, encoding: NSUTF8StringEncoding))
            }
            task.resume()
    }
    
    func testWriteToCore(managedContext: NSManagedObjectContext)
    {
        let newInspectionType = NSEntityDescription.insertNewObjectForEntityForName("InspectionType", inManagedObjectContext: managedContext) as! InspectionType
        newInspectionType.inspectionId = "001"
        newInspectionType.inspectionName = "Test inspection input"
        
        var error :NSError?
        if !managedContext.save(&error)
        {
            println("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func testReadFromCore(managedContext: NSManagedObjectContext)
    {
            // Create a new fetch request using the LogItem entity
            let fetchRequest = NSFetchRequest(entityName: "InspectionType")
        
            var error: NSError?
            
            // Execute the fetch request, and cast the results to an array of LogItem objects
            if let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [InspectionType]
            {
                // Create an Alert, and set it's message to whatever the itemText is
                println(fetchResults[0].inspectionId)
                println(fetchResults[0].inspectionName)
            }
            else
            {
                println("Could not fetch \(error), \(error!.userInfo)")
            }
    }
}
