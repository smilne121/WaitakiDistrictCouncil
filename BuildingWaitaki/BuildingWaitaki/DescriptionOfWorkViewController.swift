//
//  DescriptionOfWorkViewController.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 24/08/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import UIKit

class DescriptionOfWorkViewController: UIViewController {
    
    var consent : Consent!

    @IBOutlet weak var consentTitle: UILabel!
    @IBOutlet weak var DescriptionOfWorkText: UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()
consentTitle.text = (consentTitle.text! + consent.consentNumber)
        DescriptionOfWorkText.text = consent.consentDescription
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeClicked(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
