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
        
        self.tableView.registerClass(AddInspectionTableViewCell.self, forCellReuseIdentifier: "addInspectionCell")
        

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
        let sorted = inspectionItems.sorted {$0.inspectionName < $1.inspectionName}
        
        let cell = tableView.dequeueReusableCellWithIdentifier("addInspectionCell", forIndexPath: indexPath) as! AddInspectionTableViewCell
        cell.textLabel?.text = sorted[indexPath.row].inspectionName

        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let sorted = inspectionItems.sorted {$0.inspectionName < $1.inspectionName}
        
        inspectionId = sorted[indexPath.row].inspectionId
        createInspection(nil)

        /*for inspection in currentConsent.consentInspection.allObjects as! [ConsentInspection]
        {
            if inspection.inspectionId == sorted[indexPath.row].inspectionId
            {
                inspectionId = inspection.inspectionId
                let popup = UIAlertController(title: "This inspection already exists",
                    message: "Do you wish to create another " + sorted[indexPath.row].inspectionName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) + " inspection",
                    preferredStyle: .Alert)
                
                popup.addAction(UIAlertAction(title: "OK",
                    style: UIAlertActionStyle.Default,
                    handler: self.createInspection))
                
                popup.addAction(UIAlertAction(title: "Cancel",
                    style: UIAlertActionStyle.Cancel,
                    handler: nil))
                
                self.presentViewController(popup, animated: true, completion: nil)
            }
            else
            {
                inspectionId = inspection.inspectionId
                createInspection(nil)
            }
        }*/
    }
    
    func createInspection (alert: UIAlertAction?)
    {
        var existingRequest = NSFetchRequest(entityName: "ConsentInspection")
        let resultPredicate1 = NSPredicate(format: "inspectionId = %@", inspectionId!)
        let resultPredicate2 = NSPredicate(format: "consentId = %@", currentConsent.consentNumber)
        var compound1 = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1,resultPredicate2])
        existingRequest.predicate = compound1
        
        let inspectionItemsArray = managedContext.executeFetchRequest(existingRequest, error: nil) as? [ConsentInspection]
        
        var fetchRequest = NSFetchRequest(entityName: "InspectionType")
        let resultPredicate = NSPredicate(format: "inspectionId = %@", inspectionId!)
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate])
        fetchRequest.predicate = compound
        
        if let fetchResult = managedContext.executeFetchRequest(fetchRequest, error: nil)?.first as? InspectionType
        {
            let inspection = NSEntityDescription.insertNewObjectForEntityForName("ConsentInspection", inManagedObjectContext: managedContext) as! ConsentInspection
            inspection.inspectionId = fetchResult.inspectionId
            let inspectionName = fetchResult.inspectionName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())  + " " + String(inspectionItemsArray!.count + 1)
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
            managedContext.save(nil)
            
            navigationController?.popViewControllerAnimated(true)
        }

    }
    
    

    

   }
