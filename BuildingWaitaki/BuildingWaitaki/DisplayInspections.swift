//
//  DisplayInspections.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 13/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

/*import Foundation
import UIKit
import CoreData

class DisplayInspections {
    let view: UIView
    let managedContext: NSManagedObjectContext
    
    init (view: UIView, managedContext: NSManagedObjectContext)
    {
        self.managedContext = managedContext
        self.view = view
    }
    
    func displayInspections(consentNumber: String)
    {
       // println("into inspections view")
        let inspectionsView: UIView
       // inspectionsView.d
        
        var error: NSError?
        //get consents inspection
        let fetchRequest = NSFetchRequest(entityName: "ConsentInspection")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        
        let resultPredicate = NSPredicate(format: "consentId = %@", consentNumber)
        
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate])
        fetchRequest.predicate = compound
        
        let inspections = managedContext.executeFetchRequest(fetchRequest, error: nil)
        
       //  for inspection in inspections as! [ConsentInspection]
      //  {
   //         println(inspection)
            createView(inspections!)
            //for contact in consent.contact.allObjects
            //{
            //    let contact2 = contact as! Contact
            //    println(contact2.firstName)
            //}
      //  }
    }
    
    private func createView(inspections: [AnyObject])
    {
        //point to new xib
       /* var y = 0 as CGFloat
        var lightBlur = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        var blurView = UIVisualEffectView(effect: lightBlur)
        blurView.frame = view.bounds
        view.addSubview(blurView)

        
        let width = CGFloat(475)
        let height = CGFloat(500)
        let containerRect: CGRect = CGRect(x: (view.frame.width / 2) - (width / 2),y: (view.frame.height / 2) - (height / 2),width: width,height: height)
        let container: UIView = UIView(frame: containerRect)
        container.layer.borderColor = UIColor .blackColor().CGColor
        container.layer.borderWidth = 3.0
        container.backgroundColor = UIColor.whiteColor()
        container.tintColor = UIColor.blackColor()
        println(inspections.count)
        for inspection in inspections as! [ConsentInspection]
        {
            let btnInspection = UIButton.buttonWithType(UIButtonType.System) as! UIButton
            btnInspection.titleLabel?.textColor = UIColor.blackColor()
            btnInspection.frame = CGRect(x: 0,y: 0,width: width,height: y)
            y = y + 30
            btnInspection.setTitle(inspection.inspectionName, forState: UIControlState.Normal)
            container.addSubview(btnInspection)
        }
        println(container.subviews.count)
        view.addSubview(container)
    }
    */
    }
}*/
