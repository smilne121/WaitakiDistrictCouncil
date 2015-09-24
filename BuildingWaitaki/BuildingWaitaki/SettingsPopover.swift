//
//  SettingsPopover.swift
//  BuildingWaitaki
// https://www.shinobicontrols.com/blog/posts/2014/08/26/ios8-day-by-day-day-21-alerts-and-popovers examples and advice from here
//  Created by Scott Milne on 28/05/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import UIKit

class SettingPopover{
    var text: UITextField?
    var field: String!
    let appSettings = AppSettings()
    
    func showPopover (sender:UIButton, controller:UIViewController) {
        field = sender.titleLabel!.text!
    
        var popup = UIAlertController(title: sender.titleLabel?.text,
            message: "",
            preferredStyle: .Alert)
        
        let settings = AppSettings()
     
        popup.addAction(UIAlertAction(title: "Cancel",
            style: .Cancel,
            handler: ClosePopup))
        
        popup.addAction(UIAlertAction(title: "Save",
            style: .Default,
            handler: SaveSetting))
    
        popup.addTextFieldWithConfigurationHandler(SaveText)
popup = settings.getPopupStyle(popup)
    
        controller.presentViewController(popup, animated: true, completion: nil)
    }
    
    //used to save from the alert box
    private func SaveText(textfield: UITextField!)
    {
        textfield.keyboardAppearance = .Dark
        switch field!{
        case "Set API Server":
            textfield.text = appSettings.getAPIServer()
        case "Set User":
            textfield.text = appSettings.getUser()
        default:
            textfield.placeholder = "Please enter value"
        }
        text = textfield
    }
    private func SaveSetting(alert: UIAlertAction!){
        switch field!{
            case "Set API Server":
            appSettings.setAPIServer(text!.text!)
            case "Set User":
            appSettings.setUser(text!.text!)
        default:
            print("no value found")
        }
    }
    
    private func ClosePopup(alert: UIAlertAction!){
    }
}



