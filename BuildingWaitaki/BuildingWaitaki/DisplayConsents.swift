//
//  DisplayConsents.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 12/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DisplayConsents {
    let managedContext: NSManagedObjectContext
    let scrollView: UIScrollView
    var currentY: Int
    var currentX: Int
    
    init (scrollView: UIScrollView, managedContext: NSManagedObjectContext)
    {
        self.scrollView = scrollView
        self.managedContext = managedContext
        self.currentX = 0
        self.currentY = 0
    }
    
    func getConsentsFromCoreData() -> [AnyObject]
    {
        var error: NSError?
        //remove existing consents contacts and inspections
        let fetchRequest = NSFetchRequest(entityName: "Consent")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.relationshipKeyPathsForPrefetching = ["contact","consentInspection"]
        
         let consents = managedContext.executeFetchRequest(fetchRequest, error: &error)!
       /* for consent in consents as! [Consent]
        {
            for contact in consent.contact.allObjects
            {
                let contact2 = contact as! Contact
                println(contact2.firstName)
            }
        }*/
        return consents
    }
    
    func displayConsents()
    {
            if currentY == 0
            {
                currentY = 14
            }
            for consent in consentManager.getConsentArray()
            {
                let containerRect: CGRect = CGRect(x: 25,y: currentY,width: 408,height: 105)
                let container: UIView = UIView(frame: containerRect)
                container.layer.cornerRadius = 5
                container.backgroundColor = UIColor.whiteColor()
                container.tintColor = UIColor.blackColor()
                
                let lblConsentNumber = UILabel(frame: CGRect(x: 8,y: 8,width: 71,height: 21))
                lblConsentNumber.text = "Consent:"
                
                let lblSiteAddress = UILabel(frame: CGRect(x: 8,y: 47,width: 71,height: 21))
                lblSiteAddress.text = "Address:"
                
                let myConsentNumber = UILabel(frame: CGRect(x: 77,y: 8,width: 323,height: 21))
                myConsentNumber.text = consent.consentNumber
                
                let mySiteAddress = UILabel(frame: CGRect(x: 77,y: 47,width: 323,height: 21))
                mySiteAddress.text = consent.siteAddress
                
                let btnSelect = UIButton.buttonWithType(UIButtonType.System) as UIButton
                btnSelect.frame = CGRectMake(20, 70, 110, 30)
                btnSelect.backgroundColor = UIColor.darkGrayColor()
                btnSelect.tintColor = UIColor.whiteColor()
                btnSelect.setTitle("Select", forState: UIControlState.Normal)
                btnSelect.layer.cornerRadius = 12.0
                
                //update value of y
                currentY = (container.frame.origin.y + container.frame.height + 20)
                
                consentScrollView.contentSize = CGSize(width: consentScrollView.frame.width, height: (currentY + container.frame.height + 50))
                
                //add items to parents
                container.addSubview(lblConsentNumber)
                container.addSubview(myConsentNumber)
                container.addSubview(lblSiteAddress)
                container.addSubview(mySiteAddress)
                container.addSubview(btnSelect)
                consentScrollView.addSubview(container)
    }
    
}
