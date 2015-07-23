//
//  OfficeToolsCheckInspection.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 22/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class OfficeToolsCheckInspection
{

    func checkInspectionStatus(consentInspection: ConsentInspection, managedContext: NSManagedObjectContext) -> String
{
    var passed = 0
    var failed = 0
    var uncomplete = 0
    
    //check if all required fields are completed
    var error: NSError?
    //get consents inspection
    let fetchRequest = NSFetchRequest(entityName: "InspectionTypeItems")
    fetchRequest.includesSubentities = true
    fetchRequest.returnsObjectsAsFaults = false
    let resultPredicate = NSPredicate(format: "inspectionId = %@", consentInspection.inspectionId)
    
    var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate])
    fetchRequest.predicate = compound
    
    //inspection items for selected inspection
    let inspectionItems = managedContext.executeFetchRequest(fetchRequest, error: nil) as! [InspectionTypeItems]
    let inspectionResults = consentInspection.inspectionItem.allObjects as! [ConsentInspectionItem]
    
    var requiredItemsCount = 0
    
    //loop through and match results to required fields
    for item in inspectionItems
    {
        if item.required == NSNumber(bool: true)
        {
            requiredItemsCount = requiredItemsCount + 1
            for result in inspectionResults
            {
                if item.itemId == result.itemId
                {
                    if let currentResult = result.itemResult
                    {
                        if item.itemType.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "L"
                        {
                            if result.itemResult!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "PASS" || result.itemResult!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "N/A"
                            {
                                passed = passed + 1
                            }
                            else
                            {
                                failed = failed + 1
                            }
                        }
                        else if item.itemType.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "T" || item.itemType.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "D" || item.itemType.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "NR"
                        {
                            if let test = result.itemResult
                            {
                                passed = passed + 1
                            }
                            else
                            {
                                uncomplete = uncomplete + 1
                            }
                        }
                    }
                    else
                    {
                        uncomplete = uncomplete + 1
                    }
                }
            }
        }
    }
    if passed == requiredItemsCount
    {
        return "passed"
    }
    else if (passed + failed) == requiredItemsCount
    {
        return "failed"
    }
    else
    {
        return ""
    }
    }}
