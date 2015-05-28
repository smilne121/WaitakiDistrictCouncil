//
//  LandingPageController.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 31/12/14.
//  Copyright (c) 2014 Waitaki District Council. All rights reserved.
//

import UIKit
import CoreData

class LandingPageController: UIViewController, UITextFieldDelegate,UITextViewDelegate {
    @IBOutlet weak var textboxUser: UITextField!
    @IBOutlet weak var textboxServer: UITextField!
    @IBOutlet weak var consentScrollView: UIScrollView!
    var consentManager: ConsentManager = ConsentManager()
    var networkManager: NetworkManager?
    var currentY: CGFloat = 0

  
    lazy var managedObjectContext : NSManagedObjectContext? = {
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let managedObjectContext = appDelegate.managedObjectContext {
            return managedObjectContext
        }
        else{
            return nil
        }
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readSettingsFromDevice()

        let networkManager: NetworkManager = NetworkManager(consentManager: consentManager)
        networkManager.getConsents(managedObjectContext!)
            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //CORE DATA SETUP
    
    @IBAction func draw()
    {
        drawConcents()
        drawConcents()
    }
    
    func readSettingsFromDevice()
    {
        
        let fetchRequest = NSFetchRequest(entityName:"Settings")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Settings]
        {
            if fetchResults.count > 0
            {
                // let server = fetchResults[0].serverAddress
                // let user = fetchResults[0].user
            
                println(fetchResults[0].serverAddress)
                println(fetchResults[0].user)
                if textboxServer != nil
                {
                    textboxServer.text = fetchResults[0].serverAddress
                }
                if textboxUser != nil
                {
                    textboxUser.text = fetchResults[0].user
                }
            }
            else
            {
                println("no data found")
            }
        }
    }
    
    //ALERTS
    
    func showAlert(title:String,  message:String)
    {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let defaultAction = UIAlertAction(title: "OK", style: .Default, handler:nil)
        
        alertController.addAction(defaultAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction
    func writeSettingToDevice(sender: UIButton)
    {
        //erase setting from core data
        let eraseRequest = NSFetchRequest(entityName:"Settings")
        if let eraseResults = managedObjectContext!.executeFetchRequest(eraseRequest, error: nil) as? [Settings]
        {
            if eraseResults.count > 0
            {
                self.managedObjectContext?.deleteObject(eraseResults[0])
                println("erased old")
            }
        }
        
        // write new values to core data
        var newItem = NSEntityDescription.insertNewObjectForEntityForName("Settings", inManagedObjectContext: self.managedObjectContext!) as Settings
        
        newItem.serverAddress = textboxServer.text!
        newItem.user = textboxUser.text!
        println("saved settings");
        showAlert("Saved",message: "")
        
        self.managedObjectContext!.save(nil)
        managedObjectContext?.save(nil)
  
        let fetchRequest = NSFetchRequest(entityName:"Settings")
        if let fetchResults = managedObjectContext!.executeFetchRequest(fetchRequest, error: nil) as? [Settings]{
            let server = fetchResults[0].serverAddress
            let user = fetchResults[0].user
        }
    }
    
    func drawConcents()
    {
        //if let consents = consentManager.getConsentArray()
   //     {
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
      //      }
        }
    }
    
    
    
    
    
    
    
    
}