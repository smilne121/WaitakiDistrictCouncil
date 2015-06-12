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
    var currentY: CGFloat
    var currentX: CGFloat
    
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
        //remove exsiting consents from view to repopulate
        for view in self.scrollView.subviews
        {
            if (view.backgroundColor == UIColor.whiteColor())
            {
                view.removeFromSuperview()
            }
        }
        
        
        let fontsize :CGFloat
        fontsize = 15
        currentY = 50
            for consent in self.getConsentsFromCoreData() as! [Consent]
            {
                let containerRect: CGRect = CGRect(x: 10,y: currentY,width: 475,height: 105)
                let container: UIView = UIView(frame: containerRect)
                container.backgroundColor = UIColor.whiteColor()
                container.tintColor = UIColor.blackColor()
                
                let lblConsentNumber = UILabel(frame: CGRect(x: 8,y: 8,width: 71,height: 21))
                lblConsentNumber.text = "Consent:"
                
                let myConsentNumber = UILabel(frame: CGRect(x: 390,y: 8,width: 100,height: 21))
                myConsentNumber.font = UIFont(name: myConsentNumber.font.fontName, size: fontsize)
                myConsentNumber.text = consent.consentNumber
                
                let myConsentAddress = UILabel(frame: CGRect(x: 10,y: 8,width: 323,height: 21))
                myConsentAddress.font = UIFont(name: myConsentAddress.font.fontName, size: fontsize)
                myConsentAddress.text = consent.consentAddress
                
                let btnLocation = UIButton.buttonWithType(UIButtonType.System) as! UIButton
                btnLocation.frame = CGRectMake(20, 40, 60, 60)
                let imgLocation = UIImage(named: "Map-50.png") as UIImage!
                btnLocation.setImage(imgLocation, forState: .Normal)
                
                let btnComments = UIButton.buttonWithType(UIButtonType.System) as! UIButton
                btnComments.frame = CGRectMake(container.layer.frame.width / 2 - 30, 40, 60, 60)
                let imgComments = UIImage(named: "Speech Bubble-50.png") as UIImage!
                btnComments.setImage(imgComments, forState: .Normal)
                
                let btnContacts = UIButton.buttonWithType(UIButtonType.System) as! UIButton
                btnContacts.frame = CGRectMake(container.layer.frame.width - 80, 40, 60, 60)
                let imgContacts = UIImage(named: "Contacts-50.png") as UIImage!
                btnContacts.setImage(imgContacts, forState: .Normal)
                
                
                //update value of y
                currentY = (container.frame.origin.y + container.frame.height + 20)
                
                scrollView.contentSize = CGSize(width: scrollView.frame.width, height: (currentY + container.frame.height + 50))
                
                //add items to parents
                container.addSubview(myConsentNumber)
                container.addSubview(myConsentAddress)
                container.addSubview(btnComments)
                container.addSubview(btnContacts)
                container.addSubview(btnLocation)
                scrollView.addSubview(container)
        }
    
}
}
