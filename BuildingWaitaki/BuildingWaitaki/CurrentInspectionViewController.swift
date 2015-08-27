//
//  CurrentInspectionViewController.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 15/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import UIKit
import CoreData

class CurrentInspectionViewController: UIViewController, UITextViewDelegate, UIPopoverPresentationControllerDelegate, UIPopoverControllerDelegate {
    var consentInspection : ConsentInspection!
    var inspectionTypeItems : [InspectionTypeItems]!
    var managedContext: NSManagedObjectContext!
    var supervisor: UITextField?
    var supervisorControl : UITextView?
    
    @IBOutlet weak var itemHolder: UIScrollView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = AppSettings().getViewBackground()
        
        for scrollview in self.view.subviews
        {
            if scrollview.isKindOfClass(UIScrollView)
            {
                (scrollview as! UIScrollView).backgroundColor = UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.4)
                (scrollview as! UIScrollView).tintColor = AppSettings().getTintColour()
            }
        }
        
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
        let btnComments = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        btnComments.frame = CGRectMake(20, 85, 150, 40)
        btnComments.setTitle("Comments", forState: .Normal)
        btnComments.layer.borderColor = UIColor.blackColor().CGColor
        btnComments.addTarget(self, action: "loadCommentsView:", forControlEvents: UIControlEvents.TouchUpInside)
        btnComments.layer.borderWidth = 1
        btnComments.titleLabel!.font = AppSettings().getTextFont()
        btnComments.tintColor = AppSettings().getTintColour()
        btnComments.layer.backgroundColor = AppSettings().getBackgroundColour().CGColor
        itemHolder.superview?.addSubview(btnComments)
        
        let btnDeleteInspection = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        btnDeleteInspection.frame = CGRectMake(itemHolder.frame.width / 2 - 75, 85, 150, 40)
        btnDeleteInspection.setTitle("Delete Inspection", forState: .Normal)
        btnDeleteInspection.layer.borderColor = UIColor.blackColor().CGColor
        btnDeleteInspection.addTarget(self, action: "deleteThisInspection:", forControlEvents: UIControlEvents.TouchUpInside)
        btnDeleteInspection.layer.borderWidth = 1
        btnDeleteInspection.titleLabel!.font = AppSettings().getTextFont()
        btnDeleteInspection.tintColor = AppSettings().getTintColour()
        btnDeleteInspection.layer.backgroundColor = AppSettings().getBackgroundColour().CGColor
        println(consentInspection.userCreated)
        if (consentInspection.userCreated != NSNumber(bool: true)) || (consentInspection.locked == true)
        {
            btnDeleteInspection.enabled = false
        }
        itemHolder.superview!.addSubview(btnDeleteInspection)
        
        let btnEmail = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        btnEmail.frame = CGRectMake(itemHolder.superview!.frame.width - CGFloat(140), 85, 120, 40)
        btnEmail.setTitle("Email Report", forState: .Normal)
        btnEmail.addTarget(self, action: "emailReport:", forControlEvents: UIControlEvents.TouchUpInside)
        btnEmail.layer.borderColor = UIColor.blackColor().CGColor
        btnEmail.layer.borderWidth = 1
        btnEmail.titleLabel!.font = AppSettings().getTextFont()
        btnEmail.layer.backgroundColor = AppSettings().getBackgroundColour().CGColor
        btnEmail.tintColor = AppSettings().getTintColour()
        itemHolder.superview?.addSubview(btnEmail)
        
        //ADD BOTTOM BAR ICONS
        let btnFinished = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        btnFinished.frame = CGRectMake(20, itemHolder.superview!.frame.height - 70, 150, 40)
        btnFinished.setTitle("Finished", forState: .Normal)
        btnFinished.addTarget(self, action: "finishInspection:", forControlEvents: UIControlEvents.TouchUpInside)
        btnFinished.layer.borderColor = UIColor.blackColor().CGColor
        btnFinished.layer.borderWidth = 1
        btnFinished.titleLabel!.font = AppSettings().getTextFont()
        btnFinished.tintColor = AppSettings().getTintColour()
        btnFinished.layer.backgroundColor = AppSettings().getBackgroundColour().CGColor
        if consentInspection.locked == true
        {
            btnFinished.enabled = false
        }
        itemHolder.superview?.addSubview(btnFinished)
        
        let btnClearInspection = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        btnClearInspection.frame = CGRectMake(itemHolder.superview!.frame.width / 2 - 75, itemHolder.superview!.frame.height - 70, 150, 40)
        btnClearInspection.setTitle("Clear inspection", forState: .Normal)
        btnClearInspection.layer.borderColor = UIColor.blackColor().CGColor
        btnClearInspection.layer.backgroundColor = AppSettings().getBackgroundColour().CGColor
        btnClearInspection.layer.borderWidth = 1
        btnClearInspection.titleLabel!.font = AppSettings().getTextFont()
        btnClearInspection.addTarget(self, action: "clearInspectionResults:", forControlEvents: UIControlEvents.TouchUpInside)
        btnClearInspection.tintColor = AppSettings().getTintColour()
        if consentInspection.locked == true
        {
            btnClearInspection.enabled = false
        }
        itemHolder.superview?.addSubview(btnClearInspection)
        
        let btnNeedsReinspection = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        btnNeedsReinspection.frame = CGRectMake(itemHolder.superview!.frame.width - CGFloat(170), itemHolder.superview!.frame.height - 70, 150, 40)
        btnNeedsReinspection.setTitle("Reinspect", forState: .Normal)
        btnNeedsReinspection.layer.borderColor = UIColor.blackColor().CGColor
        btnNeedsReinspection.layer.backgroundColor = AppSettings().getBackgroundColour().CGColor
        btnNeedsReinspection.layer.borderWidth = 1
        btnNeedsReinspection.titleLabel!.font = AppSettings().getTextFont()
        btnNeedsReinspection.addTarget(self, action: "finishNeedReinspection:", forControlEvents: UIControlEvents.TouchUpInside)
        btnNeedsReinspection.tintColor = AppSettings().getTintColour()
      //  if consentInspection.locked == true
      //  {
        //    btnNeedsReinspection.enabled = false
      //  }
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
        let background = UIColor.clearColor()
        
        //loop though items and create containers

        for item in itemInspectionArraySorted
        {
            let itemName = item.itemName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
            if itemName != "Comments" && itemName != "Inspection Officer"
            {
            let containerRect: CGRect = CGRect(x: currentX,y: currentY,width: width,height: height)
            let container: UIView = UIView(frame: containerRect)
            container.layer.borderColor = UIColor .grayColor().CGColor
            container.layer.borderWidth = 1.0
            container.backgroundColor = background
            container.tintColor = AppSettings().getTintColour()
            
            // add label to item
            let itemName = UILabel(frame: CGRect(x: 5, y: 5, width: container.frame.width, height: 30))
            itemName.text = item.itemName
            itemName.font = AppSettings().getTitleFont()
            itemName.textColor = AppSettings().getTintColour()
            container.addSubview(itemName)
            itemHolder.addSubview(container)
            
            //check item type and add selector
            if item.itemType.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "L" //Lookup type = bool
            {
                let selectorItems = ["Passed","N/A","Failed"]
                let selector = UISegmentedControl(items: selectorItems)
                selector.selectedSegmentIndex = -1
                selector.tintColor = AppSettings().getTintColour()
                selector.addTarget(self, action: "saveItem:",forControlEvents: .ValueChanged)
                
                
                
                var attr = NSDictionary(object: AppSettings().getTextFont(), forKey: NSFontAttributeName)
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
                        if result == "PASS"
                        {
                            selector.selectedSegmentIndex = 0
                        }
                        else if result == "N/A"
                        {
                            selector.selectedSegmentIndex = 1
                        }
                        else if result == "FAIL"
                        {
                            selector.selectedSegmentIndex = 2
                        }
                        }
                        else if let comment = itemResult.itemComment
                        {
                            if comment != ""
                            {
                                //container.backgroundColor = UIColor.redColor()
                                itemName.textColor = UIColor(red: 235/255.0, green: 5/255.0, blue: 5/255.0, alpha: 1.0)
                                selector.tintColor = UIColor(red: 235/255.0, green: 5/255.0, blue: 5/255.0, alpha: 1.0)
                                
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
                
                let btnCamera = UIButton.buttonWithType(UIButtonType.System) as! UIButton
                btnCamera.frame = CGRect(x: 20 , y: 142, width: 40, height: 40)
                let image = UIImage(named: "Camera-50.png")
                btnCamera.setImage(image, forState: .Normal)
                btnCamera.imageView!.image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                btnCamera.addTarget(self, action: "openCamera:", forControlEvents: UIControlEvents.TouchUpInside)
                btnCamera.imageView?.tintColor = AppSettings().getTintColour()
                container.addSubview(btnCamera)
                
                let btnNotes = UIButton.buttonWithType(UIButtonType.System) as! UIButton
                btnNotes.frame = CGRect(x: container.frame.width - 60 , y: 142, width: 40, height: 40)
                let commentimage = UIImage(named: "Speech Bubble-50.png")
                btnNotes.addTarget(self, action: "loadNotesBtn:", forControlEvents: UIControlEvents.TouchUpInside)
                btnNotes.setImage(commentimage, forState: .Normal)
                btnNotes.imageView!.image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
                btnNotes.imageView!.tintColor = AppSettings().getTintColour()
                container.addSubview(btnNotes)
                
            }
            else if item.itemType.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "D"
            {
                let datePicker = UIDatePicker(frame: CGRect(x: 10, y: 50, width: container.frame.width - 20, height: 80))
                datePicker.setValue(AppSettings().getTintColour(), forKey: "textColor")
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
                            datePicker.tintColor = UIColor.whiteColor()
                        }
                    }
                }
                
                
                //disable if locked
                if consentInspection.locked == NSNumber(bool: true)
                {
                    let dateFormatter = NSDateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    let textDate = UITextField(frame: CGRect(x: 120, y: 50, width: container.frame.width - 50, height: 80))
                    textDate.text = dateFormatter.stringFromDate(datePicker.date)
                    textDate.font = AppSettings().getTextFont()
                    textDate.textColor = UIColor.whiteColor()
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
                if (item.itemName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())) == "Supervisor"
                {
                    let selectorItems = ["Supervised","Unsupervised"]
                    let selector = UISegmentedControl(items: selectorItems)
                    selector.selectedSegmentIndex = -1
                    selector.tintColor = AppSettings().getTintColour()
                    var attr = NSDictionary(object: AppSettings().getTextFont(), forKey: NSFontAttributeName)
                    selector.setTitleTextAttributes(attr as [NSObject : AnyObject], forState: .Normal)
                    selector.addTarget(self, action: "addSupervisor:",forControlEvents: .ValueChanged)
                    selector.frame = CGRect(x: 10, y: 50, width: container.frame.width - 20, height: 80)
                    
                    
                    supervisorControl = UITextView(frame: CGRect(x: 10, y: container.frame.height - 44, width: container.frame.width - 20, height: 34))
                    supervisorControl!.font = AppSettings().getTextFont()
                    supervisorControl!.textAlignment = .Center
                    supervisorControl!.editable = false
                    supervisorControl!.backgroundColor = AppSettings().getBackgroundColour()
                    supervisorControl!.textColor = AppSettings().getTintColour()
                    supervisorControl!.keyboardAppearance = UIKeyboardAppearance.Dark
                    supervisorControl!.delegate = self
                    
                    
                    //populate results
                    let itemResults = consentInspection.inspectionItem.allObjects as! [ConsentInspectionItem]
                    for itemResult in itemResults
                    {
                        if item.itemId == itemResult.itemId
                        {
                            println(itemResult.itemResult)
                            if let result = itemResult.itemResult?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
                            {
                                if result == "N/A"
                                {
                                    selector.selectedSegmentIndex = 1
                                }
                                else if result == ""
                                {
                                    selector.selectedSegmentIndex = -1
                                    supervisorControl!.text = ""
                                }
                                else
                                {
                                    supervisorControl!.text = result
                                    selector.selectedSegmentIndex = 0

                                }
                            }
                        }
                    }
                    
                    
                    //disable if locked
                    if consentInspection.locked == NSNumber(bool: true)
                    {
                        selector.enabled = false
                    }
                    container.addSubview(supervisorControl!)
                    container.addSubview(selector)
                }
                else
                {
                let textInput = UITextView(frame: CGRect(x: 10, y: 50, width: container.frame.width - 20, height: 80))
                textInput.font = AppSettings().getTextFont()
                textInput.backgroundColor = AppSettings().getBackgroundColour()
                textInput.textColor = AppSettings().getTextColour()
                textInput.keyboardAppearance = UIKeyboardAppearance.Dark
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
    
    func addSupervisor(sender: UISegmentedControl?)
    {
        if sender?.selectedSegmentIndex == 0 || sender == nil
        {
        var popup = UIAlertController(title: "Supervisor",
            message: "Please enter your supervisor",
            preferredStyle: .Alert)
        
        popup.addAction(UIAlertAction(title: "Save",
            style: .Default,
            handler: SaveSupervisor))
        
        popup.addTextFieldWithConfigurationHandler(SaveText)
        popup = AppSettings().getPopupStyle(popup)
        
            self.presentViewController(popup, animated: true, completion: nil)
            
            
        }
        else
        {
            
            self.supervisorControl!.text = ""
            var fetchRequest = NSFetchRequest(entityName: "ConsentInspectionItem")
            
            let resultPredicate1 = NSPredicate(format: "inspectionName = %@", self.title!)
            let resultPredicate2 = NSPredicate(format: "itemName = %@", "Supervisor")
            let resultPredicate3 = NSPredicate(format: "consentId = %@", consentInspection.consentId)
            var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1,resultPredicate2,resultPredicate3])
            fetchRequest.predicate = compound
            
            if let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: nil) as? [ConsentInspectionItem]
            {
                if fetchResults.count != 0
                {
                    var managedObject = fetchResults[0]
                    managedObject.itemResult = "N/A"
                    managedObject.consentInspection.needSynced = NSNumber(bool: true) //add to need synced
                    
                    managedContext.save(nil)
                }
            }

        }
        
  

    }
    
    func SaveSupervisor(alert: UIAlertAction!)
    {
        self.supervisorControl!.text = self.supervisor!.text
        //code to save to core data
        
        
        var fetchRequest = NSFetchRequest(entityName: "ConsentInspectionItem")
        
        let resultPredicate1 = NSPredicate(format: "inspectionName = %@", self.title!)
        let resultPredicate2 = NSPredicate(format: "itemName = %@", "Supervisor")
        let resultPredicate3 = NSPredicate(format: "consentId = %@", consentInspection.consentId)
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1,resultPredicate2,resultPredicate3])
        fetchRequest.predicate = compound
        
        if let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: nil) as? [ConsentInspectionItem]
        {
            println(fetchResults.count)
            if fetchResults.count != 0
            {
                var managedObject = fetchResults[0]
                managedObject.itemResult = (self.supervisor!.text)
                
                managedObject.consentInspection.needSynced = NSNumber(bool: true) //add to need synced
                
                managedContext.save(nil)
            }
        }
        
        if supervisor?.text == ""
        {
            addSupervisor(nil)
        }

        
        
    }
    
        //used to save from the alert box
    func SaveText(textfield: UITextField!)
        {
            textfield.placeholder = "Supervisors name"
            textfield.keyboardAppearance = .Dark
            self.supervisor = textfield
            
        }

    func saveItem(sender: UISegmentedControl)
    {
        //bool to hold if n/a selected 
        var NASelected = NSNumber(bool: false)
        var failSelected = NSNumber(bool: false)
        if(sender.selectedSegmentIndex == 0)
        {
          //  println("pass")
            for view in sender.superview!.subviews
            {
                if view.isKindOfClass(UILabel)
                {
                    saveData((view as! UILabel).text!, value: "PASS")
                }
            }
        }
        else if(sender.selectedSegmentIndex == 1)
        {
           // println("N/A")
            for view in sender.superview!.subviews
            {
                if view.isKindOfClass(UILabel)
                {
                    NASelected = NSNumber(bool: true)
                    saveData((view as! UILabel).text!, value: "N/A")
                }
            }
        }

        else if(sender.selectedSegmentIndex == 2)
        {
       //     println("fail")
            for view in sender.superview!.subviews
            {
                if view.isKindOfClass(UILabel)
                {
                    saveData((view as! UILabel).text!, value: "FAIL")
                    failSelected = NSNumber(bool: true)
                }
            }
        }
        
        if NASelected == NSNumber(bool: false)
        {
            var button = UIButton()
            for view in sender.superview!.subviews
            {
                if view.isKindOfClass(UIButton)
                {
                    button = view as! UIButton
                }
            }
            if failSelected == NSNumber(bool:true)
            {
                loadNotes(button,needsInfo: NSNumber(bool: true))
            }
            else
            {
                loadNotes(button,needsInfo: NSNumber(bool: false))
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
        //on saving an item update officer and date
         let itemInspectionArraySorted = inspectionTypeItems.sorted {$0.getOrderAsInt() < $1.getOrderAsInt()}
        for item in itemInspectionArraySorted
        {
            let itemName = item.itemName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            if consentInspection.locked != NSNumber(bool: true)
            {
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
            
                else if itemName == "Date"
                {
                    let settings = AppSettings()
                    
                    let itemResults = consentInspection.inspectionItem.allObjects as! [ConsentInspectionItem]
                    for itemResult in itemResults
                    {
                        if itemResult.itemName == itemName
                        {
                            for view in itemHolder.subviews
                            {
                            if view.isKindOfClass(UIView)
                            {
                                for subview1 in view.subviews
                                {
                                    if subview1.isKindOfClass(UILabel)
                                    {
                                        let label = subview1 as! UILabel
                                        if label.text == "Date"
                                        {
                                            for datePickerview in view.subviews
                                            {
                                                if datePickerview.isKindOfClass(UIDatePicker)
                                                {
                                                    let datePicker = datePickerview as! UIDatePicker
                                                    let dateFormatter = NSDateFormatter()
                                                    dateFormatter.dateFormat = "dd-MM-yyyy"
                                                    itemResult.itemResult = dateFormatter.stringFromDate(datePicker.date)
                                                    managedContext.save(nil)

                                                }
                                            }
                                            
                                                                                   }
                                    }
                                }
                            }
                            }
                            
      
                            }
                        }
                    }
                    
            }
        }

        
        
        
        if consentInspection.locked != NSNumber(bool: true)
        {
            var fetchRequest = NSFetchRequest(entityName: "ConsentInspectionItem")
        
            let resultPredicate1 = NSPredicate(format: "inspectionName = %@", self.title!)
            let resultPredicate2 = NSPredicate(format: "itemName = %@", itemName)
            let resultPredicate3 = NSPredicate(format: "consentId = %@", consentInspection.consentId)
            var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1,resultPredicate2,resultPredicate3])
            fetchRequest.predicate = compound
        
            if let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: nil) as? [ConsentInspectionItem]
            {
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
    
    func loadNotesBtn(sender: UIButton)
    {
        loadNotes(sender, needsInfo: NSNumber(bool: false))
    }
    
    func loadNotes(sender: UIButton,needsInfo: NSNumber?)
    {
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        var commentsViewController: InspectionCommentsViewController = storyboard.instantiateViewControllerWithIdentifier("InspectionComments") as! InspectionCommentsViewController
        
        commentsViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        commentsViewController.preferredContentSize = CGSizeMake(500, 450)
    
        
        commentsViewController.consentInspection = consentInspection
        commentsViewController.managedContext = managedContext
        var itemName = ""
        for view in sender.superview!.subviews
        {
            if view.isKindOfClass(UILabel)
            {
                itemName = (view as! UILabel).text!
            }
        }
        commentsViewController.itemName = itemName
        
        let popoverMenuViewController = commentsViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = view
        popoverMenuViewController?.sourceRect = CGRectMake(view.frame.width / 2, view.frame.height / 2, 0,0)
        popoverMenuViewController?.permittedArrowDirections = UIPopoverArrowDirection.allZeros
        
        
        commentsViewController.needsInfo = needsInfo
        commentsViewController.modalInPopover = true
        commentsViewController.modalPresentationStyle = UIModalPresentationStyle.FullScreen
                
        presentViewController(
            commentsViewController,
            animated: true,
            completion: nil)
    }
    
    
    
    func loadCommentsView(sender: UIButton)
    {
        let storyboard : UIStoryboard = UIStoryboard(
            name: "Main",
            bundle: nil)
        var commentsViewController: InspectionCommentsViewController = storyboard.instantiateViewControllerWithIdentifier("InspectionComments") as! InspectionCommentsViewController
        
        commentsViewController.modalPresentationStyle = UIModalPresentationStyle.Popover
        commentsViewController.preferredContentSize = CGSizeMake(500, 450)
        
        commentsViewController.consentInspection = consentInspection
        commentsViewController.managedContext = managedContext
        commentsViewController.itemName = "Comments"
        
        let popoverMenuViewController = commentsViewController.popoverPresentationController
        popoverMenuViewController?.permittedArrowDirections = .Any
        popoverMenuViewController?.delegate = self
        popoverMenuViewController?.sourceView = sender
    //    popoverMenuViewController?.sourceRect = CGRectMake(80,40,0,0)
        
  
        
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
            
            var inspectionName : String
            if inspectionItemsArray!.count > 0
            {
            inspectionName = fetchResult.inspectionName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())  + " " + String(inspectionItemsArray!.count + 1)
            }
            else
            {
                inspectionName = fetchResult.inspectionName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
            }
            
            inspection.inspectionName = inspectionName
            
            inspection.consent = consentInspection.consent
            inspection.consentId = consentInspection.consentId
            inspection.locked = false
            inspection.userCreated = NSNumber(bool: true)
            inspection.needSynced = NSNumber(bool: false)
            inspection.status = ""
            
            managedContext.save(nil)
            

            //populate items into coredata
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
            
            
            //populate passes and N/A's from previous inspection and fail comments
            for item:AnyObject in consentInspection.inspectionItem
            {
                let currentItem = item as! ConsentInspectionItem
                var fetchRequest = NSFetchRequest(entityName: "ConsentInspectionItem")
                
                let resultPredicate1 = NSPredicate(format: "inspectionName = %@", inspection.inspectionName)
                let resultPredicate2 = NSPredicate(format: "itemName = %@", currentItem.itemName)
                let resultPredicate3 = NSPredicate(format: "consentId = %@", inspection.consentId)
                var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1,resultPredicate2,resultPredicate3])
                fetchRequest.predicate = compound
                
                managedContext.save(nil) // see if saves
                
                if let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: nil) as? [ConsentInspectionItem]
                {
                    if fetchResults.count != 0
                    {
                        var managedObject = fetchResults[0]
                        println(currentItem.itemResult)
                        if let result = currentItem.itemResult
                        {
                            if result.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) != "FAIL"
                            {
                                managedObject.itemResult = result
                            }
                        }
                        
                        if let itemcomment = currentItem.itemComment
                        {
                            if currentItem.itemName == "Comments"
                            {
                                managedObject.itemComment = "Inspection generated from: " + consentInspection.inspectionName + ". Previous Notes: " + itemcomment
                            }
                            else
                            {
                                 managedObject.itemComment = "Notes from " + consentInspection.inspectionName + ": " + itemcomment
                            }
                        }
                        
                        managedObject.consentInspection.needSynced = NSNumber(bool: true) //add to need synced
                        
                        managedContext.save(nil)
                    }
                }
                
            }
            
            
         //   println(inspection)
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
    
    func clearInspectionResults(sender: UIButton)
    {
        consentInspection.status = ""
        consentInspection.needSynced = NSNumber(bool: false)
        var resultRequest = NSFetchRequest(entityName: "ConsentInspectionItem")
        let itemPredicate1 = NSPredicate(format: "inspectionName = %@", consentInspection.inspectionName)
        let itemPredicate2 = NSPredicate(format: "consentId = %@", consentInspection.consentId)
        
        var compound1 = NSCompoundPredicate.andPredicateWithSubpredicates([itemPredicate1, itemPredicate2])
        resultRequest.predicate = compound1
        
        let inspectionItems = managedContext.executeFetchRequest(resultRequest, error: nil) as? [ConsentInspectionItem]
        
        for item in inspectionItems!
        {
            item.itemResult = nil
        }
        managedContext.save(nil)
        
        navigationController!.popViewControllerAnimated(true)

    }
    
    func deleteThisInspection(sender: UIButton)
    {
        if consentInspection.userCreated == NSNumber(bool: true)
        {
            var popup = UIAlertController(title: "This will delete this inspection",
                message: "Pressing OK will permanently delete this inspection",
                preferredStyle: .Alert)
            
            let settings = AppSettings()
            
            
            popup.addAction(UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default,
                handler: self.deleteIns))
            
            popup.addAction(UIAlertAction(title: "Cancel",
                style: UIAlertActionStyle.Cancel,
                handler: nil))
            popup = settings.getPopupStyle(popup)
            self.presentViewController(popup, animated: true, completion: nil)
        }
    }
    
    func finishNeedReinspection(sender: UIButton)
    {
        if checkRequiredDone() == true
        {
        var popup = UIAlertController(title: "Finishing will lock this inspection",
            message: "Make sure all items are correct. A new inspection will be generated to complete",
            preferredStyle: .Alert)
            
            
        
        popup.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: self.finishAddNew))
        
        popup.addAction(UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler: nil))
        popup = AppSettings().getPopupStyle(popup)
        self.presentViewController(popup, animated: true, completion: nil)
        }
        else
        {
            var popup = UIAlertController(title: "Inspection not complete",
                message: "Make sure all items are completed before finishing",
                preferredStyle: .Alert)
            
            
            
            popup.addAction(UIAlertAction(title: "Ok",
                style: UIAlertActionStyle.Cancel,
                handler: nil))
            
            popup = AppSettings().getPopupStyle(popup)
            self.presentViewController(popup, animated: true, completion: nil)
        }
    }


    func finishInspection(sender: UIButton)
    {
        if checkRequiredDone() == true
        {
        var popup = UIAlertController(title: "Finishing will lock this inspection",
            message: "Make sure all items are correct",
            preferredStyle: .Alert)
            
            
        
        popup.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: self.finish))
        
        popup.addAction(UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler: nil))
        popup = AppSettings().getPopupStyle(popup)
        self.presentViewController(popup, animated: true, completion: nil)
        }
        else
        {
            var popup = UIAlertController(title: "Inspection not complete",
                message: "Make sure all items are completed before finishing",
                preferredStyle: .Alert)
            
           
            
            popup.addAction(UIAlertAction(title: "Ok",
                style: UIAlertActionStyle.Cancel,
                handler: nil))
            
             popup = AppSettings().getPopupStyle(popup)
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
        resultRequest2.predicate = compound2
        
        let inspection = managedContext.executeFetchRequest(resultRequest2, error: nil) as! [ConsentInspection]
        
        if inspection.count == 1
        {
            let inspectionToDelete = inspection[0]
            managedContext.deleteObject(inspectionToDelete as NSManagedObject)
            managedContext.save(nil)
        }
        else
        {
            println(inspection.count)
            println("Conflicting inspections found: " + consentInspection.consentId)
        }
        navigationController!.popViewControllerAnimated(true)

        
        
    }

    func finish(alert: UIAlertAction!)
    {
saveFinished()
        navigationController?.popViewControllerAnimated(true)
        managedContext.save(nil)
    }
    
    func finishAddNew(alert:UIAlertAction!)
    {
         generateNewInspection()
saveFinished()
        navigationController?.popViewControllerAnimated(true)
        managedContext.save(nil)
    }
    
    private func saveFinished()
    {
        var fetchRequest = NSFetchRequest(entityName: "ConsentInspection")
        
        let resultPredicate1 = NSPredicate(format: "inspectionName = %@", self.title!)
        let resultPredicate2 = NSPredicate(format: "consentId = %@", consentInspection.consentId)
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1,resultPredicate2])
        fetchRequest.predicate = compound
        
        if let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: nil)?.first as? ConsentInspection {
                var managedObject = fetchResults
                managedObject.locked = NSNumber(bool: true)
                managedObject.needSynced = true
                managedContext.save(nil)
        }

    }
    
    func openCamera(sender: UIButton)
    {
        //get current item name
        var currentItem : ConsentInspectionItem?
        var itemName = ""
        
        let superview = sender.superview!
        for view in superview.subviews
        {
            if view.isKindOfClass(UILabel)
            {
                let label = view as! UILabel
                itemName = label.text!
            }
        }
        
        
        
        //get current inspection item
        var resultRequest = NSFetchRequest(entityName: "ConsentInspection")
        let itemPredicate1 = NSPredicate(format: "inspectionName = %@", consentInspection.inspectionName)
        let itemPredicate2 = NSPredicate(format: "consentId = %@", consentInspection.consentId)
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([itemPredicate1,itemPredicate2])
        resultRequest.predicate = compound
        
        if let fetchResult = managedContext.executeFetchRequest(resultRequest, error: nil)?.first as? ConsentInspection
        {
            for item in fetchResult.inspectionItem
            {
                if let inspectionItem = item as? ConsentInspectionItem
                {
                    if inspectionItem.itemName == itemName
                    {
                        currentItem = inspectionItem
                    }
                }
            }
        }
        
        if let myItem = currentItem
        {
            //goto new controller
            let cameraController = self.storyboard!.instantiateViewControllerWithIdentifier("InspectionCameraViewController") as! InspectionCameraViewController
            cameraController.managedContext = managedContext
            cameraController.inspectionItem = myItem
            self.navigationController!.pushViewController(cameraController, animated: true)
        }
        else
        {
            //warning to show no inspection item could be found
        }
        }
    
    func emailReport(sender: UIButton)
    {
        //goto new controller
        let emailController = self.storyboard!.instantiateViewControllerWithIdentifier("EmailViewController") as! EmailViewController
        emailController.consentInspection = consentInspection
        self.navigationController!.pushViewController(emailController, animated: true)

    }
    
    func popoverControllerShouldDismissPopover(popoverController: UIPopoverController) -> Bool {
        return false
    }
    
    }