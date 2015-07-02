//
//  ViewController.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 28/05/15.
//  Copyright (c) 2015 Scott Milne. All rights reserved.
//

import UIKit
import CoreData

class HomeController: UIViewController, UIGestureRecognizerDelegate {
    var officeTools :OfficeTools!
    var displayConsents :DisplayConsents!
    var currentConsent: Consent?
    var managedObjectContext: NSManagedObjectContext?
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var consentScrollView: UIScrollView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var unfinishedInspectionsScrollview: UIScrollView!
    
    var searchActive : Bool = false
    
    override func viewWillAppear(animated: Bool) {
        //clear unfinished inspections list
        for view in unfinishedInspectionsScrollview.subviews
        {
            view.removeFromSuperview()
        }
        
        var existingRequest = NSFetchRequest(entityName: "ConsentInspection")
        let resultPredicate1 = NSPredicate(format: "needSynced = %@", NSNumber(bool: true))
        let resultPredicate2 = NSPredicate(format: "locked = %@", NSNumber(bool: false))
        var compound1 = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1,resultPredicate2])
        var currentY = CGFloat(5)
        var height = CGFloat(50)
        
        //let managedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        existingRequest.predicate = compound1
        
        let unfinishedInspections = managedObjectContext!.executeFetchRequest(existingRequest, error: nil) as? [ConsentInspection]
        
        for inspection in unfinishedInspections!
        {
            let container = UIView(frame: CGRect(x: CGFloat(5), y: currentY, width: unfinishedInspectionsScrollview.frame.width - 10, height: height))
            container.backgroundColor = UIColor.whiteColor()
            container.layer.cornerRadius = 5.0
            
            let tap = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
            tap.delegate = self
            container.addGestureRecognizer(tap)
            
            
            let consentNumber = UILabel(frame: CGRect(x: 5, y: 5, width: container.frame.width, height: (height / 2) - 5))
            consentNumber.text = inspection.consentId
            
            let inspectionName = UILabel(frame: CGRect(x: 5, y: height / 2, width: container.frame.width , height: (height / 2) - 5))
            inspectionName.text = inspection.inspectionName
            
            let image: UIImage
            if inspection.status == "failed"
            {
                image = UIImage(named: "red.png") as UIImage!
            }
            else if inspection.status == "passed"
            {
                image  = UIImage(named: "green.png") as UIImage!
            }
            else
            {
                image  = UIImage(named: "todo.png") as UIImage!
            }
            
            let statusImage = UIImageView(frame: CGRect(x: CGFloat(container.frame.width - 25), y: CGFloat(5), width: CGFloat(20), height: CGFloat(20)))
            statusImage.image = image
            
            

            
            currentY = currentY + height
            
            container.addSubview(consentNumber)
            container.addSubview(inspectionName)
            container.addSubview(statusImage)
            unfinishedInspectionsScrollview.addSubview(container)
            
            
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Retreive the managedObjectContext from AppDelegate
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        
        
        //display consents in core data
        displayConsents = DisplayConsents(scrollView: consentScrollView,managedContext: managedObjectContext!, searchBar: searchBar, homeController: self)
        displayConsents.displayConsents()
        
        officeTools = OfficeTools(managedContext: managedObjectContext!,controller: self,displayConsents: displayConsents, background: background)
        
        
        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        let consentNumber = (sender.view?.subviews[0] as! UILabel).text
        let inspectionName = (sender.view?.subviews[1] as! UILabel).text
        
        //get the consent inspection Required
        var consentInspectionRequest = NSFetchRequest(entityName: "ConsentInspection")
        let resultPredicate1 = NSPredicate(format: "consentId = %@", consentNumber!)
        let resultPredicate2 = NSPredicate(format: "inspectionName = %@", inspectionName!)
        var compound1 = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1,resultPredicate2])
        consentInspectionRequest.predicate = compound1
        
        let currentInspection = managedObjectContext!.executeFetchRequest(consentInspectionRequest, error: nil)?.first as! ConsentInspection

        
        let currentInspectionController = self.storyboard!.instantiateViewControllerWithIdentifier("CurrentInspectionViewController") as! CurrentInspectionViewController
        currentInspectionController.consentInspection = currentInspection
        currentInspectionController.title = currentInspection.inspectionName
        currentInspectionController.managedContext = managedObjectContext
        self.navigationController!.pushViewController(currentInspectionController, animated: true)
    }
    
    @IBAction func sendInspections(sender: UIButton)
    {
        officeTools!.sendResults()
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

