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
        
        
        //populate items with any results
        //println(consentInspection.inspectionItem)
        for item:AnyObject in consentInspection.inspectionItem
        {
           // println((item as! ConsentInspectionItem).itemId)
        }
        
        
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
        btnComments.frame = CGRectMake((itemHolder.superview!.frame.width / 2) - CGFloat(60), 85, 120, 40)
        btnComments.setTitle("Comments", forState: .Normal)
        btnComments.layer.cornerRadius = 5.0
        btnComments.layer.borderColor = UIColor.blackColor().CGColor
        btnComments.addTarget(self, action: "loadCommentsView:", forControlEvents: UIControlEvents.TouchUpInside)
        btnComments.layer.borderWidth = 1
        btnComments.tintColor = UIColor.blackColor()
        btnComments.layer.backgroundColor = UIColor.whiteColor().CGColor
        itemHolder.superview?.addSubview(btnComments)
        
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
        btnFinished.layer.cornerRadius = 5.0
        btnFinished.layer.borderColor = UIColor.blackColor().CGColor
        btnFinished.layer.borderWidth = 1
        btnFinished.tintColor = UIColor.blackColor()
        btnFinished.layer.backgroundColor = UIColor.whiteColor().CGColor
        itemHolder.superview?.addSubview(btnFinished)
        
        let btnNeedsReinspection = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        btnNeedsReinspection.frame = CGRectMake(itemHolder.superview!.frame.width - CGFloat(170), itemHolder.superview!.frame.height - 80, 150, 40)
        btnNeedsReinspection.setTitle("Needs Re-inspection", forState: .Normal)
        btnNeedsReinspection.layer.cornerRadius = 5.0
        btnNeedsReinspection.layer.borderColor = UIColor.blackColor().CGColor
        btnNeedsReinspection.layer.backgroundColor = UIColor.whiteColor().CGColor
        btnNeedsReinspection.layer.borderWidth = 1
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
                
                container.addSubview(datePicker)
                
                
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
                //managedObject.setValue(value, forKey: "itemResult")
                
                managedObject.consentInspection.needSynced = NSNumber(bool: true) //add to need synced

                managedContext.save(nil)
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


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
