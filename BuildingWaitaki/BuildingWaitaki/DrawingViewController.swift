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
        
        self.navigationController!.interactivePopGestureRecognizer.enabled = false
        
        // Do any additional setup after loading the view, typically from a nib.
        mainImageView = UIImageView(frame: CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat(768), height: CGFloat(1024)))
        mainImageView!.image = imageToEdit
        self.view.addSubview(mainImageView!)
        arrayUIImageViews = [UIImageView]()
        
        //order and buttons
        let grnBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        grnBtn.frame = CGRectMake(24, 894, 46, 30)
        grnBtn.setTitle("Green", forState: UIControlState.Normal)
        grnBtn.tintColor = UIColor.greenColor()
        grnBtn.addTarget(self, action: "pencilPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        grnBtn.tag = 6
        grnBtn.layer.backgroundColor = UIColor.whiteColor().CGColor
        grnBtn.layer.zPosition = 1000
        self.view.addSubview(grnBtn)
        
        //order and buttons
        let redBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        redBtn.frame = CGRectMake(24, 856, 46, 30)
        redBtn.setTitle("Red", forState: UIControlState.Normal)
        redBtn.tintColor = UIColor.redColor()
        redBtn.addTarget(self, action: "pencilPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        redBtn.layer.zPosition = 1000
        redBtn.tag = 2
        redBtn.layer.backgroundColor = UIColor.whiteColor().CGColor
        self.view.addSubview(redBtn)
        //order and buttons
        let blueBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        blueBtn.frame = CGRectMake(24, 932, 46, 30)
        blueBtn.setTitle("Blue", forState: UIControlState.Normal)
        blueBtn.tintColor = UIColor.blueColor()
        blueBtn.addTarget(self, action: "pencilPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        blueBtn.layer.zPosition = 1000
        blueBtn.layer.backgroundColor = UIColor.whiteColor().CGColor
        blueBtn.tag = 3
        self.view.addSubview(blueBtn)
        //order and buttons
        let blackBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        blackBtn.frame = CGRectMake(24, 970, 46, 30)
        blackBtn.setTitle("Black", forState: UIControlState.Normal)
        blackBtn.tintColor = UIColor.blackColor()
        blackBtn.layer.backgroundColor = UIColor.whiteColor().CGColor
        blackBtn.addTarget(self, action: "pencilPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        blackBtn.tag = 0
        blackBtn.layer.zPosition = 1000
        self.view.addSubview(blackBtn)
        
        //order and buttons
        let eraseBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        eraseBtn.frame = CGRectMake(706, 856, 46, 30)
        eraseBtn.setTitle("Erase", forState: UIControlState.Normal)
        eraseBtn.layer.backgroundColor = UIColor.whiteColor().CGColor
        eraseBtn.tintColor = UIColor.blackColor()
        eraseBtn.addTarget(self, action: "eraseLastMove:", forControlEvents: UIControlEvents.TouchUpInside)
        eraseBtn.layer.zPosition = 1000
        self.view.addSubview(eraseBtn)
        
        
        //order and buttons
        let resetBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        resetBtn.frame = CGRectMake(706, 894, 46, 30)
        resetBtn.setTitle("Reset", forState: UIControlState.Normal)
        resetBtn.layer.backgroundColor = UIColor.whiteColor().CGColor
        resetBtn.tintColor = UIColor.blackColor()
        resetBtn.addTarget(self, action: "reset:", forControlEvents: UIControlEvents.TouchUpInside)
        eraseBtn.layer.zPosition = 1000
        self.view.addSubview(resetBtn)
        
        //order and buttons
        let saveBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        saveBtn.frame = CGRectMake(706, 932, 46, 30)
        saveBtn.setTitle("Save", forState: UIControlState.Normal)
        saveBtn.layer.backgroundColor = UIColor.whiteColor().CGColor
        saveBtn.tintColor = UIColor.blackColor()
        saveBtn.addTarget(self, action: "save:", forControlEvents: UIControlEvents.TouchUpInside)
        saveBtn.layer.zPosition = 1000
        self.view.addSubview(saveBtn)
        
        //order and buttons
        let cancelBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        cancelBtn.frame = CGRectMake(706, 970, 46, 30)
        cancelBtn.setTitle("Cancel", forState: UIControlState.Normal)
        cancelBtn.layer.backgroundColor = UIColor.whiteColor().CGColor
        cancelBtn.tintColor = UIColor.blackColor()
        //eraseBtn.addTarget(self, action: "eraseLastMove:", forControlEvents: UIControlEvents.TouchUpInside)
        cancelBtn.layer.zPosition = 1000
        self.view.addSubview(cancelBtn)
        
        let slider = UISlider(frame: CGRect(x: 157, y: 970, width: 445, height: 32))
        slider.value = 10
        slider.minimumValue = 1
        slider.maximumValue = 100
        slider.addTarget(self, action: "brushSizeChanged:", forControlEvents: UIControlEvents.ValueChanged)
        slider.layer.zPosition = 1000
        self.view.addSubview(slider)
        
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Actions
    
    @IBAction func reset(sender: UIButton) {
        
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
    
    @IBAction func share(sender: AnyObject) {
        UIGraphicsBeginImageContext(mainImageView!.bounds.size)
        mainImageView!.image?.drawInRect(CGRect(x: 0, y: 0,
            width: mainImageView!.frame.size.width, height: mainImageView!.frame.size.height))
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
    
    @IBAction func save(sender : UIButton)
    {
        var lightBlur = UIBlurEffect(style: UIBlurEffectStyle.Dark)
        var blurView = UIVisualEffectView(effect: lightBlur)
        blurView.frame = self.view.bounds
        blurView.layer.zPosition = 100000
        
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

