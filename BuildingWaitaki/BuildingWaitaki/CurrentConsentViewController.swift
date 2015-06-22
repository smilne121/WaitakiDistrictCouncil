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
    
    override func viewWillAppear(animated: Bool) {
        self.tableView.reloadData() //update for any content changed with comments
    }
    
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
        }
        
        //assign image if required
        let image: UIImage
        if let status = inspectionArraySorted[indexPath.row].status
        {
            if status == "failed"
            {
                println(inspectionArraySorted[indexPath.row].status)
                println(inspectionArraySorted[indexPath.row].inspectionName)
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