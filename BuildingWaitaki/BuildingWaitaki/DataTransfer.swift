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
    let managedContext: NSManagedObjectContext
    
    init(managedContext: NSManagedObjectContext)
    {
       self.managedContext = managedContext
    }
    
    func getInspectionsTypesFromCoreData()
    {
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
    
    func testWriteToCore()
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
    
    func testReadFromCore()
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
