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
    
    var mainImageView: UIImageView?
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
    let scale = UIScreen.mainScreen().scale
    
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



    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit image"
        self.navigationController!.interactivePopGestureRecognizer.enabled = false
        
        // Do any additional setup after loading the view, typically from a nib.
        mainImageView = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(768), height: CGFloat(1024)))
        mainImageView!.image = imageToEdit
        self.view.addSubview(mainImageView!)
        arrayUIImageViews = [UIImageView]()
        
        //order and buttons
        let grnBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        grnBtn.frame = CGRectMake(24, 894, 60, 30)
        grnBtn.setTitle("Green", forState: UIControlState.Normal)
        grnBtn.tintColor = UIColor.greenColor()
        grnBtn.titleLabel!.font = AppSettings().getTextFont()
        grnBtn.layer.backgroundColor = AppSettings().getBackgroundColour().CGColor
        grnBtn.addTarget(self, action: "pencilPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        grnBtn.tag = 6
        grnBtn.layer.cornerRadius = 5.0
        grnBtn.layer.borderWidth = 2
        grnBtn.layer.borderColor = AppSettings().getTintColour().CGColor
        grnBtn.layer.zPosition = 1000
        self.view.addSubview(grnBtn)
        
        //order and buttons
        let redBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        redBtn.frame = CGRectMake(24, 856, 60, 30)
        redBtn.setTitle("Red", forState: UIControlState.Normal)
        redBtn.tintColor = UIColor(red: 235/255.0, green: 5/255.0, blue: 5/255.0, alpha: 1.0)
        redBtn.addTarget(self, action: "pencilPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        redBtn.layer.zPosition = 1000
        redBtn.layer.cornerRadius = 5.0
        redBtn.layer.borderWidth = 2
        redBtn.layer.borderColor = AppSettings().getTintColour().CGColor
        redBtn.tag = 2
        redBtn.titleLabel!.font = AppSettings().getTextFont()
        redBtn.layer.backgroundColor = AppSettings().getBackgroundColour().CGColor
        self.view.addSubview(redBtn)
        //order and buttons
        let blueBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        blueBtn.frame = CGRectMake(24, 932, 60, 30)
        blueBtn.setTitle("Blue", forState: UIControlState.Normal)
        blueBtn.tintColor = UIColor.blueColor()
        blueBtn.addTarget(self, action: "pencilPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        blueBtn.layer.zPosition = 1000
        blueBtn.titleLabel!.font = AppSettings().getTextFont()
        blueBtn.layer.cornerRadius = 5.0
        blueBtn.layer.borderWidth = 2
        blueBtn.layer.borderColor = AppSettings().getTintColour().CGColor
        blueBtn.layer.backgroundColor = AppSettings().getBackgroundColour().CGColor
        blueBtn.tag = 3
        self.view.addSubview(blueBtn)
        //order and buttons
        let blackBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        blackBtn.frame = CGRectMake(24, 970, 60, 30)
        blackBtn.setTitle("Black", forState: UIControlState.Normal)
        blackBtn.titleLabel!.font = AppSettings().getTextFont()
        blackBtn.tintColor = UIColor.blackColor()
        blackBtn.layer.cornerRadius = 5.0
        blackBtn.layer.borderWidth = 2
        blackBtn.layer.borderColor = AppSettings().getTintColour().CGColor
        blackBtn.layer.backgroundColor = AppSettings().getBackgroundColour().CGColor
        blackBtn.addTarget(self, action: "pencilPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        blackBtn.tag = 0
        blackBtn.layer.zPosition = 1000
        self.view.addSubview(blackBtn)
        
        //order and buttons
        let eraseBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        eraseBtn.frame = CGRectMake(706, 856, 60, 30)
        eraseBtn.setTitle("Erase", forState: UIControlState.Normal)
        eraseBtn.tintColor = AppSettings().getTintColour()
        eraseBtn.titleLabel!.font = AppSettings().getTextFont()
        eraseBtn.layer.cornerRadius = 5.0
        eraseBtn.layer.borderWidth = 2
        eraseBtn.layer.borderColor = AppSettings().getTintColour().CGColor
        eraseBtn.layer.backgroundColor = AppSettings().getBackgroundColour().CGColor
        eraseBtn.addTarget(self, action: "eraseLastMove:", forControlEvents: UIControlEvents.TouchUpInside)
        eraseBtn.layer.zPosition = 1000
        self.view.addSubview(eraseBtn)
        
        
        //order and buttons
        let resetBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        resetBtn.frame = CGRectMake(706, 894, 60, 30)
        resetBtn.setTitle("Reset", forState: UIControlState.Normal)
        resetBtn.tintColor = AppSettings().getTintColour()
        resetBtn.titleLabel!.font = AppSettings().getTextFont()
        resetBtn.layer.backgroundColor = AppSettings().getBackgroundColour().CGColor
        resetBtn.layer.cornerRadius = 5.0
        resetBtn.layer.borderWidth = 2
        resetBtn.layer.borderColor = AppSettings().getTintColour().CGColor
        resetBtn.addTarget(self, action: "reset:", forControlEvents: UIControlEvents.TouchUpInside)
        resetBtn.layer.zPosition = 1000
        self.view.addSubview(resetBtn)
        
        //order and buttons
        let saveBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        saveBtn.frame = CGRectMake(706, 932, 60, 30)
        saveBtn.setTitle("Save", forState: UIControlState.Normal)
        saveBtn.tintColor = AppSettings().getTintColour()
        saveBtn.titleLabel!.font = AppSettings().getTextFont()
        saveBtn.layer.cornerRadius = 5.0
        saveBtn.layer.borderWidth = 2
        saveBtn.layer.borderColor = AppSettings().getTintColour().CGColor
        saveBtn.layer.backgroundColor = AppSettings().getBackgroundColour().CGColor
        saveBtn.addTarget(self, action: "save:", forControlEvents: UIControlEvents.TouchUpInside)
        saveBtn.layer.zPosition = 1000
        self.view.addSubview(saveBtn)
        
        //order and buttons
        let cancelBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        cancelBtn.frame = CGRectMake(706, 970, 60, 30)
        cancelBtn.setTitle("Cancel", forState: UIControlState.Normal)
        cancelBtn.tintColor = AppSettings().getTintColour()
        cancelBtn.layer.cornerRadius = 5.0
        cancelBtn.layer.borderWidth = 2
        cancelBtn.layer.borderColor = AppSettings().getTintColour().CGColor
        cancelBtn.titleLabel!.font = AppSettings().getTextFont()
        cancelBtn.layer.backgroundColor = AppSettings().getBackgroundColour().CGColor
        cancelBtn.addTarget(self, action: "cancel:", forControlEvents: UIControlEvents.TouchUpInside)
        cancelBtn.layer.zPosition = 1000
        self.view.addSubview(cancelBtn)
        
        let slider = UISlider(frame: CGRect(x: 157, y: 970, width: 445, height: 32))
        
        slider.minimumValue = 1
        slider.tintColor = AppSettings().getTintColour()
        slider.maximumValue = 60
        slider.addTarget(self, action: "brushSizeChanged:", forControlEvents: UIControlEvents.ValueChanged)
        slider.layer.zPosition = 1000
        slider.value = 10
        self.view.addSubview(slider)
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    func reset(sender: UIButton) {
        
        mainImageView!.image = imageToEdit

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
    
    func cancel(sender: UIButton)
    {
            navigationController?.popViewControllerAnimated(true)
    }
    
    func share(sender: AnyObject) {
        UIGraphicsBeginImageContext(mainImageView!.bounds.size)
        mainImageView!.image?.drawInRect(CGRect(x: 0, y: 0,
            width: mainImageView!.frame.size.width, height: mainImageView!.frame.size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let activity = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        presentViewController(activity, animated: true, completion: nil)
    }
    
    func pencilPressed(sender: AnyObject) {
        
        var index = sender.tag ?? 0
        if index < 0 || index >= colors.count {
            index = 0
        }
        
        (red, green, blue) = colors[index]
        
        if index == colors.count - 1 {
            opacity = 1.0
        }
    }
    func brushSizeChanged(sender: UISlider) {
        brushWidth = CGFloat(sender.value)
    }
   
    
    func eraseLastMove(sender: UIButton) {
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
    
    func showActivityIndicatory(uiView: UIView) {
        var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
        actInd.frame = CGRectMake(0.0, 0.0, 200.0, 200.0);
        actInd.center = uiView.center
        actInd.layer.zPosition = 100001
        actInd.hidesWhenStopped = true
        actInd.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.WhiteLarge
        uiView.addSubview(actInd)
        actInd.startAnimating()
    }
    
    func save(sender : UIButton)
    {
        var lightBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurView = UIVisualEffectView(effect: lightBlur)
        blurView.frame = self.view.bounds
        blurView.layer.zPosition = 100000
        
        inspectionItem.consentInspection.needSynced = NSNumber(bool: true)
        
        showActivityIndicatory(self.view)
        
        self.view.addSubview(blurView)
        
        
        
        // Merge tempImageView into mainImageView
        for tempImageView in arrayUIImageViews!
        {
        UIGraphicsBeginImageContext(mainImageView!.frame.size)
        mainImageView!.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: 1.0)
        tempImageView.image?.drawInRect(CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height), blendMode: kCGBlendModeNormal, alpha: opacity)
        mainImageView!.image = UIGraphicsGetImageFromCurrentImageContext()
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
        var identifier:String?
        let ph = PhotoHandler()
        ph.delegate = self
        ph.deleteImage(localIdentifier)
        ph.saveImageAsAsset(mainImageView!.image!, completion: { (localIdentifier) -> Void in identifier = localIdentifier})
        

        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        //clone size of main image view
        var tempImageView = UIImageView(frame: mainImageView!.frame)
        arrayUIImageViews!.append(tempImageView)
        tempImageView.tag = (arrayUIImageViews!.count)
      //  println(arrayUIImageViews!.count)
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
        
        //delete from core data
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        let resultPredicate = NSPredicate(format: "photoIdentifier = %@", localIdentifier)
        fetchRequest.predicate = resultPredicate
        
        
        let items = managedContext.executeFetchRequest(fetchRequest,error: nil)!
        
        for item in items {
            managedContext.deleteObject(item as! NSManagedObject)
        }
        
        localIdentifier = identifier
        self.navigationController!.popViewControllerAnimated(true)
        
    }
    
    func drawLineFrom(fromPoint: CGPoint, toPoint: CGPoint) {
        


        
       let id = arrayUIImageViews!.count - 1
        var tempImageView = arrayUIImageViews![id]
        
        if scale > 1
        {
            UIGraphicsBeginImageContext(view.frame.size)
        }
        else
        {
            UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.5)
        }
        
        
       // UIGraphicsBeginImageContext(view.frame.size)
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
        println(touches.count)
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

