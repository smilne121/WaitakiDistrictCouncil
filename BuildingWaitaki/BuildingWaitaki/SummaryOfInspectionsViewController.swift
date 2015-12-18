//
//  SummaryOfInspectionsViewController.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 18/12/15.
//  Copyright © 2015 Waitaki District Council. All rights reserved.
//

import UIKit
import CoreData

class SummaryOfInspectionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var tableView: UITableView!
    
    var consent : Consent!
    var managedContext : NSManagedObjectContext!
    var summaryItems: [SummaryItems]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        print(consent.consentNumber)
        print(consent.filteredConsents().count)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        generationSummaryItems() //make sure items are loaded before adding to table
        return summaryItems!.count
    }
    
    func generationSummaryItems()
    {
        summaryItems = [SummaryItems]()
        
        let consentInspections = consent.filteredConsents().allObjects as! [ConsentInspection]
        
        for inspection in consentInspections
        {
            let inspectionHeader = SummaryItems(itemName: nil, itemComment: nil, itemResult: nil, inspectionName: inspection.inspectionName)
            
            summaryItems?.append(inspectionHeader)
            
            //add items under this header
            for item in inspection.inspectionItem.allObjects as! [ConsentInspectionItem]
            {
                let inspectionItem = SummaryItems(itemName: item.itemName, itemComment: item.itemComment, itemResult: item.itemResult, inspectionName: nil)
                summaryItems?.append(inspectionItem)
            }
            
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("InspectionSummaryCell", forIndexPath: indexPath) as! InspectionSummaryTableViewCell
        
        
        //loop through inspection items
        let item : SummaryItems = summaryItems![indexPath.row]
        
                cell.inspectionName.text = item.inspectionName
                cell.inspectionItemName.text = item.itemName
                cell.inspectionResult.text = item.itemResult
                cell.inspectionItemComments.text = item.itemComment
                cell.inspectionItemName.textColor = item.colour
            
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

    }

}

class SummaryItems {
    
    var itemName: String?
    var itemComment: String?
    var itemResult: String?
    var inspectionName: String?
    var colour: UIColor?
    
    init(itemName: String?, itemComment: String?,itemResult: String?,inspectionName: String?)
    {
        self.itemName = itemName
        self.itemResult = itemResult
        self.itemComment = itemComment
        self.inspectionName = inspectionName
        
        if itemResult == "FAIL"
        {
            colour = UIColor.redColor()
        }
        else
        {
            colour = UIColor.blackColor()
        }
    }

}


