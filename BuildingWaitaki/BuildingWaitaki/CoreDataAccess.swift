//
//  CoreDataAccess.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 30/05/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class CoreDataAccess {
    let managedContext: NSManagedObjectContext
    
    init(managedContext: NSManagedObjectContext)
    {
        self.managedContext = managedContext
    }
    
    func save (inspectionType: InspectionType, update: Bool)
    {
            if (!update)
            {
            /*    let newInspectionType = NSEntityDescription.insertNewObjectForEntityForName("InspectionType", inManagedObjectContext: managedContext) as! InspectionType
                newInspectionType.inspectionId = inspectionType.inspectionId
                newInspectionType.inspectionName = inspectionType.inspectionName
                
                newInspectionType.man
                
                
                var error :NSError?
                if !managedContext.save(&error)
                {
                    println("Could not save \(error), \(error?.userInfo)")
                }*/

            }
    }
    
}
