//
//  ViewController.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 28/05/15.
//  Copyright (c) 2015 Scott Milne. All rights reserved.
//

import UIKit
import CoreData

class HomeController: UIViewController {
    var officeTools :OfficeTools!
    var displayConsents :DisplayConsents!
    var currentConsent: Consent?
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var consentScrollView: UIScrollView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var unfinishedInspectionsScrollview: UIScrollView!
    
    var searchActive : Bool = false
    
    override func viewWillAppear(animated: Bool) {
        var existingRequest = NSFetchRequest(entityName: "ConsentInspection")
        let resultPredicate1 = NSPredicate(format: "needSynced = %@", NSNumber(bool: true))
        let resultPredicate2 = NSPredicate(format: "locked = %@", NSNumber(bool: false))
        var compound1 = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1,resultPredicate2])
        var currentY = CGFloat(5)
        var height = CGFloat(50)
        
        let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        existingRequest.predicate = compound1
        
        let unfinishedInspections = managedContext!.executeFetchRequest(existingRequest, error: nil) as? [ConsentInspection]
        
        for inspection in unfinishedInspections!
        {
            let container = UIView(frame: CGRect(x: CGFloat(5), y: currentY, width: unfinishedInspectionsScrollview.frame.width - 10, height: height))
            container.backgroundColor = UIColor.whiteColor()
            container.layer.cornerRadius = 5.0
            
            
            let consentNumber = UILabel(frame: CGRect(x: 5, y: 5, width: container.frame.width, height: (height / 2) - 5))
            consentNumber.text = inspection.consentId
            
            let inspectionName = UILabel(frame: CGRect(x: 5, y: height / 2, width: container.frame.width , height: (height / 2) - 5))
            inspectionName.text = inspection.inspectionName
            
            currentY = currentY + height
            
            container.addSubview(consentNumber)
            container.addSubview(inspectionName)
            unfinishedInspectionsScrollview.addSubview(container)
            
            
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Retreive the managedObjectContext from AppDelegate
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        
        
        //display consents in core data
        displayConsents = DisplayConsents(scrollView: consentScrollView,managedContext: managedObjectContext!, searchBar: searchBar, homeController: self)
        displayConsents.displayConsents()
        
        officeTools = OfficeTools(managedContext: managedObjectContext!,controller: self,displayConsents: displayConsents, background: background)
        
        
        
    }
    
    @IBAction func getConsents(sender: UIButton)
    {
        searchBar.resignFirstResponder()
        officeTools!.getConsents()
    }
    
    @IBAction func getInspectionTypes(sender: UIButton) {
        searchBar.resignFirstResponder()
        officeTools!.getInspectionTypes()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //show the popup to allow settings to be set
    @IBAction func showPopover(sender:UIButton) {
        let settingsPopover = SettingPopover()
        settingsPopover.showPopover(sender, controller: self)
    }
    

    



}

