//
//  OfficeTools.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 8/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class OfficeTools {
    let managedContext: NSManagedObjectContext
  //  let dataTransfer: DataTransfer
    let controller: UIViewController
    let displayConsents: DisplayConsents
    let background: UIView
    
    init(managedContext: NSManagedObjectContext, controller: UIViewController, displayConsents: DisplayConsents, background: UIView)
    {
        self.managedContext = managedContext
     //   self.dataTransfer = DataTransfer(managedContext: self.managedContext)
        self.controller = controller
        self.displayConsents = displayConsents
        self.background = background
    }
    
    func getInspectionTypes()
    {
        let inspectionTypes :OfficeToolsInspectionTypes
        inspectionTypes = OfficeToolsInspectionTypes(managedContext: managedContext, controller: controller)
        inspectionTypes.getInspectionTypes()
    }
    
    //return back bool if items still need to be synced
    func getConsents() -> Bool
    {
        let officeToolsGetConsents : OfficeToolsGetConsents
        officeToolsGetConsents = OfficeToolsGetConsents(managedContext: managedContext, controller: controller,displayConsents: displayConsents,background: background)
        officeToolsGetConsents.getConcents()
        
        return true
    }
    
    func checkInspectionStatus(consentInspection: ConsentInspection) -> String
    {
        let officeToolsGetConsents = OfficeToolsCheckInspection()
        let result =  officeToolsGetConsents.checkInspectionStatus(consentInspection, managedContext: managedContext)
        return result
    }
    

    

    
    

}
