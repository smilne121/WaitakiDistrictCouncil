//
//  CurrentConsentViewController.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 15/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import UIKit

class CurrentConsentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentConsent: Consent!
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
       // var cell:CurrentConsentTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("currentInspectionCell") as! CurrentConsentTableViewCell
         let cell = self.tableView.dequeueReusableCellWithIdentifier("currentInspectionCell", forIndexPath: indexPath) as! CurrentConsentTableViewCell
        
        
        //let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as PlacesTableViewCell
        let inspectionArray = currentConsent.consentInspection.allObjects as! [ConsentInspection]
        
        let inspectionArraySorted = inspectionArray.sorted { $0.inspectionId < $1.inspectionId } //sort by item number after
        
        //cell.textLabel?.text = inspectionArraySorted[indexPath.row].inspectionName
        cell.inspectionName.text = inspectionArraySorted[indexPath.row].inspectionName
        cell.inspectionComments.text = "need access to this property"
        let image = UIImage(named: "passed.png") as UIImage!
        cell.statusImage.image = image
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("You selected cell #\(indexPath.row)!")
        //goto new controller
        let currentInspectionController = self.storyboard!.instantiateViewControllerWithIdentifier("CurrentInspectionViewController") as! CurrentInspectionViewController
        self.navigationController!.pushViewController(currentInspectionController, animated: true)

    }
}
