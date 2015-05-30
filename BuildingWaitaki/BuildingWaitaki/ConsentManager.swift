//
//  ConsentManager.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 30/05/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class ConsentManager{
    let managedContext: NSManagedObjectContext
    
    init(managedContext: NSManagedObjectContext)
    {
        self.managedContext = managedContext
    }
    
    func createConsent(consentNumber: String, consentAddress: String, consentDescription: String)
    {
        let newConsent = NSEntityDescription.insertNewObjectForEntityForName("Consent", inManagedObjectContext: managedContext) as! Consent
        newConsent.save()
        
        
    }
    
}
