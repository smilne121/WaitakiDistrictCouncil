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
        println(currentConsent.consentDescription)
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
        var passed = 0
        var failed = 0
        var uncomplete = 0
        // var cell:CurrentConsentTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("currentInspectionCell") as! CurrentConsentTableViewCell
        let cell = self.tableView.dequeueReusableCellWithIdentifier("currentInspectionCell", forIndexPath: indexPath) as! CurrentConsentTableViewCell
        
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as PlacesTableViewCell
        let inspectionArray = currentConsent.consentInspection.allObjects as! [ConsentInspection]
        
        let inspectionArraySorted = inspectionArray.sorted { $0.inspectionId < $1.inspectionId } //sort by item number after
        
        
        //check if all required fields are completed
        
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
                    println("Item")
                    println(item)
                    println("Result")
                    println(result)
                    if item.itemId == result.itemId
                    {
                        if result.itemResult.isEmpty
                        {
                            uncomplete = uncomplete + 1
                        }
                        else
                        {
                            if item.itemType == "F"
                            {
                                if result.itemResult == "Y"
                                {
                                    passed = passed + 1
                                }
                                else
                                {
                                    failed = failed + 1
                                }
                            }
                        }
                    }
                }
            }
        }
        
        //cell.textLabel?.text = inspectionArraySorted[indexPath.row].inspectionName
        cell.inspectionName.text = inspectionArraySorted[indexPath.row].inspectionName
        cell.inspectionComments.text = "need access to this property"
        
        //assign image if required
        let image: UIImage
        if uncomplete  < 1
        {
            if failed > 0
            {
                image = UIImage(named: "Failed.png") as UIImage!
            }
            else
            {
                image  = UIImage(named: "passed.png") as UIImage!
            }
            cell.statusImage.image = image
        }
        
        
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        //goto new controller
        let currentInspectionController = self.storyboard!.instantiateViewControllerWithIdentifier("CurrentInspectionViewController") as! CurrentInspectionViewController
        self.navigationController!.pushViewController(currentInspectionController, animated: true)
        
    }
}