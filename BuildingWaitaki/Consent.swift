//
//  Consent.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 30/05/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class Consent: NSManagedObject {

    @NSManaged var consentNumber: String
    @NSManaged var consentAddress: String
    @NSManaged var consentDescription: String
    
    
    func save()
    {
        var error :NSError?
        
        if !self.managedObjectContext!.save(&error)
        {
            println("Could not save \(error), \(error?.userInfo)")
        }
        else
        {
            println("Saved consent: ")
            
            var request = NSFetchRequest(entityName: "Consent")
            
            println(self.managedObjectContext!.countForFetchRequest(request, error: nil))
        }
    }
    
    func delete()
    {
        self.managedObjectContext?.deleteObject(self)
        var error: NSError? = nil
        if !managedObjectContext!.save(&error) {
            println("Failed to delete the item \(error), \(error?.userInfo)")
        } else
        {
            println("deleted: " + self.consentNumber)
        }
    }

}
