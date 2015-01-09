//
//  CurrentInspectionViewController.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 9/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import UIKit
import AVFoundation

class CurrentInspectionViewController: UIViewController, UITextFieldDelegate,UITextViewDelegate {
    @IBOutlet weak var InspectionScrollView: UIScrollView!
    var currentInspection: Inspection!
    var currentInspectionItem: InspectionItem!
    var commentPopup: UIView!
    var commentBox: UITextView!
    let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Create test inspection
        if InspectionScrollView != nil
        {
            currentInspection = Inspection(Name: "Test Inspection")
            currentInspection.loadDefaultItems(self, scrollview: InspectionScrollView)
            currentInspection.loadDefaultItems(self, scrollview: InspectionScrollView)
            currentInspection.loadDefaultItems(self, scrollview: InspectionScrollView)
            currentInspection.loadDefaultItems(self, scrollview: InspectionScrollView)
            currentInspection.loadDefaultItems(self, scrollview: InspectionScrollView)
            currentInspection.generateTestData(self, scrollview: InspectionScrollView)
        }
        
        //update the scrollview size
        InspectionScrollView.contentSize = currentInspection.getContentSize(InspectionScrollView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Button Methods
    func saveComment(sender:UIButton!)
    {
        //update the textfield
        var textfield = currentInspectionItem.viewControl as UITextField
        textfield.text = commentBox.text
        
        //remove from view
        for view in  self.view.subviews
        {
            if let obj = view as? UIVisualEffectView
            {
                view.removeFromSuperview()
            }
            if view.tag == Int.max
            {
                for subview in  view.subviews
                {
                    subview.removeFromSuperview()
                }
                view.removeFromSuperview()
            }
        }
        
    }
    
    func openCamera(sender:UIButton!)
    {
        println(" Open camera")
    }
    
    
    //Delegate Methods
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool
    {
        println("I'm here")
        currentInspectionItem = currentInspection.getItemFromTag(textField.tag)
        commentBox = currentInspection.loadCommentBox(textField, scrollView: InspectionScrollView, delegateControl: self)
        
        return false
    }
    
    func textViewDidChange(textView: UITextView!)
    {
        //  println("i changed")
    }
    
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool
    {
        //limit the textbox to 255 chars
        return countElements(textView.text) + (countElements(text) - range.length) <= 255
    }
}

