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
        
        view.backgroundColor = AppSettings().getContainerBackground()
        view.tintColor = AppSettings().getTintColour()
       /* for button in view.subviews
        {
            if button.isKindOfClass(UIButton)
            {
                (button as! UIButton).titleLabel?.font = AppSettings().getTextFont()
                (button as! UIButton).titleLabel?.textColor = AppSettings().getTintColour()
                (button as! UIButton).tintColor = AppSettings().getTintColour()
                
            }
        }*/
        
        view.addSubview(scrollView!)
        
        //style scrollview
        scrollView!.tintColor = AppSettings().getTintColour()

        for contact in consent.contact
        {
            scrollView!.addSubview(createContact(contact as! Contact))
        }
        
        
        let btnClose = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        println(view.frame.height)
        btnClose.frame = CGRectMake(200,viewHeight! - 43, 100,40)
        btnClose.titleLabel!.font = AppSettings().getTextFont()
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
        view.backgroundColor = UIColor.clearColor()
        view.tintColor = AppSettings().getTintColour()
        
        let border = CALayer()
        border.backgroundColor = AppSettings().getTintColour().CGColor
        border.frame = CGRect(x: CGFloat(((view.frame.width - (view.frame.width - 30)) / 2)) , y: CGFloat(view.frame.height - 1), width: CGFloat(view.frame.width - 30), height: CGFloat(1))
        view.layer.addSublayer(border)
        
        
        let name = UILabel(frame: CGRect(x: 5, y: 5, width: 250, height: 20))
        name.text = contact.firstName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) + " " + contact.lastName.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        name.font = AppSettings().getTextFont()
        name.textColor = AppSettings().getTextColour()
        
        let home = UILabel(frame: CGRect(x: 5, y: 25, width: 250, height: 20))
        home.text = "Home Ph: " + contact.homePhone
        home.font = AppSettings().getTextFont()
        home.textColor = AppSettings().getTextColour()
        
        let position = UILabel(frame: CGRect(x: 255, y: 5, width: 240, height: 20))
        position.text = "Position: " + contact.position
        position.font = AppSettings().getTextFont()
        position.textColor = AppSettings().getTextColour()
        
        let cell = UILabel(frame: CGRect(x: 255, y: 25, width: 250, height: 20))
        cell.text = "Mobile: " + contact.cellPhone
        cell.font = AppSettings().getTextFont()
        cell.textColor = AppSettings().getTextColour()
        
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
