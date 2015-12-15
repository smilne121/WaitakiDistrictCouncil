//
//  ConsentConditionsViewController.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 15/12/15.
//  Copyright © 2015 Waitaki District Council. All rights reserved.
//

import UIKit

class ConsentConditionsViewController: UIViewController {
    
    var consent : Consent!
    @IBOutlet weak var consentTitle: UILabel!
    @IBOutlet weak var txtConsentConditions: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        txtConsentConditions.text = consent.consentConditions
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
