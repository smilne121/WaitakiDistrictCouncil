//
//  EmailViewController.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 18/08/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import UIKit
import MessageUI

class EmailViewController: UIViewController, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    
    var consentInspection: ConsentInspection!
    var officeTools: OfficeTools!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showActivityIndicatory(view)
        
        sendEmail(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showActivityIndicatory(uiView: UIView) {
        var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRectMake(0.0, 0.0, 200.0, 200.0);
        actInd.center = uiView.center
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.WhiteLarge
        uiView.addSubview(actInd)
        actInd.startAnimating()
    }
    
     func sendEmail(sender: AnyObject) {

        let genPDF = GeneratePDF(name: "Inspection Report", width: CGFloat(595), height: CGFloat(842), inspection: consentInspection)

        var picker = MFMailComposeViewController()
        picker.mailComposeDelegate = self
        picker.setSubject("Report from " + consentInspection.inspectionName + " inspection for consent: " + consentInspection.consentId)
        picker.setMessageBody("Attached is the result for your inspection", isHTML: true)
        
        //add pdf
        let fileData = NSData(contentsOfURL: NSURL(fileURLWithPath: genPDF.getPDFPath())!)
        picker.addAttachmentData(fileData, mimeType: "application/pdf", fileName: "Inspection Report.pdf")
        if MFMailComposeViewController .canSendMail() == true
        {
       presentViewController(picker, animated: true, completion: nil)
        }
        else
        {
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    // MFMailComposeViewControllerDelegate
    
    // 1
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        dismissViewControllerAnimated(true, completion: nil)
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    // UITextFieldDelegate
    
    // 2
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    // UITextViewDelegate
    
    // 3
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        //body.text = textView.text
        
        if text == "\n" {
            textView.resignFirstResponder()
            
            return false
        }
        
        return true
    }

}
