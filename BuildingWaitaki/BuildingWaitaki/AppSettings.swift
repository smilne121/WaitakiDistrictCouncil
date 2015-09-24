//
//  AppSettings.swift
//  BuildingWaitaki
// http://www.codingexplorer.com/nsuserdefaults-a-swift-introduction/ examples on using defaults and how to use found here
//  Created by Scott Milne on 28/05/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import UIKit

//Handles the saving and loading of the application defaults

 class AppSettings{
    let defaults = NSUserDefaults.standardUserDefaults()
    
    func setUser(user: String)
    {
        defaults.setObject(user, forKey: "User")
    }
    
    func setAPIServer(APIServer: String)
    {
        defaults.setObject(APIServer, forKey: "APIServer")
    }
    
    func setTheme(Theme: String)
    {
        defaults.setObject(Theme, forKey: "Theme")
    }
    
    func getTheme() -> String?
    {
        if let theme = defaults.stringForKey("Theme")
        {
            return theme
        }
        else
        {
            return "light"
        }
    }
    
    func getUser() -> String?
    {
        if let user = defaults.stringForKey("User")
        {
        return user
        }
        else
        {
            return ""
        }
    }
    
    func getAPIServer() -> String?
    {
        if let APIServer =  defaults.stringForKey("APIServer")
        {
            return APIServer
        }
        else
        {
            return ""
        }
    }
    
    func getBlurEffect(frame: CGRect) -> UIVisualEffectView
    {
        let blur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        let blurView = UIVisualEffectView(effect: blur)
        blurView.frame = frame
        
        return blurView
    }
    
    func getBackgroundColour() -> UIColor
    {
        if (self.getTheme() == "dark")
        {
            return UIColor(red: 51/255.0, green: 51/255.0, blue: 51/255.0, alpha: 0.8)
        }
        else
        {
            return UIColor(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 0.8)
        }
    }
    
    func getPopupStyle(popup: UIAlertController) -> UIAlertController
    {

        for view in popup.view.subviews
        {
            if view.isKindOfClass(UIView)
            {
                (view ).backgroundColor = self.getBackgroundColour()
                (view ).tintColor = self.getTintColour()
                for subview in view.subviews
                {
                    if subview.isKindOfClass(UIView)
                    {
                        (subview ).backgroundColor = self.getBackgroundColour()
                        (subview ).tintColor = self.getTintColour()
                    }
                }
            }
            else if view.isKindOfClass(UIButton)
            {
                (view as! UIButton).tintColor = self.getTintColour()
                (view as! UIButton).titleLabel?.font = AppSettings().getTextFont()
            }
        }
        return popup
    }
    
    func getBackgroundImage() -> UIImage
    {
        return UIImage(named: "blur-background10.jpg") as UIImage!
    }
    func getTintColour() -> UIColor
    {
        if (self.getTheme() == "dark")
        {
            return UIColor.yellowColor()
        }
        else
        {
            return UIColor(red: 15/255, green: 15/255, blue: 15/255, alpha: 1.0)
        }
    }
    func getTextColour() -> UIColor
    {
        if (self.getTheme() == "dark")
        {
        return UIColor.whiteColor()
        }
        else
        {
            return UIColor.blackColor()
        }
    }
    
    func getContainerBackground() -> UIColor
    {
        if (self.getTheme() == "dark")
        {
            return UIColor(red: 0.0/255, green: 0.0/255, blue: 0.0/255, alpha: 0.8)
        }
        else
        {
            return UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 0.8)
        }
        
    }
    
    func getViewBackground() -> UIColor
    {
        if (self.getTheme() == "dark")
        {
            return UIColor(patternImage: UIImage(named: "background.png")!)
        }
        else
        {
            return UIColor(patternImage: UIImage(named: "light-background.png")!)
        }
    }
    
    func getTitleFont() -> UIFont
    {
        return UIFont(name: "HelveticaNeue-Medium", size: 20)!
    }
    
    func getHeadingFont() -> UIFont
    {
        return UIFont (name: "HelveticaNeue-Medium", size: 20)!
    }
    
    func getTextFont() -> UIFont
    {
        return UIFont (name: "HelveticaNeue-Medium", size: 16)!
    }
    
}
