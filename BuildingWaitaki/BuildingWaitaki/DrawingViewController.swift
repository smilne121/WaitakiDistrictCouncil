//
//  DrawingViewController.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 21/08/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import UIKit
import CoreData

class DrawingViewController: UIViewController, PhotoCompletionDelegate{
    
    var lastPoint = CGPoint.zeroPoint
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 10.0
    var opacity: CGFloat = 1.0
    var swiped = false
    var managedContext: NSManagedObjectContext!
    var imageToEdit: UIImage!
    var inspectionItem: ConsentInspectionItem!
    var localIdentifier: String!
    var arrayUIImageViews: [UIImageView]?
    
    let colors: [(CGFloat, CGFloat, CGFloat)] = [
        (0, 0, 0),
        (105.0 / 255.0, 105.0 / 255.0, 105.0 / 255.0),
        (1.0, 0, 0),
        (0, 0, 1.0),
        (51.0 / 255.0, 204.0 / 255.0, 1.0),
        (102.0 / 255.0, 204.0 / 255.0, 0),
        (102.0 / 255.0, 1.0, 0),
        (160.0 / 255.0, 82.0 / 255.0, 45.0 / 255.0),
        (1.0, 102.0 / 255.0, 0),
        (1.0, 1.0, 0),
        (1.0, 1.0, 1.0),
    ]


    @IBOutlet weak var mainImageView: UIImageView!
   // @IBOutlet weak var tempImageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        arrayUIImageViews = [UIImageView]()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func reset(sender: UIButton) {
        
        mainImageView.image = imageToEdit

         arrayUIImageViews!.removeAll(keepCapacity: false)
    
        for view in sender.superview!.subviews
        {
            if view.tag > 0
            {
                if view.isKindOfClass(UIImageView)
                {
                    view.removeFromSuperview()
                }
            }
        }
    }
    
    @IBAction func share(sender: AnyObject) {
        UIGraphicsBeginImageContext(mainImageView.bounds.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0,
            width: mainImageView.frame.size.width, height: mainImageView.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        presentViewController(activity, animated: true, completion: nil)
    }
    
    @IBAction func pencilPressed(sender: AnyObject) {
        
        var index = sender.tag ?? 0
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        (red, green, blue) = colors[index]
        
        if index == colors.count - 1 {
            opacity = 1.0
        }
    }
    @IBAction func brushSizeChanged(sender: UISlider) {
        brushWidth = CGFloat(sender.value)
    }
   
    
    @IBAction func eraseLastMove(sender: UIButton) {
        if arrayUIImageViews!.count > 0
        {
            let lastId = arrayUIImageViews!.count - 1
            arrayUIImageViews?.removeAtIndex(lastId)
            for view in sender.superview!.subviews
            {
                if view.tag == lastId + 1
                {
                    if view.isKindOfClass(UIImageView)
                    {
                        view.removeFromSuperview()
                    }
                }
            }
        }
    }
    
    @IBAction func save(sender : UIButton)
    {
        // Merge tempImageView into mainImageView
        for tempImageView in arrayUIImageViews!
        {
        UIGraphicsBeginImageContext(mainImageView.frame.size)
        mainImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: opacity)
        mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        tempImageView.image = nil
        }
        
        arrayUIImageViews?.removeAll(keepCapacity: false)
        for view in self.view!.subviews
        {
            if view.tag > 0
            {
                if view.isKindOfClass(UIImageView)
                {
                    view.removeFromSuperview()
                }
            }
        }
        
        
        //saveToCoreDataAndPhotoRoll

        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //clone size of main image view
        var tempImageView = UIImageView(frame: mainImageView.frame)
        arrayUIImageViews!.append(tempImageView)
        tempImageView.tag = (arrayUIImageViews!.count)
        view.addSubview(tempImageView)

        
        swiped = false
        if let touch = touches.first as? UITouch {
            lastPoint = touch.locationInView(self.view)
        }
    }
    
    func photoSaveCompleted(identifier: String, image : UIImage)
    {
        let data = UIImageJPEGRepresentation(image as UIImage, 1)
        let encodedImage = data.base64EncodedStringWithOptions(.allZeros)
        
        // add photo details to database
        let currentImage = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: managedContext) as! Photo
        currentImage.consentNumber = inspectionItem.consentId
        currentImage.inspectionName = inspectionItem.inspectionName
        currentImage.itemId = inspectionItem.itemId
        currentImage.consentInspectionItem = inspectionItem
        currentImage.encodedString = encodedImage
        currentImage.dateTaken = NSDate()
        currentImage.photoIdentifier = identifier
        managedContext.save(nil)
        
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        
       let id = arrayUIImageViews!.count - 1
        var tempImageView = arrayUIImageViews![id]
        
        UIGraphicsBeginImageContext(view.frame.size)
        let context = UIGraphicsGetCurrentContext()
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height))
        
        // 2
        CGContextMoveToPoint(context, fromPoint.x, fromPoint.y)
        CGContextAddLineToPoint(context, toPoint.x, toPoint.y)
        
        // 3
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetLineWidth(context, brushWidth)
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextSetBlendMode(context, kCGBlendModeNormal)
        
        // 4
        CGContextStrokePath(context)
        
        // 5
        tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        tempImageView.alpha = opacity
        UIGraphicsEndImageContext()
        
        arrayUIImageViews![id] = tempImageView
        
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        // 6
        swiped = true
        if let touch = touches.first as? UITouch {
            let currentPoint = touch.locationInView(view)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        
    }
    
    func loadImages()
    {
        
    }
    func photoLoaded(image: UIImage, imageIdentity: String)
    {
        
    }
}

