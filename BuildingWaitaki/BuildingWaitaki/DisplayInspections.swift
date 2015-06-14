//
//  DisplayInspections.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 13/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DisplayInspections{
    let view: UIView
    let managedContext: NSManagedObjectContext
    
    init (view: UIView, managedContext: NSManagedObjectContext)
    {
        self.managedContext = managedContext
        self.view = view
    }
    
    func displayInspections(consentNumber: String)
    {
        println("into inspections view")
        let inspectionsView: UIView
       // inspectionsView.d
        
        var error: NSError?
        //get consents inspection
        let fetchRequest = NSFetchRequest(entityName: "ConsentInspection")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        
        let resultPredicate = NSPredicate(format: "consentId = %@", consentNumber)
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate])
        fetchRequest.predicate = compound
        
        let consents = managedContext.executeFetchRequest(fetchRequest, error: nil)
        
         for consent in consents as! [Consent]
        {
            for contact in consent.contact.allObjects
            {
                let contact2 = contact as! Contact
                println(contact2.firstName)
            }
        }
        
    }
}
