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

class DisplayConsents : NSObject, UISearchBarDelegate, UIGestureRecognizerDelegate,UIPopoverPresentationControllerDelegate{
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
    
    func getConsentsFromCoreData(searchString: String?) -> [AnyObject]
    {
        var error: NSError?
        //remove existing consents contacts and inspections
        let fetchRequest = NSFetchRequest(entityName: "Consent")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        
        if let searchtext = searchString
        {
            let resultPredicate = NSPredicate(format: "consentAddress contains %@", searchtext)
            let resultPredicate2 = NSPredicate(format: "consentNumber contains %@", searchtext)
            var compound = NSCompoundPredicate.orPredicateWithSubpredicates([resultPredicate,resultPredicate2])
            fetchRequest.predicate = compound
        }
        
        fetchRequest.relationshipKeyPathsForPrefetching = ["contact","consentInspection"]
        let consents = managedContext.executeFetchRequest(fetchRequest, error: &error)!

        return consents
    }
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        return true
    }
    
    func displayConsents(search : String?)
    {
        //remove exsiting consents from view to repopulate
        for view in self.scrollView.subviews
        {
            if (view.tag == 100)
            {
                view.removeFromSuperview()
            }
        }
        
        
        let fontsize :CGFloat
        fontsize = 15
        currentY = 50
        
        var listOfConsents : [Consent]
        if let searchString = search
        {
            listOfConsents = self.getConsentsFromCoreData(searchString) as! [Consent]
        }
        else
        {
            listOfConsents = self.getConsentsFromCoreData(nil) as! [Consent]
        }
        
        for consent in listOfConsents
        {
            let settings = AppSettings()
            let containerRect: CGRect = CGRect(x: 10,y: currentY,width: 475,height: 105)
            let container: UIView = UIView(frame: containerRect)
            container.tag = 100
            
            let border = CALayer()
            border.backgroundColor = UIColor.grayColor().CGColor
            border.frame = CGRect(x: CGFloat(((container.frame.width - (container.frame.width - 50)) / 2)) , y: CGFloat(container.frame.height - 1), width: CGFloat(container.frame.width - 50), height: CGFloat(1))
            container.layer.addSublayer(border)
            
            container.backgroundColor = settings.getContainerBackground()
            container.tintColor = settings.getTintColour()
            
            let tap = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
            tap.delegate = self
            container.addGestureRecognizer(tap)
            
            let lblConsentNumber = UILabel(frame: CGRect(x: 8,y: 8,width: 71,height: 21))
            lblConsentNumber.text = "Consent:"
            
            let myConsentNumber = UILabel(frame: CGRect(x: 390,y: 8,width: 100,height: 21))
            myConsentNumber.font = settings.getTextFont()
            myConsentNumber.text = consent.consentNumber
            myConsentNumber.textColor = settings.getTextColour()
            
            let myConsentAddress = UILabel(frame: CGRect(x: 10,y: 8,width: 323,height: 21))
            myConsentAddress.font = settings.getTextFont()
            myConsentAddress.text = consent.consentAddress
            myConsentAddress.textColor = settings.getTextColour()
            
            let btnLocation = UIButton.buttonWithType(UIButtonType.System) as! UIButton
            btnLocation.frame = CGRectMake(20, 40, 60, 60)
            let imgLocation = UIImage(named: "Map-50.png") as UIImage!
            btnLocation.addTarget(self, action: "openMap:", forControlEvents: UIControlEvents.TouchUpInside)
            btnLocation.setImage(imgLocation, forState: .Normal)
            
            let btnComments = UIButton.buttonWithType(UIButtonType.System) as! UIButton
            btnComments.frame = CGRectMake(container.layer.frame.width / 2 - 30, 40, 60, 60)
            let imgComments = UIImage(named: "Speech Bubble-50.png") as UIImage!
            btnComments.addTarget(self, action: "displayDescription:", forControlEvents: UIControlEvents.TouchUpInside)
            btnComments.setImage(imgComments, forState: .Normal)

            
            let btnContacts = UIButton.buttonWithType(UIButtonType.System) as! UIButton
            btnContacts.frame = CGRectMake(container.layer.frame.width - 80, 40, 60, 60)
            let imgContacts = UIImage(named: "Contacts-50.png") as UIImage!
            btnContacts.addTarget(self, action: "showContacts:", forControlEvents: UIControlEvents.TouchUpInside)
            btnContacts.setImage(imgContacts, forState: .Normal)
            
            
            //update value of y
            currentY = (container.frame.origin.y + container.frame.height)
            
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
    
    func displayDescription(sender: UIButton)
    {
        var consentNumber = ""
        
        for view in sender.superview!.subviews
        {
            if view.isKindOfClass(UILabel)
            {
                if view.frame == CGRect(x: 390,y: 8,width: 100,height: 21)
                {
                    //create a display inspections here.
                    consentNumber = (view as! UILabel).text!
                }
            }
        }
        
        //get consent
        var error: NSError?
        //get consents inspection
        let fetchRequest = NSFetchRequest(entityName: "Consent")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        
        let resultPredicate = NSPredicate(format: "consentNumber = %@", consentNumber)
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate])
        fetchRequest.predicate = compound
        
        let consent = managedContext.executeFetchRequest(fetchRequest, error: nil)?.first as! Consent
        
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        var descViewController: DescriptionOfWorkViewController = storyboard.instantiateViewControllerWithIdentifier("DescriptionOfWorkViewController") as! DescriptionOfWorkViewController

        
        descViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        descViewController.preferredContentSize = CGSizeMake(CGFloat(500), CGFloat(350))
        
        descViewController.consent = consent
        
        let popoverMenuViewController = descViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = homeController.view
        popoverMenuViewController?.sourceRect = CGRectMake(homeController.view.frame.width / 2, homeController.view.frame.height / 2, 0,0)
        popoverMenuViewController?.permittedArrowDirections = UIPopoverArrowDirection.allZeros
        
        
        descViewController.modalInPopover = true
        descViewController.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        
        homeController.presentViewController(
            descViewController,
            animated: true,
            completion: nil)
        

        
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false
        searchBar.resignFirstResponder()
        displayConsents(nil)
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
        displayConsents(searchText)

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
    
    func showContacts (sender: UIButton)
    {
        var consentNumber = ""
        
        for view in sender.superview!.subviews
        {
            if view.isKindOfClass(UILabel)
            {
                if view.frame == CGRect(x: 390,y: 8,width: 100,height: 21)
                {
                    //create a display inspections here.
                     consentNumber = (view as! UILabel).text!
                }
            }
        }
        
        //get consent
        var error: NSError?
        //get consents inspection
        let fetchRequest = NSFetchRequest(entityName: "Consent")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        
        let resultPredicate = NSPredicate(format: "consentNumber = %@", consentNumber)
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate])
        fetchRequest.predicate = compound
        
        let consent = managedContext.executeFetchRequest(fetchRequest, error: nil)?.first as! Consent
        
        
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        var contactViewController: ContactsViewController = storyboard.instantiateViewControllerWithIdentifier("ContactsViewController") as! ContactsViewController
        
        
        //get height
        let height = (consent.contact.count * 50 + 70)
        
        contactViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        contactViewController.preferredContentSize = CGSizeMake(CGFloat(500), CGFloat(height))
        contactViewController.viewHeight = CGFloat(height)
        
        contactViewController.consent = consent
        var itemName = ""
        for view in sender.superview!.subviews
        {
            if view.isKindOfClass(UILabel)
            {
                itemName = (view as! UILabel).text!
            }
        }
        
        let popoverMenuViewController = contactViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = homeController.view
        popoverMenuViewController?.sourceRect = CGRectMake(homeController.view.frame.width / 2, homeController.view.frame.height / 2, 0,0)
        popoverMenuViewController?.permittedArrowDirections = UIPopoverArrowDirection.allZeros
        
        
        contactViewController.modalInPopover = true
        contactViewController.modalPresentationStyle = UIModalPresentationStyle.FullScreen
        
        homeController.presentViewController(
            contactViewController,
            animated: true,
            completion: nil)

    }
    
    func openMap (sender: UIButton)
    {
        for view in sender.superview!.subviews
        {
            if view.isKindOfClass(UILabel)
            {
                if view.frame == CGRect(x: 10,y: 8,width: 323,height: 21)
                {
                    if let address = (view as! UILabel).text
                    {let mapViewController = homeController.storyboard!.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
                    mapViewController.title = address
                    mapViewController.searchText = address + " Waitaki New Zealand"
                    homeController.navigationController!.pushViewController(mapViewController, animated: true)
                    }}
            }
        }
    }
}
