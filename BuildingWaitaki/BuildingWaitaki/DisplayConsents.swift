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

class DisplayConsents : NSObject, UISearchBarDelegate, UIGestureRecognizerDelegate{
    let managedContext: NSManagedObjectContext
    let scrollView: UIScrollView
    var currentY: CGFloat
    var currentX: CGFloat
    var searchBar: UISearchBar
    var searchActive : Bool = false
    let homeController : HomeController
    var currentConsent : Consent?
    
    
    init (scrollView: UIScrollView,managedContext: NSManagedObjectContext,searchBar:UISearchBar, homeController: HomeController)
    {
        self.homeController = homeController
        self.scrollView = scrollView
        self.managedContext = managedContext
        self.currentX = 0
        self.currentY = 0
        self.searchBar = searchBar
        super.init()
        searchBar.delegate = self
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
    
    func getConsentsFromCoreData(searchString: String) -> [AnyObject]
    {
        var error: NSError?
        //remove existing consents contacts and inspections
        let fetchRequest = NSFetchRequest(entityName: "Consent")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        let resultPredicate = NSPredicate(format: "consentAddress contains %@", searchString)
        let resultPredicate2 = NSPredicate(format: "consentNumber contains %@", searchString)
        var compound = NSCompoundPredicate.orPredicateWithSubpredicates([resultPredicate,resultPredicate2])
        fetchRequest.predicate = compound
        fetchRequest.relationshipKeyPathsForPrefetching = ["contact","consentInspection"]
        
        let consents = managedContext.executeFetchRequest(fetchRequest, error: &error)!

        return consents
    }
    
    
    func displayConsents(search : String)
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
        for consent in self.getConsentsFromCoreData(search) as! [Consent]
        {
            let containerRect: CGRect = CGRect(x: 10,y: currentY,width: 475,height: 105)
            let container: UIView = UIView(frame: containerRect)
            container.layer.borderColor = UIColor .blackColor().CGColor
            container.layer.borderWidth = 3.0
            container.backgroundColor = UIColor.whiteColor()
            container.tintColor = UIColor.blackColor()
            
            let tap = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
            tap.delegate = self
            container.addGestureRecognizer(tap)
            
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
    
    func displayConsents()
    {
        if !searchActive
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
                container.layer.borderColor = UIColor .blackColor().CGColor
                container.layer.borderWidth = 3.0
                container.backgroundColor = UIColor.whiteColor()
                container.tintColor = UIColor.blackColor()
                
                let tap = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
                tap.delegate = self
                container.addGestureRecognizer(tap)
                
                
                
              //  let lblConsentNumber = UILabel(frame: CGRect(x: 8,y: 8,width: 71,height: 21))
              //  lblConsentNumber.text = "Consent:"
                
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
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
        displayConsents()
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        displayConsents(displayConsents(searchText))

    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        for view in sender.view!.subviews
        {
            if view.isKindOfClass(UILabel)
            {
                if view.frame == CGRect(x: 390,y: 8,width: 100,height: 21)
                {
                    //create a display inspections here.
                    let consentNumber = (view as! UILabel).text
                    
                    var error: NSError?
                    //get consents inspection
                    let fetchRequest = NSFetchRequest(entityName: "Consent")
                    fetchRequest.includesSubentities = true
                    fetchRequest.returnsObjectsAsFaults = false
                    
                    let resultPredicate = NSPredicate(format: "consentNumber = %@", consentNumber!)
                    
                    var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate])
                    fetchRequest.predicate = compound
                    
                    let consent = managedContext.executeFetchRequest(fetchRequest, error: nil)?.first as! Consent
                    
                    currentConsent = consent
                    
                    //goto new controller
                    let currentConsentViewController = homeController.storyboard!.instantiateViewControllerWithIdentifier("CurrentConsentViewController") as! CurrentConsentViewController
                    currentConsentViewController.currentConsent = currentConsent
                    currentConsentViewController.managedContext = managedContext
                    homeController.navigationController!.pushViewController(currentConsentViewController, animated: true)
                    
                    //push to new controller
                }
            }
        }
    }
}
