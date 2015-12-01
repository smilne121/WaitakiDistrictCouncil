//
//  InspectionCommentsViewController.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 22/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import UIKit
import CoreData

class InspectionCommentsViewController: UIViewController, UITextViewDelegate {

    var consentInspection: ConsentInspection!
    var managedContext: NSManagedObjectContext!
    var needsInfo: NSNumber!
    var textView: UITextView?
    var itemName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layer.cornerRadius = 10
        for subview in self.view.subviews
        {
            subview.layer.cornerRadius = 10
        }
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOpacity = 0.7
        self.view.layer.shadowOffset = CGSize(width: CGFloat(10), height: CGFloat(10))
        self.view.layer.shadowRadius = 5.0
        self.view.layer.masksToBounds = false
        
        

        // Do any additional setup after loading the view.
        textView = UITextView(frame: CGRect(x: 10, y: 10, width: 480, height: 350))
        
        textView!.layer.borderWidth = CGFloat(1)
        textView!.layer.cornerRadius = CGFloat(5)
        textView!.font = AppSettings().getTextFont()
        textView!.delegate = self
        textView!.becomeFirstResponder()
        textView!.keyboardAppearance = UIKeyboardAppearance.Dark
        textView!.backgroundColor = AppSettings().getBackgroundColour()
        textView!.textColor = AppSettings().getTextColour()
        
        
        self.view.backgroundColor = UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 0.8)
        
        
        if consentInspection.locked == true
        {
            textView!.editable = false
        }
        
        for item in consentInspection.inspectionItem.allObjects as! [ConsentInspectionItem]
        {
            if item.itemName == itemName
            {
                print(item)
                if let comment = item.itemComment
                {
                    textView!.text = comment
                }
            }
        }
        
        
        let btnClose = UIButton(type: UIButtonType.System)
        btnClose.frame = CGRect(x: 175, y: 370, width: 150, height: 50)
        btnClose.setTitle("Done", forState: .Normal)
        btnClose.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchUpInside)
        btnClose.layer.borderColor = UIColor.blackColor().CGColor
        btnClose.layer.borderWidth = 1
        btnClose.layer.backgroundColor = AppSettings().getBackgroundColour().CGColor
        btnClose.tintColor = AppSettings().getTintColour()
        btnClose.titleLabel?.font = AppSettings().getTextFont()

        self.view.addSubview(textView!)
        self.view.addSubview(btnClose)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close (sender: UIButton)
    {
        if let mustEnter = needsInfo
        {
        if mustEnter == NSNumber(bool: true)
        {
            if self.textView?.text != ""
            {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            else
            {
                var popup = UIAlertController(title: "You must enter a reason",
                    message: "Write a comment and press done",
                    preferredStyle: .Alert)
                
                
            
                popup.addAction(UIAlertAction(title: "OK",
                    style: UIAlertActionStyle.Default,
                    handler:nil))
                
                popup = AppSettings().getPopupStyle(popup)
            
                self.presentViewController(popup, animated: true, completion: nil)
            }
        }
        else
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        }
        else
        {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        
    }
    
    func textViewDidChange(textView: UITextView)
    {
        if consentInspection.locked != NSNumber(bool: true)
        {
            let fetchRequest = NSFetchRequest(entityName: "ConsentInspectionItem")
                    
                    let resultPredicate1 = NSPredicate(format: "inspectionName = %@", consentInspection.inspectionName)
                    let resultPredicate2 = NSPredicate(format: "itemName = %@", itemName)
                    let resultPredicate3 = NSPredicate(format: "consentId = %@", consentInspection.consentId)
                    let compound = NSCompoundPredicate(andPredicateWithSubpredicates: [resultPredicate1,resultPredicate2,resultPredicate3])
                    fetchRequest.predicate = compound
                    
                    if let fetchResults = (try? managedContext.executeFetchRequest(fetchRequest)) as? [ConsentInspectionItem] {
                        if fetchResults.count != 0
                        {
                            let managedObject = fetchResults[0]
                            //check if comments item
                            if itemName == "Comments"
                            {
                            managedObject.itemResult = "See comments box..."
                            }
                            managedObject.itemComment = textView.text
                            
                            managedObject.consentInspection.needSynced = NSNumber(bool: true) //add to need synced
                            
                            do {
                                try managedContext.save()
                            } catch _ {
                            }
                }
            }
        }
    }

    

}
