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
    @NSManaged var consentConditions: String?
    @NSManaged var consentNumber: String
    @NSManaged var consentInspection: NSSet
    @NSManaged var contact: NSSet
    
    func filteredConsents() -> NSSet
    {
        var filteredSet = [ConsentInspection]()
        for inspection in consentInspection
        {
            if let status = (inspection as! ConsentInspection).status
            {
                if status == "failed"
                {
                    if checkFinalInspection(inspection as! ConsentInspection) //if this inspection has a newer passed or failed version
                    {
                    
                    }
                    else
                    {
                        filteredSet.append(inspection as! ConsentInspection) //need to add item to this set
                    }
                }
            }
        }
        
        let set :NSSet = NSSet(array: filteredSet)
        
        return set
    }
    
    private func checkFinalInspection(consentToCompare : ConsentInspection) -> Bool //if newer inspection has passed or failed return true
    {
        let myInspectionName : String = changeTitleToName(consentToCompare.inspectionName)
        let myinspectionSeq : Int = changeNameToSeq(consentToCompare.inspectionName)
        var result : Bool = false
        
        for inspection in consentInspection
        {
            let inspectionName = changeTitleToName((inspection as! ConsentInspection).inspectionName)
            
            if inspectionName == myInspectionName
            {
                let inspectionSeq = changeNameToSeq((inspection as! ConsentInspection).inspectionName)
                if inspectionSeq > myinspectionSeq
                {
                    if let status = (inspection as! ConsentInspection).status
                    {
                        if status == "passed" || status == "failed"
                        {
                            result = true
                        }
                    }
                }
            }
        }
        
        return result
    }
  
    
    
    
    private func changeTitleToName (inspectionName : String) -> String
    {
        let split = inspectionName.componentsSeparatedByString(" ")
        let splitResult: String = split[split.count]
        
        if let _ = Int(splitResult)
        {
            var stringBuild = ""
            
            for var index = 0; index < split.count - 1; ++index
            {
                stringBuild = stringBuild + split[index]
            }
            return stringBuild
            
        }
        else
        {
            var stringBuild = ""
            
            for var index = 0; index < split.count; ++index
            {
                stringBuild = stringBuild + split[index]
            }
            return stringBuild
        }

    }
    
    
    private func changeNameToSeq (inspectionName : String) -> Int
    {
        let split = inspectionName.componentsSeparatedByString(" ")
        let splitResult: String = split[split.count]
        
        if let mySeq = Int(splitResult)
        {
            return mySeq
        }
        else
        {
            return 1
        }
    }
}
