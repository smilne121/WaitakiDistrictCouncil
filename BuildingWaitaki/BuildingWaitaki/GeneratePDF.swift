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
    var totalPages: Int
    let consentInspection : ConsentInspection
    var pdfPath: String
    
    init (name: String, width:CGFloat,height:CGFloat, inspection : ConsentInspection)
    {
        totalPages = 0
        self.consentInspection = inspection
        pageSize = CGSize(width: width, height: height)
        let newPdfName = name + ".pdf"
       // let paths = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentationDirectory, NSSearchPathDomainMask.UserDomainMask, true)
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString
        pdfPath = documentsDirectory.stringByAppendingPathComponent(newPdfName)
        
        startDrawing(pdfPath)
        
    }
    
    func getPDFPath() -> String
    {
        return pdfPath
    }
    
    func startDrawing(pdfPath: String)
    {
        for i in 0 ..< 2
        {
             UIGraphicsBeginPDFContextToFile(pdfPath, CGRectZero, nil)
            
            var currentPage = 0;
        var currentY = CGFloat(0);
        
        let title = consentInspection.inspectionName
        let consentNumber = consentInspection.consent.consentNumber
        let address = consentInspection.consent.consentAddress
        let descriptionOfWork = consentInspection.consent.consentDescription
        
      //  let  width = 595
      //  let height = 842
        
        
        
        self.beginPDFPage()
            currentPage = currentPage + 1
        if i == 0
        {
            totalPages = totalPages + 1
            }
            
        var position = CGRectMake(0,0,0,0)
        
        //create header
        let image  = UIImage(named: "wdc-main-logo-300x80.png") as UIImage!
        self.addImage(image, rect: CGRect(x: 36, y: 36,width: 240,height: 64))
            
            
       
        
        self.addText(title, frame: CGRect(x: pageSize.width - 320, y: 40, width: pageSize.width - 276 - 36, height: 24), fontSize: 20, textAlignment: NSTextAlignment.Center, backgroundColour: UIColor.whiteColor(),fixedHeight:false)
        
        position = self.addText("Consent Number: " + consentNumber, frame: CGRect(x: 32, y: 120, width: 200, height: 24), fontSize: 10, textAlignment: NSTextAlignment.Left, backgroundColour: UIColor.whiteColor(),fixedHeight:false)
        currentY = position.origin.y
        
        position = self.addText("Address: " + address, frame: CGRect(x: 240, y: currentY, width: 300, height: 48), fontSize: 10, textAlignment: NSTextAlignment.Right, backgroundColour: UIColor.whiteColor(),fixedHeight:false)
        currentY = position.origin.y + position.height + 10
        
        position = self.addText("Description: " + descriptionOfWork, frame: CGRect(x: 32, y: currentY, width: 531, height: 48), fontSize: 10, textAlignment: NSTextAlignment.Left, backgroundColour: UIColor.whiteColor(),fixedHeight:false)
        
     
        currentY = position.origin.y + position.height + 10
        
        addLineWithFrame(CGRectMake(CGFloat(0), CGFloat(currentY), pageSize.width, CGFloat(1)), colour: UIColor.grayColor())
        
        currentY = currentY + 1 + 30
    
        position = self.addText("Item" , frame: CGRect(x: 32, y: currentY, width: 150, height: 48), fontSize: 12, textAlignment: NSTextAlignment.Left, backgroundColour: UIColor.lightGrayColor(),fixedHeight:false)
        
        self.addText("Result" , frame: CGRect(x: 182, y: currentY, width: 150, height: 48), fontSize: 12, textAlignment: NSTextAlignment.Left, backgroundColour: UIColor.lightGrayColor(),fixedHeight:false)
        //currentY = position.origin.y + position.height + 10
        
        self.addText("Comments" , frame: CGRect(x: 332, y: currentY, width: pageSize.width - 332 - 32, height: 48), fontSize: 12, textAlignment: NSTextAlignment.Left, backgroundColour: UIColor.lightGrayColor(),fixedHeight:false)
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
            
            var text3 = " "
            if let myText = currentItem.itemComment
            {
                text3 = myText
            }
            
            var itemHeight = CGFloat(0)
            if let result = currentItem.itemResult
            {
                let myHeight = getTableRowHeight(currentItem.itemName, text2: result, text3: text3, frame1: CGRect(x: 32, y: currentY, width: 150, height: 48), frame2:CGRect(x: 182, y: currentY, width: 150, height: 48),frame3: CGRect(x: 332, y: currentY, width: pageSize.width - 332 - 32, height: 48), fontSize: 10)
                
                itemHeight = myHeight
            }
            else
            {
                let myHeight = getTableRowHeight(currentItem.itemName, text2: " ", text3: text3, frame1: CGRect(x: 32, y: currentY, width: 150, height: 48), frame2:CGRect(x: 182, y: currentY, width: 150, height: 48), frame3:CGRect(x: 332, y: currentY, width: pageSize.width - 332 - 32, height: 48), fontSize: 10)
                
                itemHeight = myHeight
            }
            
            //add item name
            //check y postion to page
            if (currentY + itemHeight) > (pageSize.height - 32)
            {
                beginPDFPage()
                currentPage = currentPage + 1
                if i == 0
                {
                    totalPages = totalPages + 1
                }
                currentY = 32
            }
            
            
            
            
            var result = " "
            if let myresult = currentItem.itemResult
            {
                result = myresult
            }
            
            position =  self.addText(currentItem.itemName , frame: CGRect(x: 32, y: currentY, width: 150, height: itemHeight), fontSize: 10, textAlignment: NSTextAlignment.Left, backgroundColour: colour,fixedHeight:true)
            

            self.addText(result , frame: CGRect(x: 182, y: currentY, width: 150, height: itemHeight), fontSize: 10, textAlignment: NSTextAlignment.Left, backgroundColour: colour,fixedHeight:true)
                
                
            self.addText(text3, frame: CGRect(x: 332, y: currentY, width: pageSize.width - 332 - 32, height: itemHeight), fontSize: 10, textAlignment: NSTextAlignment.Left, backgroundColour: colour, fixedHeight: true)
            
            
            //currentY = position.origin.y + position.height
            currentY = currentY + itemHeight
            
            
            
            let pageNumberText = String(currentPage) + " of " + String(totalPages)
            self.addText(pageNumberText, frame: CGRect(x: 32, y: pageSize.height - 30, width: pageSize.width, height: 24), fontSize: 8, textAlignment: NSTextAlignment.Left, backgroundColour: UIColor.whiteColor(), fixedHeight: false)
            
            
            
            
            
            
            
            }
            
            let imageWidth = CGFloat(163)
            let imageHeight = CGFloat(217)
            
            currentY = currentY + 20
            var curX = CGFloat(32)
            for inspectionItem in consentInspection.inspectionItem
            {
                let item = inspectionItem as! ConsentInspectionItem
                for photo in item.photo
                {
                    if curX + imageWidth > (pageSize.width - 32 + 3)
                    {
                        curX = 32
                        currentY = currentY + imageHeight + 20
                        if currentY + imageHeight > (pageSize.height - 64)
                        {
                            beginPDFPage()
                            currentPage = currentPage + 1
                            if i == 0
                            {
                                totalPages = totalPages + 1
                            }
                            
                            currentY = 32;
                        }
                    }

                    let image = photo as! Photo
                  //  let photoHandler = PhotoHandler()
                    
                    let imageData = NSData(base64EncodedString: image.encodedString, options: [])
                    let imageDecoded = UIImage(data: imageData!)
                    self.addImage(imageDecoded!, rect: CGRect(x: curX,y: currentY, width: imageWidth,height: imageHeight))
                    curX = curX + imageWidth + 20
                    let pageNumberText = String(currentPage) + " of " + String(totalPages)
                    self.addText(pageNumberText, frame: CGRect(x: 32, y: pageSize.height - 30, width: pageSize.width, height: 24), fontSize: 8, textAlignment: NSTextAlignment.Left, backgroundColour: UIColor.whiteColor(), fixedHeight: false)
                                    }
                
                
            }
        
           
        
        
        self.finishPDF()
        }
    }
    
    func beginPDFPage ()
    {
        UIGraphicsBeginPDFPageWithInfo(CGRect(x: 0,y: 0, width: pageSize.width, height: pageSize.height), nil)
    }
    
    func finishPDF ()
    {
        UIGraphicsEndPDFContext()
    }
    
    func addText(text: String, frame: CGRect, fontSize: CGFloat, textAlignment: NSTextAlignment, backgroundColour: UIColor, fixedHeight:Bool) -> CGRect
    {
        var myFrame = frame;
        
        if fixedHeight != true
        {
            //get height set width here
            let label = UILabel()
            label.text = text
            label.textAlignment = textAlignment
            label.frame = myFrame
            label.font = UIFont(name: "Arial", size: fontSize)
            label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
            myFrame = CGRectMake(myFrame.origin.x, myFrame.origin.y, myFrame.width, label.requiredHeight())
        }
        
        
        
        //Add some text to be displayed
        let font = UIFont(name: "Arial", size: fontSize)
        let text: String = text
        let rectText = myFrame
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
    }
    
    func getTableRowHeight(text: String,text2:String,text3:String,frame1: CGRect,frame2: CGRect,frame3: CGRect, fontSize: CGFloat) -> CGFloat
    {
        //get height set width here
        let label1 = UILabel()
        label1.text = text
        label1.textAlignment = NSTextAlignment.Left
        label1.frame = frame1
        label1.font = UIFont(name: "Arial", size: fontSize)
        label1.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        let label2 = UILabel()
        label2.text = text2
        label2.textAlignment = NSTextAlignment.Left
        label2.frame = frame2
        label2.font = UIFont(name: "Arial", size: fontSize)
        label2.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        let label3 = UILabel()
        label3.text = text3
        label3.textAlignment = NSTextAlignment.Left
        label3.frame = frame3
        label3.font = UIFont(name: "Arial", size: fontSize)
        label3.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        
        
        if label1.requiredHeight() > label2.requiredHeight()
        {
            if label1.requiredHeight() > label3.requiredHeight()
            {
                return label1.requiredHeight()
            }
            else
            {
                return label3.requiredHeight()
            }
            
        }
        else
        {
            if label2.requiredHeight() > label3.requiredHeight()
            {
            return label2.requiredHeight()
            }
            else
            {
                return label3.requiredHeight()
            }
        }
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
        CGContextDrawPath(currentContext, CGPathDrawingMode.FillStroke);
        
        return frame
    }
    
    func addImage(image: UIImage, rect: CGRect) -> CGRect
    {
        let newImage : UIImage = UIImage(data: image.lowQualityJPEGNSData)!
        newImage.drawInRect(rect)
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

extension UIImage {
    var uncompressedPNGData: NSData      { return UIImagePNGRepresentation(self)!        }
    var highestQualityJPEGNSData: NSData { return UIImageJPEGRepresentation(self, 1.0)!  }
    var highQualityJPEGNSData: NSData    { return UIImageJPEGRepresentation(self, 0.75)! }
    var mediumQualityJPEGNSData: NSData  { return UIImageJPEGRepresentation(self, 0.5)!  }
    var lowQualityJPEGNSData: NSData     { return UIImageJPEGRepresentation(self, 0.25)! }
    var lowestQualityJPEGNSData:NSData   { return UIImageJPEGRepresentation(self, 0.0)!  }
}


