//
//  CurrentInspectionViewController.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 15/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import UIKit
import CoreData

class CurrentInspectionViewController: UIViewController {
    var consentInspection : ConsentInspection!
    var inspectionTypeItems : [InspectionTypeItems]!
    var managedContext: NSManagedObjectContext!
    
    @IBOutlet weak var itemHolder: UIScrollView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //call core data inspectiontypes to get items to display
        var error: NSError?
        //get consents inspection
        let fetchRequest = NSFetchRequest(entityName: "InspectionTypeItems")
        fetchRequest.includesSubentities = true
        fetchRequest.returnsObjectsAsFaults = false
        let resultPredicate = NSPredicate(format: "inspectionId = %@", consentInspection.inspectionId)
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate])
        fetchRequest.predicate = compound
        inspectionTypeItems = managedContext.executeFetchRequest(fetchRequest, error: nil) as! [InspectionTypeItems]
        
        generateItemsOnscreen()
        
        
        //populate items with any results
        //println(consentInspection.inspectionItem)
        for item:AnyObject in consentInspection.inspectionItem
        {
            println((item as! ConsentInspectionItem).itemId)
        }
        
        
        // Do any additional setup after loading the view.
        
        //load inspection items from consentinspection object
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateItemsOnscreen()
    {
        var leftSide = Bool(true)
        let fontsize = CGFloat(15)
        var currentX = 0
        var currentY = 0
        let height = 200
        let width = Int(itemHolder.frame.width / 2 )
        
        //loop though items and create containers
        for item in inspectionTypeItems
        {
            if item.itemName != "Complete"
            {
            let containerRect: CGRect = CGRect(x: currentX,y: currentY,width: width,height: height)
            let container: UIView = UIView(frame: containerRect)
            container.layer.borderColor = UIColor .blackColor().CGColor
            container.layer.borderWidth = 1.0
            container.backgroundColor = UIColor.whiteColor()
            container.tintColor = UIColor.blackColor()
            
            
            // add label to item
            let itemName = UILabel(frame: CGRect(x: 5, y: 5, width: container.frame.width, height: 30))
            itemName.text = item.itemName
            let font = UIFont(name: itemName.font.fontName, size: CGFloat(20))
            itemName.font = font
            container.addSubview(itemName)
            itemHolder.addSubview(container)
            
            //check item type and add selector
            if item.itemType.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == "F" //Flag type = bool
            {
                let selectorItems = ["Passed" ,"Failed"]
                let selector = UISegmentedControl(items: selectorItems)
                selector.selectedSegmentIndex = -1
                selector.tintColor = UIColor.darkGrayColor()
                
                var attr = NSDictionary(object: UIFont(name: "HelveticaNeue-Bold", size: 16.0)!, forKey: NSFontAttributeName)
                selector.setTitleTextAttributes(attr as [NSObject : AnyObject], forState: .Normal)
                
                selector.frame = CGRect(x: 10, y: 50, width: container.frame.width - 20, height: 80)
                container.addSubview(selector)
                
            }
            
            //move to next space
            if leftSide == true
            {
                leftSide = false
                currentX = width + currentX
            }
            else
            {
                currentX = width - currentX
                currentY = height + currentY
                leftSide = true
            }
            }
        }
        
        //update content size of scrollview to match
        let contentSize = CGSize(width: itemHolder.frame.width, height: CGFloat(currentY) + CGFloat(height) )
        itemHolder.contentSize = contentSize
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
