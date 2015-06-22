//
//  Consent.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 11/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class Consent: NSManagedObject {

    @NSManaged var consentAddress: String
    @NSManaged var consentDescription: String
    @NSManaged var consentNumber: String
    @NSManaged var consentInspection: NSSet
    @NSManaged var contact: NSSet
    
    /*func save()
    {
        var error :NSError?
        
        if !self.managedObjectContext!.save(&error)
        {
            println("Could not save \(error), \(error?.userInfo)")
        }
        else
        {
            var request = NSFetchRequest(entityName: "Consent")
        }
    }
    
    func delete()
    {
        self.managedObjectContext?.deleteObject(self)
        var error: NSError? = nil
        if !managedObjectContext!.save(&error) {
            println("Failed to delete the item \(error), \(error?.userInfo)")
        }
    }*/

}
