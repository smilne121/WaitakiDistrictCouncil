//
//  AddInspectionViewController.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 26/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import UIKit
import CoreData

class AddInspectionViewController: UITableViewController {
    
    var currentConsent : Consent!
    var managedContext : NSManagedObjectContext!
    var inspectionItems : [InspectionType]!
    var inspectionId : String?

    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        for curview in view.subviews
        {
            if curview.isKindOfClass(UITableView)
            {
                (curview as! UITableView).backgroundColor = AppSettings().getViewBackground()
            }
        }
        
        self.title = "Pick inspection to add"
        
        self.tableView.registerClass(AddInspectionTableViewCell.self, forCellReuseIdentifier: "addInspectionCell")
        
        self.tableView.backgroundColor = AppSettings().getViewBackground()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inspectionItems.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let sorted = inspectionItems.sort {$0.inspectionName < $1.inspectionName}
        
        let cell = tableView.dequeueReusableCellWithIdentifier("addInspectionCell", forIndexPath: indexPath) as! AddInspectionTableViewCell
        cell.textLabel?.text = sorted[indexPath.row].inspectionName
        cell.textLabel?.textColor = AppSettings().getTintColour()
        cell.textLabel?.font = AppSettings().getTextFont()
        cell.textLabel!.superview!.backgroundColor = UIColor.clearColor()
        cell.textLabel!.superview!.superview!.superview!.backgroundColor = UIColor.clearColor()
        cell.textLabel!.superview!.superview!.backgroundColor = UIColor.clearColor()//AppSettings().getViewBackground()
        cell.textLabel?.backgroundColor = UIColor.clearColor() //AppSettings().getViewBackground()

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sorted = inspectionItems.sort {$0.inspectionName < $1.inspectionName}
        
        inspectionId = sorted[indexPath.row].inspectionId
        createInspection(nil)
    }
    
    func createInspection (alert: UIAlertAction?)
    {
        let existingRequest = NSFetchRequest(entityName: "ConsentInspection")
        let resultPredicate1 = NSPredicate(format: "inspectionId = %@", inspectionId!)
        let resultPredicate2 = NSPredicate(format: "consentId = %@", currentConsent.consentNumber)
        let compound1 = NSCompoundPredicate(andPredicateWithSubpredicates:[resultPredicate1,resultPredicate2])
        existingRequest.predicate = compound1
        
        let inspectionItemsArray = (try? managedContext.executeFetchRequest(existingRequest)) as? [ConsentInspection]
        
        let fetchRequest = NSFetchRequest(entityName: "InspectionType")
        let resultPredicate = NSPredicate(format: "inspectionId = %@", inspectionId!)
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates:[resultPredicate])
        fetchRequest.predicate = compound
        
        if let fetchResult = (try? managedContext.executeFetchRequest(fetchRequest))?.first as? InspectionType
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
            
            inspection.consent = currentConsent
            inspection.consentId = currentConsent.consentNumber
            inspection.locked = false
            inspection.userCreated = NSNumber(bool: true)
            inspection.needSynced = NSNumber(bool: false)
            inspection.status = ""
            
            for item in fetchResult.inspectionTypeItems.allObjects as! [InspectionTypeItems]
            {
                let inspectionItem = NSEntityDescription.insertNewObjectForEntityForName("ConsentInspectionItem", inManagedObjectContext: managedContext) as! ConsentInspectionItem
                inspectionItem.inspectionId = fetchResult.inspectionId
                inspectionItem.inspectionName = inspectionName
                inspectionItem.consentId = currentConsent.consentNumber
                inspectionItem.itemId = item.itemId
                inspectionItem.itemName = item.itemName
                inspectionItem.consentInspection = inspection
            }
            do {
                try managedContext.save()
            } catch let error1 as NSError {
                print("Could not save \(error1), \(error1.userInfo)")
            }
            
            navigationController?.popViewControllerAnimated(true)
        }

    }
    
    

    

   }
