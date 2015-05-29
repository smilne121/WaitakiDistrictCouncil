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
    
    func testWriteToCore(appDelegate: AppDelegate)
    {
        let managedContext = appDelegate.managedObjectContext!
        let entity = NSEntityDescription.entityForName("InspectionType", inManagedObjectContext: managedContext)
        let inspectionType = NSManagedObject(entity: entity!, insertIntoManagedObjectContext: managedContext)
        inspectionType.setValue("testinspectionid", forKey: "inspectionId")
        inspectionType.setValue("testinspectionname", forKey: "inspectionName")
        
        var error :NSError?
        if !managedContext.save(&error)
        {
            println("error writing to core data")
        }
    }
    
    func testReadFromCore(appDelegate: AppDelegate)
    {
        let managedContext = appDelegate.managedObjectContext!
        let fetchRequest = NSFetchRequest(entityName: "InspectionType")
        var error: NSError?
        
        let fetchedResults = managedContext.executeFetchRequest(fetchRequest, error: &error) as? [NSManagedObject]
        
        if let results = fetchedResults {
            println(results)
        }
        else
        {
        println("error")
        }}
}
