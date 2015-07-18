//
//  CurrentConsentViewController.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 15/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import UIKit
import CoreData

class CurrentConsentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentConsent: Consent!
    var managedContext: NSManagedObjectContext!
    var officeTools: OfficeTools!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewWillAppear(animated: Bool) {
         //check and update items status
        let inspections = (currentConsent.consentInspection.allObjects) as! [ConsentInspection]

        for inspection in inspections
        {
            let chkins = OfficeToolsCheckInspection()
            inspection.status = (chkins.checkInspectionStatus(inspection,managedContext: managedContext))
        }
        
        //add consent to core data
        if !managedContext.save(nil)
        {
            println("Could not save")
        }
        
        
        //reload data on table
        self.tableView.reloadData() //update for any content changed with comments
        
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addInspectionClicked:"), animated: true)
        
        
        // Do any additional setup after loading the view.
        self.title = currentConsent.consentAddress + "  " + currentConsent.consentNumber
        self.tableView.rowHeight = CGFloat(150)
        
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addInspectionClicked(sender: UIBarButtonItem)
    {
        let viewController = AddInspectionViewController()
        viewController.currentConsent = currentConsent
        viewController.managedContext = managedContext
        
        var resultRequest = NSFetchRequest(entityName: "InspectionType")
        let inspectionItems = managedContext.executeFetchRequest(resultRequest, error: nil) as? [InspectionType]
        
        viewController.inspectionItems = inspectionItems
        navigationController!.pushViewController(viewController, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentConsent.consentInspection.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("currentInspectionCell", forIndexPath: indexPath) as! CurrentConsentTableViewCell
        
        let inspectionArray = currentConsent.consentInspection.allObjects as! [ConsentInspection]
        
        let inspectionArraySorted = inspectionArray.sorted { $0.inspectionId < $1.inspectionId } //sort by item number after
        
        cell.inspectionName.text = inspectionArraySorted[indexPath.row].inspectionName
        
        for item in inspectionArraySorted[indexPath.row].inspectionItem.allObjects as! [ConsentInspectionItem]
        {
            if item.itemName == "Comments"
            {
                cell.inspectionComments.text = item.itemResult
            }
            if item.itemName == "Inspection Officer"
            {
                cell.inspectionUpdatedBy.text = item.itemResult
            }
            if item.itemName == "Date"
            {
                cell.inspectionUpdatedDate.text = item.itemResult
            }
        }
        
        
        //assign image if required
        let image: UIImage
        if let status = inspectionArraySorted[indexPath.row].status
        {
            if status == "failed"
            {
                image = UIImage(named: "Failed.png") as UIImage!
                cell.statusImage.image = image
            }
            else if status == "passed"
            {
                image  = UIImage(named: "passed.png") as UIImage!
                cell.statusImage.image = image
            }
            else if status == ""
            {
                image  = UIImage(named: "todo.png") as UIImage!
                cell.statusImage.image = image
            }
        }
        if inspectionArraySorted[indexPath.row].locked == NSNumber(bool: true)
        {
            let lockImage  = UIImage(named: "Lock-50.png") as UIImage!
            cell.lockImage.image = lockImage
            
        }
        else
        {
            let lockImage  = UIImage(named: "todo.png") as UIImage!
            cell.lockImage.image = lockImage
        }
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        //goto new controller
        let inspectionArray = currentConsent.consentInspection.allObjects as! [ConsentInspection]
        let inspectionArraySorted = inspectionArray.sorted { $0.inspectionId < $1.inspectionId } //sort by item number after
        let currentInspectionController = self.storyboard!.instantiateViewControllerWithIdentifier("CurrentInspectionViewController") as! CurrentInspectionViewController
        currentInspectionController.consentInspection = inspectionArraySorted[indexPath.row]
        currentInspectionController.title = inspectionArraySorted[indexPath.row].inspectionName
        currentInspectionController.managedContext = managedContext
        self.navigationController!.pushViewController(currentInspectionController, animated: true)
        
    }
}