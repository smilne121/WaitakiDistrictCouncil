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
    @IBOutlet weak var daynightlabel: UILabel!
    @IBOutlet weak var nightSwitch: UISwitch!
    
    var searchActive : Bool = false
    

    @IBAction func themechanged(sender: UISwitch) {
        if sender.on == true
        {
            AppSettings().setTheme("dark")
            self.viewWillAppear(true)
            self.viewDidLoad()
        }
        else
        {
            AppSettings().setTheme("light")
            self.viewWillAppear(true)
            self.viewDidLoad()
        }
        
    }
    override func viewWillAppear(animated: Bool) {
        daynightlabel.font = AppSettings().getTextFont()
        daynightlabel.textColor = AppSettings().getTextColour()
        
        if AppSettings().getTheme() == "dark"
        {
            nightSwitch.on = true
        }
        else
        {
            nightSwitch.on = false
            
        }
         nightSwitch.tintColor = AppSettings().getTintColour()
        
        let settings = AppSettings()
        
        for view in self.view.subviews
        {
            if view.isKindOfClass(UILabel)
            {
                if let label = view as? UILabel
                {
                    label.font = settings.getTitleFont()
                    label.textColor = settings.getTintColour()
                }
            }
            else if view.isKindOfClass(UIView)
            {
                for subview in view.subviews
                {
                    if subview.isKindOfClass(UIButton)
                    {
                        if let btn = subview as? UIButton
                        {
                            btn.titleLabel?.font = settings.getTextFont()
                            btn.titleLabel?.textColor = settings.getTextColour()
                        }
                        
                    }
                }
            }
        }
        
        //set image for background
        view.backgroundColor = settings.getViewBackground()
        
        //change nav bar
        let nav = self.navigationController?.navigationBar
        // 2
        nav?.translucent = true
        nav?.barTintColor = settings.getViewBackground()
        // 3
        
        
        var titleView : UIImageView
        // set the dimensions you want here
        titleView = UIImageView(frame:CGRectMake(0, 0, 30, 30))
        // Set how do you want to maintain the aspect
        titleView.contentMode = .ScaleAspectFit
        let image = UIImage(named: "BuildingWaitakiLogoText.png")
        let tintedImage = image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        titleView.tintColor = AppSettings().getTintColour()
        
        titleView.image = tintedImage
        
        self.navigationItem.titleView = titleView
        
        nav?.titleTextAttributes = [NSFontAttributeName: settings.getTitleFont(),NSForegroundColorAttributeName: settings.getTintColour()]
        
        
        //searchbar
        searchBar.backgroundColor = UIColor.clearColor()
        searchBar.backgroundImage = UIImage()
        searchBar.keyboardAppearance = UIKeyboardAppearance.Dark

        
        let textFieldInsideSearchBar = searchBar.valueForKey("searchField") as? UITextField
        textFieldInsideSearchBar?.font = settings.getTextFont()
        textFieldInsideSearchBar?.keyboardAppearance = .Dark
        textFieldInsideSearchBar?.textColor = settings.getTextColour()
        
        for btn in searchBar.subviews
        {
            if btn.isKindOfClass(UIButton)
            {
                (btn as! UIButton).setTitleColor(settings.getTintColour(), forState: UIControlState.Normal)
            }
   
            
        }
        
        //end style setup
        
        
        
        //clear unsynced inspections list
        for view in unfinishedInspectionsScrollview.subviews
        {
            view.removeFromSuperview()
        }
        
        let existingRequest = NSFetchRequest(entityName: "ConsentInspection")
        let resultPredicate1 = NSPredicate(format: "needSynced = %@", NSNumber(bool: true))
        let compound1 = NSCompoundPredicate(andPredicateWithSubpredicates: [resultPredicate1])
        var currentY = CGFloat(5)
        let height = CGFloat(50)
        
        
        existingRequest.predicate = compound1
        
        let unfinishedInspections = (try? managedObjectContext!.executeFetchRequest(existingRequest)) as? [ConsentInspection]
        
        for inspection in unfinishedInspections!
        {
            let container = UIView(frame: CGRect(x: CGFloat(5), y: currentY, width: unfinishedInspectionsScrollview.frame.width - 10, height: height))
            container.backgroundColor = settings.getContainerBackground()
            
            let border = CALayer()
            border.backgroundColor = UIColor.grayColor().CGColor
            border.frame = CGRect(x: CGFloat(((container.frame.width - (container.frame.width - 20)) / 2)) , y: CGFloat(container.frame.height - 1), width: CGFloat(container.frame.width - 20), height: CGFloat(1))
            container.layer.addSublayer(border)
            
            
            let tap = UITapGestureRecognizer(target: self, action:#selector(HomeController.handleTap(_:)))
            tap.delegate = self
            container.addGestureRecognizer(tap)
            
            
            let consentNumber = UILabel(frame: CGRect(x: 5, y: 5, width: container.frame.width, height: (height / 2) - 5))
            consentNumber.text = inspection.consentId
            consentNumber.font = settings.getTextFont()
            consentNumber.textColor = settings.getTextColour()
            
            let inspectionName = UILabel(frame: CGRect(x: 5, y: height / 2, width: container.frame.width , height: (height / 2) - 5))
            inspectionName.text = inspection.inspectionName
            inspectionName.font = settings.getTextFont()
            inspectionName.textColor = settings.getTextColour()
            
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
            
            //update scrollview size
            unfinishedInspectionsScrollview.contentSize = CGSize(width: unfinishedInspectionsScrollview.frame.width, height: currentY + height + 50)
            
            
        }
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Retreive the managedObjectContext from AppDelegate
        managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        
        
        
        //display consents in core data
        displayConsents = DisplayConsents(scrollView: consentScrollView,managedContext: managedObjectContext!, searchBar: searchBar, homeController: self)
        displayConsents.displayConsents(nil)
        
        officeTools = OfficeTools(managedContext: managedObjectContext!,controller: self,displayConsents: displayConsents, background: background)
        
        let settings = AppSettings()
        if settings.getAPIServer() == ""
        {
            var popup:UIAlertController
            popup = UIAlertController(title: "No Api Server Set",
                message: "Please ask your IT Administrator for the Api Server",
                preferredStyle: .Alert)
            
            popup.addAction(UIAlertAction(title: "Ok",
                style: UIAlertActionStyle.Cancel,
                handler: nil))
            
            popup = AppSettings().getPopupStyle(popup)
            
            self.presentViewController(popup, animated: true, completion: nil)
        }
        
        if settings.getUser() == ""
        {
            var popup:UIAlertController
            popup = UIAlertController(title: "No User Set",
                message: "Please enter your NAR number",
                preferredStyle: .Alert)
            
            popup.addAction(UIAlertAction(title: "Ok",
                style: UIAlertActionStyle.Cancel,
                handler: nil))
            
            popup = AppSettings().getPopupStyle(popup)
            
            self.presentViewController(popup, animated: true, completion: nil)
        }
        
        

        
    }
    
    func handleTap(sender: UITapGestureRecognizer) {
        let consentNumber = (sender.view?.subviews[0] as! UILabel).text
        let inspectionName = (sender.view?.subviews[1] as! UILabel).text
        
        //get the consent inspection Required
        let consentInspectionRequest = NSFetchRequest(entityName: "ConsentInspection")
        let resultPredicate1 = NSPredicate(format: "consentId = %@", consentNumber!)
        let resultPredicate2 = NSPredicate(format: "inspectionName = %@", inspectionName!)
        let compound1 = NSCompoundPredicate(andPredicateWithSubpredicates:[resultPredicate1,resultPredicate2])
        consentInspectionRequest.predicate = compound1
        
        let currentInspection = (try? managedObjectContext!.executeFetchRequest(consentInspectionRequest))?.first as! ConsentInspection

        
        let currentInspectionController = self.storyboard!.instantiateViewControllerWithIdentifier("CurrentInspectionViewController") as! CurrentInspectionViewController
        currentInspectionController.consentInspection = currentInspection
        currentInspectionController.title = currentInspection.inspectionName
        currentInspectionController.managedContext = managedObjectContext
        currentInspectionController.startTime = NSDate()
        self.navigationController!.pushViewController(currentInspectionController, animated: true)
    }
    
    @IBAction func sendInspections(sender: UIButton)
    {
      
        officeTools!.sendResults()
    }
    
    func sendInspectionsComplete(result: String)
    {
        for curView in self.view.subviews
        {
            if curView.isKindOfClass(UIVisualEffectView)
            {
                curView.removeFromSuperview()
            }
        }

        var message = ""
        
        if (result != "")
        {
            let data = result.dataUsingEncoding(NSASCIIStringEncoding, allowLossyConversion: false)
           // var localError: NSError?
            if let mydata = data
            {
                var json: AnyObject!
                do {
                    json = try NSJSONSerialization.JSONObjectWithData(mydata, options: NSJSONReadingOptions.MutableContainers)
                } catch let error as NSError {
                  print(error)
                    json = nil
                }
            if let jsonDictionary = json as? Dictionary<String,String>
            {
                if (jsonDictionary["result"]  == "success")
                {
                    message = jsonDictionary["result"]!
                   // officeTools!.getConsents(true)
                }
                else
                {
                   message = jsonDictionary["error"]!
                }
                }
            }
            else
            {
                message = "error passing data from api"
            }
        }
        
        var result = false as Bool
        
        var popup:UIAlertController
        if message == "success"
        {
            popup = UIAlertController(title: "Sending Inspections Complete",
            message: "Syncing finished with result: " + message + ". New consents will now be downloaded",
            preferredStyle: .Alert)
            result = true
            
        }
        else
        {
                popup = UIAlertController(title: "Sending Inspections FAILED",
                message: "Syncing failed. Please show your IT administrator: " + message,
                preferredStyle: .Alert)
        }
        
    
        
        
        
        
        popup.addAction(UIAlertAction(title: "Ok",
            style: UIAlertActionStyle.Cancel,
            handler: nil))
        
        popup = AppSettings().getPopupStyle(popup)
        self.presentViewController(popup, animated: true, completion: nil)
        
        if result
        {
            officeTools.getConsents()
        }
        
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

