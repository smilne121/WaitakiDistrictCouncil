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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
   
        
        //initilize globle objects for use
        // Retreive the managedObjectContext from AppDelegate
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        officeTools = OfficeTools(managedContext: managedObjectContext!,controller: self)

        
        
        
  //      let consentManager = ConsentManager(managedContext: managedObjectContext!)
        
        //consentManager.createConsent("102020", consentAddress: "35 Clyde Street", consentDescription: "Test consent create")
        
       // let consentTest = NSEntityDescription.insertNewObjectForEntityForName("Consent", inManagedObjectContext: managedObjectContext!) as! Consent
     //   consentTest.save()
        
       // consentTest.deleteMe()
        
        //dataTransfer.testReadFromCore()
        //dataTransfer.testWriteToCore(managedObjectContext!)
        //dataTransfer.testReadFromCore(managedObjectContext!)
        
    }
    
    @IBAction func getConsents(sender: UIButton)
    {
        officeTools!.getConsents()
    }
    
    @IBAction func getInspectionTypes(sender: UIButton) {
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

