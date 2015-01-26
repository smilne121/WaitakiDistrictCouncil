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
    var Name: String?
    var InspectionID: String?
    var InspectionItemArray = [InspectionItem]?()
    var ObjectTagArray = [Int]?()
    var BuildingConsentOfficer: String?

    init ()
    {
        ObjectTagArray = [Int]()
    }
    
    func getContentSize(scrollview: UIScrollView) -> CGSize
    {
        var height: CGFloat = 0
        var itemHeight: Int16 = 0
        
        for item in InspectionItemArray!
        {
         if item.Position!.origin.y > height
         {
                height = item.Position!.origin.y
                itemHeight = item.height!
          }
        }
        
        height = height + CGFloat(itemHeight) + CGFloat(50)
        
        var result: CGSize = CGSize(width: scrollview.frame.width, height: height)
        return result
    }
    
    func getNewItemTag() -> Int
    {
            ObjectTagArray!.append(ObjectTagArray!.count)
        var result = ObjectTagArray!.count - 1
        return result
    }
    
    func loadDefaultItems(controller: CurrentInspectionViewController, scrollview: UIScrollView)
    {
        InspectionItemArray!.append(InspectionItem(Item: "Stamped consent plans checked:", Type: InspectionItem.InspectionType.YesNo,Controller: controller, ItemTag: getNewItemTag(), Camera: true))
        InspectionItemArray!.append(InspectionItem(Item: "Any amendments required:", Type: InspectionItem.InspectionType.YesNo,Controller: controller, ItemTag: getNewItemTag(),Camera: true))
        InspectionItemArray!.append(InspectionItem(Item: "Request received in writing for CCC:", Type: InspectionItem.InspectionType.YesNo,Controller: controller, ItemTag: getNewItemTag(),Camera:false))
        InspectionItemArray!.append(InspectionItem(Item: "Inspection records checked:", Type: InspectionItem.InspectionType.YesNo,Controller: controller, ItemTag: getNewItemTag(), Camera: false))
    }
    
    func generateTestData(controller: CurrentInspectionViewController, scrollview: UIScrollView)
    {
        //load test data
        InspectionItemArray!.append(InspectionItem(Item: "Any amendments required:", Type: InspectionItem.InspectionType.YesNo,Controller: controller, ItemTag: getNewItemTag(),Camera:true))
        InspectionItemArray!.append(InspectionItem(Item: "Clean outs/solid fill:", Type: InspectionItem.InspectionType.PassFailNA,Controller: controller,ItemTag: getNewItemTag(),Camera:true))
        InspectionItemArray!.append(InspectionItem(Item: "Comments:", Type: InspectionItem.InspectionType.ShortText,Controller: controller,ItemTag: getNewItemTag(),Camera:true))
       
        for var i = 0 ; i < InspectionItemArray!.count; i++
        {
            if i != 0
            {
                InspectionItemArray![i].generateItem(scrollview, PreviousItemPosition: InspectionItemArray![i - 1].Position)
            }
            else
            {
                InspectionItemArray![i].generateItem(scrollview, PreviousItemPosition: nil)
            }
        }
    }
    
    func loadCommentBox(textField: UITextField, scrollView: UIScrollView,delegateControl: CurrentInspectionViewController) -> UITextView
    {
        //create the view to hold the container to input the box
        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .Light)) as UIVisualEffectView
        visualEffectView.frame = delegateControl.view.bounds
        delegateControl.view.addSubview(visualEffectView)
        
        
        
        
        let popupWidth: CGFloat = 394
        let popupHeight: CGFloat = 308
        let popupX: CGFloat = (delegateControl.view.frame.width / 2) - (popupWidth / 2)
        let popupY: CGFloat = (delegateControl.view.frame.height / 2) - (popupHeight / 2)
        
        var commentPopup = UIView(frame: CGRectMake(popupX,popupY,popupWidth,popupHeight))
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
        delegateControl.view.addSubview(commentPopup)
        commentPopup.addSubview(commentHeader)
        commentPopup.addSubview(commentTextInput)
        commentPopup.addSubview(button)
        
        return commentTextInput
    }
    
    func getItemFromTag (Tag: Int) -> InspectionItem?
    {
        for var i = 0 ; i < InspectionItemArray!.count; i++
        {
            if InspectionItemArray![i].ItemTag == Tag
            {
                    return InspectionItemArray![i]
            }
        }
        return nil
    }

    
    
}
    