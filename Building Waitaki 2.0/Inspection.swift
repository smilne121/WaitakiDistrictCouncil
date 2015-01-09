//
//  Inspection.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 6/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import UIKit

class Inspection {
    var Name: String
    var InspectionItemArray = [InspectionItem]()
    var ObjectTagArray = [Int]()

    init (Name: String)//, InspectionItemArray: [InspectionItem]?)
    {
        self.Name = Name
    }
    
    func generateTestData(controller: CurrentInspectionViewController, scrollview: UIScrollView)
    {
        //load test data
        InspectionItemArray.append(InspectionItem(Item: "Any amendments required:", Type: InspectionItem.InspectionType.YesNo,Controller: controller, ItemTag: 1))
        InspectionItemArray.append(InspectionItem(Item: "Clean outs/solid fill:", Type: InspectionItem.InspectionType.PassFailNA,Controller: controller,ItemTag: 2))
        InspectionItemArray.append(InspectionItem(Item: "Comments:", Type: InspectionItem.InspectionType.ShortText,Controller: controller,ItemTag: 3))
       
        for var i = 0 ; i < InspectionItemArray.count; i++
        {
            if i != 0
            {
                InspectionItemArray[i].generateItem(scrollview, PreviousItemPosition: InspectionItemArray[i - 1].Position )
            }
            else
            {
                InspectionItemArray[i].generateItem(scrollview, PreviousItemPosition: nil)
            }
        }
    }
    
    func loadCommentBox(textField: UITextField, scrollView: UIScrollView,delegateControl: CurrentInspectionViewController) -> UITextView
    {
        //create the view to hold the container to input the box
        //var newUIView = UIView(frame: UIScreen.mainScreen().bounds)
        //var blur = UIBlurEffect(style: UIBlurEffectStyle.ExtraLight)
        var commentPopup = UIView(frame: CGRectMake(15,152,394,308))
        var commentHeader = UILabel(frame: CGRectMake(8,8,378,33))
        var commentTextInput = UITextView(frame: CGRectMake(16,40,362,228))
        
        //create save button
        let button   = UIButton.buttonWithType(UIButtonType.System) as UIButton
        button.frame = CGRectMake(174,270,46,30)
        button.setTitle("Save", forState: UIControlState.Normal)
        button.addTarget(delegateControl, action: "saveComment:", forControlEvents: UIControlEvents.TouchUpInside)
            
        //setup view container
        commentPopup.backgroundColor = UIColor.whiteColor()
        commentPopup.tag = Int.max
        commentPopup.layer.cornerRadius = 5.0
        commentPopup.layer.borderWidth = 1
        commentPopup.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        //setup header
        commentHeader.text = "Insert Comment"
        commentHeader.font = UIFont(name: commentHeader.font.fontName, size: 27)
        
        
        //setup text input
        commentTextInput.text = textField.text
        commentTextInput.delegate = delegateControl
        commentTextInput.font = UIFont(name: commentHeader.font.fontName, size: 22)
        commentTextInput.editable = true
        commentTextInput.layer.cornerRadius = 5.0
        commentTextInput.layer.borderWidth = 1
        commentTextInput.layer.borderColor = UIColor.lightGrayColor().CGColor
        
        
         //write out to screen
        scrollView.addSubview(commentPopup)
        commentPopup.addSubview(commentHeader)
        commentPopup.addSubview(commentTextInput)
        commentPopup.addSubview(button)
        
        return commentTextInput
    }
    
    func getItemFromTag (Tag: Int) -> InspectionItem?
    {
        for var i = 0 ; i < InspectionItemArray.count; i++
        {
            if InspectionItemArray[i].ItemTag == Tag
            {
                    return InspectionItemArray[i]
            }
        }
        return nil
    }

    
    
}
    