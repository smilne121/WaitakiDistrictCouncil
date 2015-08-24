//
//  ContactsViewController.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 24/08/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController {
    
    var consent: Consent!
    var currentY : CGFloat?
    var scrollView: UIScrollView?
    var viewHeight: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView = UIScrollView(frame: CGRect(x: CGFloat(0), y: CGFloat(5), width: CGFloat(500), height: CGFloat(viewHeight! - 50)))
        
        currentY = CGFloat(0)
        
        view.addSubview(scrollView!)

        for contact in consent.contact
        {
            scrollView!.addSubview(createContact(contact as! Contact))
        }
        
        
        let btnClose = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        println(view.frame.height)
        btnClose.frame = CGRectMake(200,viewHeight! - 43, 100,40)
        btnClose.setTitle("Close", forState: .Normal)
      btnClose.addTarget(self, action: "close:", forControlEvents: UIControlEvents.TouchUpInside)
        view.addSubview(btnClose)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func close (sender: UIButton)
    {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    
    func createContact(contact : Contact) -> UIView
    {
        let view = UIView(frame: CGRect(x: CGFloat(3), y: currentY!, width: scrollView!.frame.width - 6, height: CGFloat(50)))
        view.layer.borderColor = UIColor.blackColor().CGColor
        view.layer.cornerRadius = CGFloat(5.0)
        view.layer.borderWidth = 2
        
        
        let name = UILabel(frame: CGRect(x: 5, y: 5, width: 250, height: 20))
        name.text = contact.firstName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) + " " + contact.lastName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        let home = UILabel(frame: CGRect(x: 5, y: 25, width: 250, height: 20))
        home.text = "Home Ph: " + contact.homePhone
        
        let position = UILabel(frame: CGRect(x: 255, y: 5, width: 240, height: 20))
        position.text = "Position: " + contact.position
        
        let cell = UILabel(frame: CGRect(x: 255, y: 25, width: 250, height: 20))
        cell.text = "Mobile: " + contact.cellPhone
        
        view.addSubview(name)
        view.addSubview(home)
        view.addSubview(position)
        view.addSubview(cell)
        
        
        
        currentY! = currentY! + 48
        
        return view
        
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
