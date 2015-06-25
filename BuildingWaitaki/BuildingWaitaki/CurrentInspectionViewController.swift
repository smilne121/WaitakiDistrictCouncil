//
//  CurrentInspectionViewController.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 15/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import UIKit
import CoreData

class CurrentInspectionViewController: UIViewController, UITextViewDelegate, UIPopoverPresentationControllerDelegate {
    var consentInspection : ConsentInspection!
    var inspectionTypeItems : [InspectionTypeItems]!
    var managedContext: NSManagedObjectContext!
    
    @IBOutlet weak var itemHolder: UIScrollView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        itemHolder.layer.borderWidth = 1
        itemHolder.contentInset = UIEdgeInsetsZero;
        itemHolder.scrollIndicatorInsets = UIEdgeInsetsZero;
        itemHolder.contentOffset = CGPointMake(0.0, 0.0);
        
        
        //call core data inspectiontypes to get items to display
        var error: NSError?
        //get consents inspection
        let fetchRequest = NSFetchRequest(entityName: "InspectionTypeItems")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        let resultPredicate = NSPredicate(format: "inspectionId = %@", consentInspection.inspectionId)
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate])
        fetchRequest.predicate = compound
        inspectionTypeItems = managedContext.executeFetchRequest(fetchRequest, error: nil) as! [InspectionTypeItems]
        
        generateItemsOnscreen()
        
        // Do any additional setup after loading the view.
        
        //load inspection items from consentinspection object
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateItemsOnscreen()
    {
        //ADD TOP BAR ICONS
        let btnConsentDetails = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        btnConsentDetails.frame = CGRectMake(20, 85, 120, 40)
        btnConsentDetails.setTitle("Consent Details", forState: .Normal)
        btnConsentDetails.layer.cornerRadius = 5.0
        btnConsentDetails.layer.borderColor = UIColor.blackColor().CGColor
        btnConsentDetails.layer.borderWidth = 1
        btnConsentDetails.layer.backgroundColor = UIColor.whiteColor().CGColor
        btnConsentDetails.tintColor = UIColor.blackColor()
        itemHolder.superview?.addSubview(btnConsentDetails)
        
        let btnComments = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        btnComments.frame = CGRectMake(200, 85, 150, 40)
        btnComments.setTitle("Comments", forState: .Normal)
        btnComments.layer.cornerRadius = 5.0
        btnComments.layer.borderColor = UIColor.blackColor().CGColor
        btnComments.addTarget(self, action: "loadCommentsView:", forControlEvents: UIControlEvents.TouchUpInside)
        btnComments.layer.borderWidth = 1
        btnComments.tintColor = UIColor.blackColor()
        btnComments.layer.backgroundColor = UIColor.whiteColor().CGColor
        itemHolder.superview?.addSubview(btnComments)
        
        let btnDeleteInspection = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        btnDeleteInspection.frame = CGRectMake(itemHolder.frame.width - 350, 85, 150, 40)
        btnDeleteInspection.setTitle("Delete Inspection", forState: .Normal)
        btnDeleteInspection.layer.cornerRadius = 5.0
        btnDeleteInspection.layer.borderColor = UIColor.blackColor().CGColor
        btnDeleteInspection.addTarget(self, action: "deleteThisInspection:", forControlEvents: UIControlEvents.TouchUpInside)
        btnDeleteInspection.layer.borderWidth = 1
        btnDeleteInspection.tintColor = UIColor.blackColor()
        btnDeleteInspection.layer.backgroundColor = UIColor.whiteColor().CGColor
        println(consentInspection.userCreated)
        if consentInspection.userCreated != NSNumber(bool: true)
        {
            btnDeleteInspection.enabled = false
        }
        itemHolder.superview!.addSubview(btnDeleteInspection)
        
        let btnEmail = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        btnEmail.frame = CGRectMake(itemHolder.superview!.frame.width - CGFloat(140), 85, 120, 40)
        btnEmail.setTitle("Email Report", forState: .Normal)
        btnEmail.layer.cornerRadius = 5.0
        btnEmail.layer.borderColor = UIColor.blackColor().CGColor
        btnEmail.layer.borderWidth = 1
        btnEmail.layer.backgroundColor = UIColor.whiteColor().CGColor
        btnEmail.tintColor = UIColor.blackColor()
        itemHolder.superview?.addSubview(btnEmail)
        
        //ADD BOTTOM BAR ICONS
        let btnFinished = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        btnFinished.frame = CGRectMake(20, itemHolder.superview!.frame.height - 80, 150, 40)
        btnFinished.setTitle("Finished", forState: .Normal)
        btnFinished.addTarget(self, action: "finishInspection:", forControlEvents: UIControlEvents.TouchUpInside)
        btnFinished.layer.cornerRadius = 5.0
        btnFinished.layer.borderColor = UIColor.blackColor().CGColor
        btnFinished.layer.borderWidth = 1
        btnFinished.tintColor = UIColor.blackColor()
        btnFinished.layer.backgroundColor = UIColor.whiteColor().CGColor
        itemHolder.superview?.addSubview(btnFinished)
        
        let btnClearInspection = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        btnClearInspection.frame = CGRectMake(itemHolder.superview!.frame.width / 2 - 75, itemHolder.superview!.frame.height - 80, 150, 40)
        btnClearInspection.setTitle("Clear inspection", forState: .Normal)
        btnClearInspection.layer.cornerRadius = 5.0
        btnClearInspection.layer.borderColor = UIColor.blackColor().CGColor
        btnClearInspection.layer.backgroundColor = UIColor.whiteColor().CGColor
        btnClearInspection.layer.borderWidth = 1
        btnClearInspection.addTarget(self, action: "clearInspectionResults:", forControlEvents: UIControlEvents.TouchUpInside)
        btnClearInspection.tintColor = UIColor.blackColor()
        itemHolder.superview?.addSubview(btnClearInspection)
        
        let btnNeedsReinspection = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        btnNeedsReinspection.frame = CGRectMake(itemHolder.superview!.frame.width - CGFloat(170), itemHolder.superview!.frame.height - 80, 150, 40)
        btnNeedsReinspection.setTitle("Needs Re-inspection", forState: .Normal)
        btnNeedsReinspection.layer.cornerRadius = 5.0
        btnNeedsReinspection.layer.borderColor = UIColor.blackColor().CGColor
        btnNeedsReinspection.layer.backgroundColor = UIColor.whiteColor().CGColor
        btnNeedsReinspection.layer.borderWidth = 1
        btnNeedsReinspection.addTarget(self, action: "finishNeedReinspection:", forControlEvents: UIControlEvents.TouchUpInside)
        btnNeedsReinspection.tintColor = UIColor.blackColor()
        itemHolder.superview?.addSubview(btnNeedsReinspection)
        
        //change items into a sorted array
       let itemInspectionArraySorted = inspectionTypeItems.sorted {$0.getOrderAsInt() < $1.getOrderAsInt()}
        

        
        //add dynamic items
        
        var leftSide = Bool(true)
        let fontsize = CGFloat(15)
        var currentX = 0
        var currentY = -63 // offset for uiscrollview
        let height = 200
        let width = Int(itemHolder.frame.width / 2 )
        
        //loop though items and create containers
        for item in itemInspectionArraySorted
        {
            let itemName = item.itemName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if itemName == "Inspection Officer"
            {
                let settings = AppSettings()
                
                let itemResults = consentInspection.inspectionItem.allObjects as! [ConsentInspectionItem]
                for itemResult in itemResults
                {
                    if itemResult.itemName == itemName
                    {
                        itemResult.itemResult = settings.getUser()
                        managedContext.save(nil)
                    }
                }
                
            }

            
            if itemName != "Complete" && itemName != "Inspection Officer"
            {
            let containerRect: CGRect = CGRect(x: currentX,y: currentY,width: width,height: height)
            let container: UIView = UIView(frame: containerRect)
            container.layer.borderColor = UIColor .blackColor().CGColor
            container.layer.borderWidth = 1.0
            container.backgroundColor = UIColor.whiteColor()
            container.tintColor = UIColor.blackColor()
            
            
            // add label to item
            let itemName = UILabel(frame: CGRect(x: 5, y: 5, width: container.frame.width, height: 30))
            itemName.text = item.itemName
            let font = UIFont(name: itemName.font.fontName, size: CGFloat(20))
            itemName.font = font
            container.addSubview(itemName)
            itemHolder.addSubview(container)
            
            //check item type and add selector
            if item.itemType.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "F" //Flag type = bool
            {
                let selectorItems = ["Passed","Failed"]
                let selector = UISegmentedControl(items: selectorItems)
                selector.selectedSegmentIndex = -1
                selector.tintColor = UIColor.darkGrayColor()
                selector.addTarget(self, action: "saveItem:",forControlEvents: .ValueChanged)
                
                var attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Bold", size: 16.0)!, forKey: NSFontAttributeName)
                selector.setTitleTextAttributes(attr as [NSObject : AnyObject], forState: .Normal)
                
                selector.frame = CGRect(x: 10, y: 50, width: container.frame.width - 20, height: 80)
                
                //search for exsiting result for inspections
                
                let itemResults = consentInspection.inspectionItem.allObjects as! [ConsentInspectionItem]
                for itemResult in itemResults
                {
                    if item.itemId == itemResult.itemId
                    {
                        if let result = itemResult.itemResult?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                        {
                        if result == "Y"
                        {
                            selector.selectedSegmentIndex = 0
                        }
                        else if result == "N"
                        {
                            selector.selectedSegmentIndex = 1
                        }
                        }
                    }
                }
                
                //disable if locked
                if consentInspection.locked == NSNumber(bool: true)
                {
                    selector.enabled = false
                }
                
                //results populated
                
                
                container.addSubview(selector)
                
                let btnCamera = UIButton(frame: CGRect(x: container.frame.width / 2 - 20 , y: 142, width: 40, height: 40))
                let image = UIImage(named: "Camera-50.png")
                btnCamera.setImage(image, forState: .Normal)
                container.addSubview(btnCamera)
                
            }
            else if item.itemType.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "D"
            {
                let datePicker = UIDatePicker(frame: CGRect(x: 10, y: 50, width: container.frame.width - 20, height: 80))
                datePicker.datePickerMode = UIDatePickerMode.Date
                datePicker.addTarget(self, action: "saveDate:", forControlEvents: .ValueChanged)
                
                //populate results
                let itemResults = consentInspection.inspectionItem.allObjects as! [ConsentInspectionItem]
                for itemResult in itemResults
                {
                    if item.itemId == itemResult.itemId
                    {
                        if let result = itemResult.itemResult?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                        {
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateFormat = "dd-MM-yyyy"
                            datePicker.setDate(dateFormatter.dateFromString(result)!, animated: true)
                        }
                    }
                }
                
                //save date back to consent 
                for item in itemInspectionArraySorted
                {
                    let itemName = item.itemName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    if itemName == "Date"
                    {
                        let settings = AppSettings()
                        
                        let itemResults = consentInspection.inspectionItem.allObjects as! [ConsentInspectionItem]
                        for itemResult in itemResults
                        {
                            if itemResult.itemName == itemName
                            {
                                let dateFormatter = NSDateFormatter()
                                dateFormatter.dateFormat = "dd-MM-yyyy"
                                itemResult.itemResult = dateFormatter.stringFromDate(datePicker.date)
                                managedContext.save(nil)
                            }
                        }
                        
                    }
                }
                
                //disable if locked
                if consentInspection.locked == NSNumber(bool: true)
                {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    let textDate = UITextField(frame: CGRect(x: 10, y: 50, width: container.frame.width - 20, height: 80))
                    textDate.text = dateFormatter.stringFromDate(datePicker.date)
                    textDate.enabled = false
                    container.addSubview(textDate)
                }
                else
                {
                container.addSubview(datePicker)
                }
                
            }
            else
            {
                
                let textInput = UITextView(frame: CGRect(x: 10, y: 50, width: container.frame.width - 20, height: 80))
                textInput.font = UIFont(name: "HelveticaNeue", size: CGFloat(16))
                textInput.delegate = self
                //populate results
                let itemResults = consentInspection.inspectionItem.allObjects as! [ConsentInspectionItem]
                for itemResult in itemResults
                {
                    if item.itemId == itemResult.itemId
                    {
                        if let result = itemResult.itemResult?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                        {
                            textInput.text = result
                        }
                    }
                }
                
                //disable if locked
                if consentInspection.locked == NSNumber(bool: true)
                {
                    textInput.editable = false
                }
               
                container.addSubview(textInput)
                }
            
            //move to next space
            if leftSide == true
            {
                leftSide = false
                currentX = width + currentX
            }
            else
            {
                currentX = width - currentX
                currentY = height + currentY
                leftSide = true
            }
            }
        }
        
        //update content size of scrollview to match
        let contentSize = CGSize(width: itemHolder.frame.width, height: CGFloat(currentY) + CGFloat(height) + 200)
        itemHolder.contentSize = contentSize
    }
    
    
    func saveItem(sender: UISegmentedControl)
    {
        if(sender.selectedSegmentIndex == 0)
        {
            println("pass")
            for view in sender.superview!.subviews
            {
                if view.isKindOfClass(UILabel)
                {
                    saveData((view as! UILabel).text!, value: "Y")
                }
            }
        }
        else if(sender.selectedSegmentIndex == 1)
        {
            println("fail")
            for view in sender.superview!.subviews
            {
                if view.isKindOfClass(UILabel)
                {
                    saveData((view as! UILabel).text!, value: "N")
                }
            }
        }
    }
    
    func saveDate(sender: UIDatePicker)
    {
        for view in sender.superview!.subviews
        {
            if view.isKindOfClass(UILabel)
            {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let stringDate = dateFormatter.stringFromDate(sender.date)
        saveData((view as! UILabel).text!, value: stringDate)
            }
        }

    }
    

        func textViewDidChange(textView: UITextView) {
        for view in textView.superview!.subviews
        {
            if view.isKindOfClass(UILabel)
            {
                saveData((view as! UILabel).text!, value: textView.text)
            }
        }
        
    }
    
    
    private func saveData(itemName: String, value: String) {
        if consentInspection.locked != NSNumber(bool: true)
        {
            var fetchRequest = NSFetchRequest(entityName: "ConsentInspectionItem")
        
            let resultPredicate1 = NSPredicate(format: "inspectionName = %@", self.title!)
            let resultPredicate2 = NSPredicate(format: "itemName = %@", itemName)
            let resultPredicate3 = NSPredicate(format: "consentId = %@", consentInspection.consentId)
            var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1,resultPredicate2,resultPredicate3])
            fetchRequest.predicate = compound
        
            if let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: nil) as? [ConsentInspectionItem] {
                if fetchResults.count != 0
                {
                    var managedObject = fetchResults[0]
                    managedObject.itemResult = value
                
                    managedObject.consentInspection.needSynced = NSNumber(bool: true) //add to need synced

                    managedContext.save(nil)
                }
            }
        }
    }
    
    func loadCommentsView(sender: UIButton)
    {
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        var commentsViewController: InspectionCommentsViewController = storyboard.instantiateViewControllerWithIdentifier("InspectionComments") as! InspectionCommentsViewController
        
        commentsViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        commentsViewController.preferredContentSize = CGSizeMake(400, 300)
        
        let popoverMenuViewController = commentsViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = sender
        popoverMenuViewController?.sourceRect = CGRectMake(60,40,0,0)
        presentViewController(
            commentsViewController,
            animated: true,
            completion: nil)
    }
    
    func generateNewInspection()
    {
        var existingRequest = NSFetchRequest(entityName: "ConsentInspection")
        let resultPredicate1 = NSPredicate(format: "inspectionId = %@", consentInspection.inspectionId)
        let resultPredicate2 = NSPredicate(format: "consentId = %@", consentInspection.consentId)
        var compound1 = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1,resultPredicate2])
        existingRequest.predicate = compound1

        let inspectionItemsArray = managedContext.executeFetchRequest(existingRequest, error: nil) as? [ConsentInspection]
        
        var fetchRequest = NSFetchRequest(entityName: "InspectionType")
        let resultPredicate = NSPredicate(format: "inspectionId = %@", consentInspection.inspectionId)
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate])
        fetchRequest.predicate = compound
        
        if let fetchResult = managedContext.executeFetchRequest(fetchRequest, error: nil)?.first as? InspectionType
        {
            let inspection = NSEntityDescription.insertNewObjectForEntityForName("ConsentInspection", inManagedObjectContext: managedContext) as! ConsentInspection
            inspection.inspectionId = fetchResult.inspectionId
            let inspectionName = fetchResult.inspectionName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())  + " " + String(inspectionItemsArray!.count + 1)
            inspection.inspectionName = inspectionName
            
            inspection.consent = consentInspection.consent
            inspection.consentId = consentInspection.consentId
            inspection.locked = false
            inspection.userCreated = NSNumber(bool: true)
            inspection.status = ""
            
            for item in fetchResult.inspectionTypeItems.allObjects as! [InspectionTypeItems]
            {
                let inspectionItem = NSEntityDescription.insertNewObjectForEntityForName("ConsentInspectionItem", inManagedObjectContext: managedContext) as! ConsentInspectionItem
                inspectionItem.inspectionId = fetchResult.inspectionId
                inspectionItem.inspectionName = inspectionName
                inspectionItem.consentId = consentInspection.consentId
                inspectionItem.itemId = item.itemId
                inspectionItem.itemName = item.itemName
                inspectionItem.consentInspection = inspection
            }
            managedContext.save(nil)
            
            println(inspection)
        }
    }
    
    func checkRequiredDone() -> Bool
    {
        var requiredDone = false
        
        //get items with results
        var resultRequest = NSFetchRequest(entityName: "ConsentInspectionItem")
        let itemPredicate1 = NSPredicate(format: "inspectionName = %@", consentInspection.inspectionName)
        let itemPredicate2 = NSPredicate(format: "consentId = %@", consentInspection.consentId)
        
        var compound1 = NSCompoundPredicate.andPredicateWithSubpredicates([itemPredicate1, itemPredicate2])
        resultRequest.predicate = compound1
        
        let inspectionItems = managedContext.executeFetchRequest(resultRequest, error: nil) as? [ConsentInspectionItem]
        
        //get required items
        var requiredRequest = NSFetchRequest(entityName: "InspectionTypeItems")
        let resultPredicate1 = NSPredicate(format: "inspectionId = %@", consentInspection.inspectionId)
        let resultPredicate2 = NSPredicate(format: "required = %@", NSNumber(bool: true))
        var compound2 = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1, resultPredicate2])
        requiredRequest.predicate = compound2
        
        if let requiredItems = managedContext.executeFetchRequest(requiredRequest, error: nil) as? [InspectionTypeItems]
        {
            for item in requiredItems
            {
                for resultItem in inspectionItems!
                {
                    let resultName = resultItem.itemName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    let itemName = item.itemName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                    if  resultName == itemName
                    {
                        if let result = resultItem.itemResult
                        {
                            requiredDone = true
                        }
                        else
                        {
                            return false
                        }
                    }
                }
            }
        }
        return requiredDone
    }
    
    func deleteThisInspection(sender: UIButton)
    {
        if consentInspection.userCreated == NSNumber(bool: true)
        {
            let popup = UIAlertController(title: "This will delete this inspection",
                message: "Pressing OK will permanently delete this inspection",
                preferredStyle: .Alert)
            
            popup.addAction(UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default,
                handler: self.deleteIns))
            
            popup.addAction(UIAlertAction(title: "Cancel",
                style: UIAlertActionStyle.Cancel,
                handler: nil))
            
            self.presentViewController(popup, animated: true, completion: nil)
        }
    }
    
    func finishNeedReinspection(sender: UIButton)
    {
        if checkRequiredDone() == true
        {
        let popup = UIAlertController(title: "Finishing will lock this inspection",
            message: "Make sure all items are correct. A new inspection will be generated to complete",
            preferredStyle: .Alert)
        
        popup.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: self.finishAddNew))
        
        popup.addAction(UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler: nil))
        
        self.presentViewController(popup, animated: true, completion: nil)
        }
        else
        {
            let popup = UIAlertController(title: "Inspection not complete",
                message: "Make sure all items are completed before finishing",
                preferredStyle: .Alert)
            
            popup.addAction(UIAlertAction(title: "Ok",
                style: UIAlertActionStyle.Cancel,
                handler: nil))
            self.presentViewController(popup, animated: true, completion: nil)
        }
    }


    func finishInspection(sender: UIButton)
    {
        if checkRequiredDone() == true
        {
        let popup = UIAlertController(title: "Finishing will lock this inspection",
            message: "Make sure all items are correct",
            preferredStyle: .Alert)
        
        popup.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: self.finish))
        
        popup.addAction(UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler: nil))
        
        self.presentViewController(popup, animated: true, completion: nil)
        }
        else
        {
            let popup = UIAlertController(title: "Inspection not complete",
                message: "Make sure all items are completed before finishing",
                preferredStyle: .Alert)
            
            popup.addAction(UIAlertAction(title: "Ok",
                style: UIAlertActionStyle.Cancel,
                handler: nil))
            self.presentViewController(popup, animated: true, completion: nil)
        }

        
        
    }
    
    func deleteIns(alert: UIAlertAction!)
    {
        var resultRequest = NSFetchRequest(entityName: "ConsentInspectionItem")
        let itemPredicate1 = NSPredicate(format: "inspectionName = %@", consentInspection.inspectionName)
        let itemPredicate2 = NSPredicate(format: "consentId = %@", consentInspection.consentId)
        
        var compound1 = NSCompoundPredicate.andPredicateWithSubpredicates([itemPredicate1, itemPredicate2])
        resultRequest.predicate = compound1
        
        let inspectionItems = managedContext.executeFetchRequest(resultRequest, error: nil) as? [ConsentInspectionItem]
        
        for item in inspectionItems!
        {
            managedContext.deleteObject(item as NSManagedObject)
        }
        
        var resultRequest2 = NSFetchRequest(entityName: "ConsentInspection")
        
        var compound2 = NSCompoundPredicate.andPredicateWithSubpredicates([itemPredicate1, itemPredicate2])
        resultRequest.predicate = compound2
        
        if let inspection = managedContext.executeFetchRequest(resultRequest, error: nil)?.first as? ConsentInspection
        {
            managedContext.deleteObject(inspection as NSManagedObject)
            managedContext.save(nil)
        }
        else
        {
            println("Conflicting inspections found: " + consentInspection.consentId)
        }
        navigationController!.popViewControllerAnimated(true)

        
        
    }

    func finish(alert: UIAlertAction!)
    {
       
        consentInspection.locked = NSNumber(bool: true)
        consentInspection.needSynced = true
        navigationController?.popViewControllerAnimated(true)
    }
    
    func finishAddNew(alert:UIAlertAction!)
    {
         generateNewInspection()
        consentInspection.locked = NSNumber(bool: true)
        consentInspection.needSynced = true
        navigationController?.popViewControllerAnimated(true)
    }

}
