//
//  Inspection.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 6/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import UIKit

class InspectionItem {
    
    var Item: String
    var Type: InspectionType
    var Position: CGRect!
    let height: Int16
    let width: Int16
    var delegateControl: CurrentInspectionViewController
    let ItemTag: Int
    var viewControl: UIControl!
    var imageArray: [UIImage]
    let Camera: Bool

    enum InspectionType {
        case YesNo
        case PassFailNA
        case ShortText
    }
    
    init(Item: String, Type: InspectionType, Controller: CurrentInspectionViewController, ItemTag: Int, Camera: Bool)
    {
        self.Item = Item
        self.Type = Type
        self.width = 338
        self.height = 21
        self.Position = CGRect()
        self.delegateControl = Controller
        self.ItemTag = ItemTag
        self.Camera = Camera
        self.imageArray = [UIImage]()
    }
    
    func generateItem(Container: UIScrollView, PreviousItemPosition: CGRect?)
    {
        var HeightPosition: CGFloat? = 0
        
        if PreviousItemPosition != nil
        {
            HeightPosition = PreviousItemPosition?.origin.y
            HeightPosition = HeightPosition! + 50
        }

        
        //create label for item
        var labelItemName = UILabel(frame: CGRectMake(0,HeightPosition!,380,30))
        self.Position = labelItemName.frame
        
        labelItemName.textAlignment = NSTextAlignment.Right
        labelItemName.text = self.Item
        labelItemName.textColor = UIColor.whiteColor()
        labelItemName.font = UIFont(name: labelItemName.font.fontName, size: 22)
        Container.addSubview(labelItemName)
        
        switch self.Type {
            
            case InspectionType.YesNo:
                var checkbox = UISegmentedControl(items: ["Yes","No"])
                checkbox.frame = CGRectMake(390,HeightPosition!,180,30)
                checkbox.tintColor = UIColor.whiteColor()
                checkbox.tag = ItemTag

                self.Position = checkbox.frame
                viewControl = checkbox
                Container.addSubview(checkbox)
            
            case InspectionType.PassFailNA:
                var checkbox = UISegmentedControl(items: ["Pass","Fail","N/A"])
                checkbox.frame = CGRectMake(390,HeightPosition!,180,30)
                checkbox.tintColor = UIColor.whiteColor()
                checkbox.tag = ItemTag
                self.Position = checkbox.frame
                viewControl = checkbox
                Container.addSubview(checkbox)
            
            case InspectionType.ShortText:
                var comments = UITextField(frame: CGRectMake(390,HeightPosition!,180,30))
                comments.delegate=delegateControl
                comments.layer.cornerRadius = 5.0
                comments.layer.borderColor = UIColor.lightGrayColor().CGColor
                comments.layer.borderWidth = 0.5
                comments.tag = ItemTag
                comments.backgroundColor = UIColor.whiteColor()
        
                viewControl = comments
                self.Position = comments.frame
                Container.addSubview(comments)
            
        default : println("no creation avable for that item")
        }
        
        //add camera icon 
        if Camera
        {
            let image = UIImage(named: "camera-50") as UIImage?
            let button   = UIButton.buttonWithType(UIButtonType.System) as UIButton
            button.frame = CGRectMake(590,HeightPosition!,30,30)
            button.setTitle("Camera", forState: UIControlState.Normal)
            button.tag = ItemTag
            button.tintColor = UIColor.whiteColor()
            button.setImage(image, forState: .Normal)
            button.addTarget(delegateControl, action: "openCamera:", forControlEvents: UIControlEvents.TouchUpInside)
            Container.addSubview(button)
            
            let image2 = UIImage(named: "xlarge_icons-50") as UIImage?
            let button2   = UIButton.buttonWithType(UIButtonType.System) as UIButton
            button2.frame = CGRectMake(640,HeightPosition!,30,30)
            button2.setTitle("Camera", forState: UIControlState.Normal)
            button2.tag = ItemTag
            button2.tintColor = UIColor.whiteColor()
            button2.setImage(image2, forState: .Normal)
            button2.addTarget(delegateControl, action: "openGallery:", forControlEvents: UIControlEvents.TouchUpInside)
            Container.addSubview(button2)

        }
    }
    

    
        
}

