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
    @IBOutlet weak var background: UIView!
    @IBOutlet weak var consentScrollView: UIScrollView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var searchActive : Bool = false
    

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

