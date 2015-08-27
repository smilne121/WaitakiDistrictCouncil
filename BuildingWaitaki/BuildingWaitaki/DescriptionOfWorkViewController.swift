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
        
        self.view.layer.shadowColor = UIColor.blackColor().CGColor
        self.view.layer.shadowOpacity = 0.7
        self.view.layer.shadowOffset = CGSize(width: CGFloat(10), height: CGFloat(10))
        self.view.layer.shadowRadius = 5.0
        self.view.layer.masksToBounds = false
        
        self.view.backgroundColor = AppSettings().getContainerBackground()
        
        for view in self.view.subviews
        {
            if view.isKindOfClass(UILabel)
            {
                (view as! UILabel).textColor = AppSettings().getTintColour()
                (view as! UILabel).font = AppSettings().getTitleFont()
            }
            else if view.isKindOfClass(UIButton)
            {
                (view as! UIButton).tintColor = AppSettings().getTintColour()
                (view as! UIButton).titleLabel?.font = AppSettings().getTextFont()
            }
        }
        
        DescriptionOfWorkText.textColor = AppSettings().getTextColour()
        DescriptionOfWorkText.font = AppSettings().getTextFont()
        DescriptionOfWorkText.backgroundColor = UIColor.clearColor()
        
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
