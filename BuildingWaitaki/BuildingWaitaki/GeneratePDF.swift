//
//  GeneratePDF.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 17/08/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import UIKit

class GeneratePDF
{
    var pageSize : CGSize
    let consentInspection : ConsentInspection
    
    init (name: String, width:CGFloat,height:CGFloat, inspection : ConsentInspection)
    {
        self.consentInspection = inspection
        pageSize = CGSize(width: width, height: height)
        let newPdfName = name + ".pdf"
        let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! NSString
        let pdfPath = documentsDirectory.stringByAppendingPathComponent(newPdfName)
        println(pdfPath)
        
        UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil)
        
        startDrawing()
        
    }
    
    func startDrawing()
    {
        var currentY = CGFloat(0);
        
        let title = "Site and Footings"
        let dateGenerated = "14 August 2015"
        let consentNumber = "2015.2639"
        let address = "20 Thames Street Oamaru"
        let descriptionOfWork = "Installing a new fire with wetback.Installing a new fire with wetback.Installing a new fire with wetback.Installing a new fire with wetback.Installing a new fire with wetback.Installing a new fire with wetback.Installing a new fire with wetback"
        let inspectionOfficer = "246"
        let inspectionComments = "General comments about this inspection"
        
        let width = 595
        let height = 842
        
        
        
        self.beginPDFPage()
        
        var position = CGRectMake(0,0,0,0)
        
        //create header
        let image  = UIImage(named: "wdc-main-logo-300x80.png") as UIImage!
        self.addImage(image, rect: CGRect(x: 36, y: 36,width: 240,height: 64))
        
        self.addText(title, frame: CGRect(x: pageSize.width - 320, y: 40, width: pageSize.width - 276 - 36, height: 24), fontSize: 20, textAlignment: NSTextAlignment.Center, backgroundColour: UIColor.whiteColor())
        
        position = self.addText("Consent Number: " + consentNumber, frame: CGRect(x: 32, y: 120, width: 200, height: 24), fontSize: 10, textAlignment: NSTextAlignment.Left, backgroundColour: UIColor.whiteColor())
        currentY = position.origin.y
        
        position = self.addText("Address: " + address, frame: CGRect(x: 240, y: currentY, width: 300, height: 48), fontSize: 10, textAlignment: NSTextAlignment.Right, backgroundColour: UIColor.whiteColor())
        currentY = position.origin.y + position.height + 10
        
        position = self.addText("Description: " + descriptionOfWork, frame: CGRect(x: 32, y: currentY, width: 531, height: 48), fontSize: 10, textAlignment: NSTextAlignment.Left, backgroundColour: UIColor.whiteColor())
        
     
        currentY = position.origin.y + position.height + 10
        
        position = self.addText("Comments: " + inspectionComments, frame: CGRect(x: 32, y: currentY, width: 531, height: 48), fontSize: 10, textAlignment: NSTextAlignment.Left, backgroundColour: UIColor.whiteColor())
        
        currentY = position.origin.y + position.height + 10
        
        addLineWithFrame(CGRectMake(CGFloat(0), CGFloat(currentY), pageSize.width, CGFloat(1)), colour: UIColor.grayColor())
        
        currentY = currentY + 1 + 30
    
        position = self.addText("Item" , frame: CGRect(x: 32, y: currentY, width: 100, height: 48), fontSize: 12, textAlignment: NSTextAlignment.Right, backgroundColour: UIColor.lightGrayColor())
        
        self.addText("Result" , frame: CGRect(x: 132, y: currentY, width: CGFloat(pageSize.width - 164), height: 48), fontSize: 12, textAlignment: NSTextAlignment.Left, backgroundColour: UIColor.lightGrayColor())
        currentY = position.origin.y + position.height + 10
        
        var odd = false;
        
        for item:AnyObject in consentInspection.inspectionItem
        {
            var colour = UIColor.whiteColor()
            if odd == true
            {
                colour = UIColor.lightGrayColor()
                odd = false
            }
            else
            {
                colour = UIColor.whiteColor()
                odd = true
            }
            
            let currentItem = item as! ConsentInspectionItem
            position = self.addText(currentItem.itemName , frame: CGRect(x: 32, y: currentY, width: 100, height: 48), fontSize: 10, textAlignment: NSTextAlignment.Right, backgroundColour: colour)
            
            if let result = currentItem.itemResult
            {
            self.addText(result , frame: CGRect(x: 132, y: currentY, width: CGFloat(pageSize.width - 164), height: position.height), fontSize: 10, textAlignment: NSTextAlignment.Left, backgroundColour: colour)
            currentY = position.origin.y + position.height
            }
            else
            {
                self.addText("" , frame: CGRect(x: 132, y: currentY, width: CGFloat(pageSize.width - 164), height: position.height), fontSize: 10, textAlignment: NSTextAlignment.Left, backgroundColour: colour)
                currentY = position.origin.y + position.height
            }
            
        }
        
        
        
        self.finishPDF()
    }
    
    func beginPDFPage ()
    {
        UIGraphicsBeginPDFPageWithInfo(CGRect(x: 0,y: 0, width: pageSize.width, height: pageSize.height), nil)
    }
    
    func finishPDF ()
    {
        UIGraphicsEndPDFContext()
    }
    
    func addText(text: String,var frame: CGRect, fontSize: CGFloat, textAlignment: NSTextAlignment, backgroundColour: UIColor) -> CGRect
    {
        //get height set width here
        let label = UILabel()
        label.text = text
        label.textAlignment = textAlignment
        label.frame = frame
        label.font = UIFont(name: "Arial", size: fontSize)
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        frame = CGRectMake(frame.origin.x, frame.origin.y, frame.width, label.requiredHeight())
        
        
        
        //Add some text to be displayed
        let font = UIFont(name: "Arial", size: fontSize)
        let text: String = text
        let rectText = frame
        let textStyle = NSMutableParagraphStyle.defaultParagraphStyle().mutableCopy() as! NSMutableParagraphStyle
        textStyle.alignment = textAlignment
        textStyle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        let textColor = UIColor.blackColor()
        let textFontAttributes = [
            NSFontAttributeName : font!,
            NSForegroundColorAttributeName: textColor,
            NSParagraphStyleAttributeName: textStyle
        ]

        backgroundColour.setFill()
        UIRectFill(rectText)
        text.drawInRect(rectText, withAttributes: textFontAttributes)

        return rectText
        
        
        
       /* let font =  UIFont.systemFontOfSize(fontSize)
        let constrainedToSize = CGSizeMake(pageSize.width - 2*20-2*20, pageSize.height - 2*20 - 2*20)
        
        let label = UILabel()
        label.text = text
        label.textAlignment = textAlignment
        label.font = UIFont(name: label.font.fontName, size: fontSize)
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        let stringSize = label.sizeThatFits(constrainedToSize)
        
        var textWidth = frame.size.width;
        
        if (textWidth < stringSize.width)
        {
            textWidth = stringSize.width;
        }
        if (textWidth > pageSize.width)
        {
            textWidth = pageSize.width - frame.origin.x;
        }
        
        /*let renderingRect = CGRectMake(frame.origin.x, frame.origin.y + 300, textWidth, stringSize.height)
        label.drawTextInRect(renderingRect)*/
        
       // frame = CGRectMake(frame.origin.x, frame.origin.y, stringSize.width, stringSize.height);
        
        /*return frame*/
        
        //  let imageFrame = CGRectMake(point.x,point.y,image.size.width,image.size.height)
        label.drawTextInRect(frame)
        return frame*/
    }
    
    func addLineWithFrame(frame: CGRect, colour: UIColor) -> CGRect
    {
        let currentContext = UIGraphicsGetCurrentContext()
        CGContextSetStrokeColorWithColor(currentContext, colour.CGColor)
        CGContextSetLineWidth(currentContext, frame.size.height)
        
        let startPoint = frame.origin
        let endPoint = CGPointMake(frame.origin.x + frame.size.width, frame.origin.y)
        
        CGContextBeginPath(currentContext);
        CGContextMoveToPoint(currentContext, startPoint.x, startPoint.y);
        CGContextAddLineToPoint(currentContext, endPoint.x, endPoint.y);
        
        CGContextClosePath(currentContext);
        CGContextDrawPath(currentContext, kCGPathFillStroke);
        
        return frame
    }
    
    func addImage(image: UIImage, rect: CGRect) -> CGRect
    {
      //  let imageFrame = CGRectMake(point.x,point.y,image.size.width,image.size.height)
        image.drawInRect(rect)
        return rect
    }
    
    
    
    
}

extension UILabel{
    
    func requiredHeight() -> CGFloat{
        
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, self.frame.width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = self.font
        label.text = self.text
        
        label.sizeToFit()
        
        return label.frame.height
    }
}


