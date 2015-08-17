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
        self.controller = controller
        self.displayConsents = displayConsents
        self.background = background
    }
    
    func getInspectionTypes()
    {
        let settings = AppSettings()
        if verifyUrl(settings.getAPIServer())
        {
            let inspectionTypes :OfficeToolsInspectionTypes
            inspectionTypes = OfficeToolsInspectionTypes(managedContext: managedContext, controller: controller)
            inspectionTypes.getInspectionTypes()
        }
    }
    
    func sendResults()
    {
        let settings = AppSettings()
        if verifyUrl(settings.getAPIServer())
        {
            let sendInspections = OfficeToolsSendInspections(managedContext: managedContext,controller: controller as! HomeController)
            sendInspections.getResults()
        }
    }
    
    //return back bool if items still need to be synced
    func getConsents() -> Bool
    {
        let settings = AppSettings()
        if verifyUrl(settings.getAPIServer())
        {
            let officeToolsGetConsents : OfficeToolsGetConsents
            officeToolsGetConsents = OfficeToolsGetConsents(managedContext: managedContext, controller: controller,displayConsents: displayConsents,background: background)
            officeToolsGetConsents.getConcents()
        
            return true
        }
        return false
    }
    
    func checkInspectionStatus(consentInspection: ConsentInspection) -> String
    {
        let officeToolsGetConsents = OfficeToolsCheckInspection()
        let result =  officeToolsGetConsents.checkInspectionStatus(consentInspection, managedContext: managedContext)
        return result
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                
                if UIApplication.sharedApplication().canOpenURL(url) == false
                {
                    var popup:UIAlertController
                    popup = UIAlertController(title: "Api server not vaild",
                        message: "Please enter a valid api server",
                        preferredStyle: .Alert)
                    
                    popup.addAction(UIAlertAction(title: "Ok",
                        style: UIAlertActionStyle.Cancel,
                        handler: nil))
                    
                    controller.presentViewController(popup, animated: true, completion: nil)

                }
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
               return false
    }
    
    func generateReport(name: String, inspection: ConsentInspection)
    {    
        let genPDF = GeneratePDF(name: name, width: CGFloat(595), height: CGFloat(842), inspection: inspection)
    }
    

    

    
    

}
