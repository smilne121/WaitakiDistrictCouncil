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
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = currentConsent.consentAddress + "  " + currentConsent.consentNumber
        self.tableView.rowHeight = CGFloat(150)
        
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentConsent.consentInspection.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
       /* var passed = 0
        var failed = 0
        var uncomplete = 0*/

        let cell = self.tableView.dequeueReusableCellWithIdentifier("currentInspectionCell", forIndexPath: indexPath) as! CurrentConsentTableViewCell
        
        let inspectionArray = currentConsent.consentInspection.allObjects as! [ConsentInspection]
        
        let inspectionArraySorted = inspectionArray.sorted { $0.inspectionId < $1.inspectionId } //sort by item number after
        
        /*//check if all required fields are completed NEED TO MOVE TO BEFORE HERE TO POPULATE FIELD IN DATABASE TO CHECK STATUS
        
        var error: NSError?
        //get consents inspection
        let fetchRequest = NSFetchRequest(entityName: "InspectionTypeItems")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        let resultPredicate = NSPredicate(format: "inspectionId = %@", inspectionArraySorted[indexPath.row].inspectionId)
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate])
        fetchRequest.predicate = compound
        
        //get inspection results
        let fetchRequest2 = NSFetchRequest(entityName: "ConsentInspectionItem")
        fetchRequest2.includesSubentities = true
        fetchRequest2.returnsObjectsAsFaults = false
        let resultPredicate2 = NSPredicate(format: "inspectionId = %@", inspectionArraySorted[indexPath.row].inspectionId)
        
        var compound2 = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate2])
        fetchRequest2.predicate = compound2

        //inspection items for selected inspection
        let inspectionItems = managedContext.executeFetchRequest(fetchRequest, error: nil) as! [InspectionTypeItems]
        let inspectionResults = managedContext.executeFetchRequest(fetchRequest2, error: nil) as! [ConsentInspectionItem]
        
        //loop through and match results to required fields
        for item in inspectionItems
        {
            if item.required == NSNumber(bool: true)
            {
                for result in inspectionResults
                {
                    if item.itemId == result.itemId
                    {
                        if let currentResult = result.itemResult
                        {
                            if item.itemType.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "F"
                            {
                                if result.itemResult!.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "Y"
                                {
                                    passed = passed + 1
                                }
                                else
                                {
                                      println("id: " + cell.inspectionName.text!)
                                    println(item.inspectionId)
                                    println(item.itemId)
                                    failed = failed + 1
                                }
                            }
                        }
                        else
                        {
                             uncomplete = uncomplete + 1
                                                    }
                    }
                }
            }
        }*/
        
        cell.inspectionName.text = inspectionArraySorted[indexPath.row].inspectionName
        cell.inspectionComments.text = "need access to this property"
        
      

        //assign image if required
        let image: UIImage
        if let status = inspectionArraySorted[indexPath.row].status
        {
            if status == "Failed"
            {
                image = UIImage(named: "Failed.png") as UIImage!
                cell.statusImage.image = image
            }
            else if status == "Passed"
            {
                image  = UIImage(named: "passed.png") as UIImage!
                cell.statusImage.image = image
            }
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