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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
        let textView = UITextView(frame: CGRect(x: 10, y: 10, width: 480, height: 350))
        
        textView.layer.borderWidth = CGFloat(1)
        textView.layer.cornerRadius = CGFloat(5)
        textView.font = UIFont(name: "HelveticaNeue", size: 18)
        textView.delegate = self
        
        if consentInspection.locked == true
        {
            textView.editable = false
        }
        
        for item in consentInspection.inspectionItem.allObjects as! [ConsentInspectionItem]
        {
            if item.itemName == "Comments"
            {
                println(item)
                if let comment = item.itemComment
                {
                    textView.text = comment
                }
            }
        }
        
        
        let btnClose = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        btnClose.frame = CGRect(x: 175, y: 370, width: 150, height: 50)
        btnClose.setTitle("Done", forState: .Normal)
        btnClose.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchUpInside)
        btnClose.layer.cornerRadius = 5.0
        btnClose.layer.borderColor = UIColor.blackColor().CGColor
        btnClose.layer.borderWidth = 1
        btnClose.layer.backgroundColor = UIColor.whiteColor().CGColor
        btnClose.tintColor = UIColor.blackColor()

        
        
        
        //textView.font = UIFont(name: textView.font.fontName, size: 18)
        self.view.addSubview(textView)
        self.view.addSubview(btnClose)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close (sender: UIButton)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func textViewDidChange(textView: UITextView)
    {
        if consentInspection.locked != NSNumber(bool: true)
        {
            var fetchRequest = NSFetchRequest(entityName: "ConsentInspectionItem")
                    
                    let resultPredicate1 = NSPredicate(format: "inspectionName = %@", consentInspection.inspectionName)
                    let resultPredicate2 = NSPredicate(format: "itemName = %@", "Comments")
                    let resultPredicate3 = NSPredicate(format: "consentId = %@", consentInspection.consentId)
                    var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1,resultPredicate2,resultPredicate3])
                    fetchRequest.predicate = compound
                    
                    if let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: nil) as? [ConsentInspectionItem] {
                        if fetchResults.count != 0
                        {
                            var managedObject = fetchResults[0]
                            managedObject.itemResult = "See comments box..."
                            managedObject.itemComment = textView.text
                            
                            managedObject.consentInspection.needSynced = NSNumber(bool: true) //add to need synced
                            
                            managedContext.save(nil)
                }
            }
        }
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
