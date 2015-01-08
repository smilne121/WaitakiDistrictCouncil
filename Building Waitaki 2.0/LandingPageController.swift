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
    @IBOutlet weak var InspectionScrollView: UIScrollView!
    @IBOutlet weak var textboxUser: UITextField!
    @IBOutlet weak var textboxServer: UITextField!
    @IBOutlet weak var fullscreen: UIView!
    var currentInspection: Inspection!
  
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
        
        //Create test inspection
        if InspectionScrollView != nil
        {
            currentInspection = Inspection(Name: "Test Inspection")
            currentInspection.generateTestData(self, scrollview: InspectionScrollView)
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        if let eraseResults = managedObjectContext!.executeFetchRequest(eraseRequest, error: nil) as? [Settings]{
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
            
            println(fetchResults[0].serverAddress)
            println(fetchResults[0].user)
            
        }
       
    	
    
    }
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        println(textField.tag)
        currentInspection.loadCommentBox(textField, scrollView: InspectionScrollView, delegateControl: self, wholeScreen: self.fullscreen)
        return false
    }
    
    func textView(textView: UITextView!, shouldChangeCharactersInRange range: NSRange, replacementString text: String!) -> Bool
    {
        return countElements(textView.text) + (countElements(text) - range.length) <= 255
    }
}