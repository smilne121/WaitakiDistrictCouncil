//
//  InspectionCameraViewController.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 6/08/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary
import CoreData

class InspectionCameraViewController:  UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIGestureRecognizerDelegate
{
    @IBOutlet weak var cameraViewer : UIImageView!
    @IBOutlet weak var takePicBtn : UIButton!
    @IBOutlet weak var pictureScroller : UIScrollView!
    var inspectionItem : ConsentInspectionItem!
    var managedContext : NSManagedObjectContext!
    var imagePicker: UIImagePickerController!
    var library:ALAssetsLibrary = ALAssetsLibrary()
    var curX = 10

    
    override func viewDidLoad()
    {
            super.viewDidLoad()
        self.title = inspectionItem.inspectionName + " - " + inspectionItem.itemName
        self.automaticallyAdjustsScrollViewInsets = false
            loadImages()
        
        if inspectionItem.consentInspection.locked == NSNumber(bool: true)
        {
            takePicBtn.enabled = false
        }
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(sender: UIButton) {
        if inspectionItem.consentInspection.locked == NSNumber(bool: false)
        {
            if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera))
            {
                imagePicker =  UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .Camera
                presentViewController(imagePicker, animated: true, completion: nil)
            }
        }
        
    }
    
    func loadImages()
    {
        curX = 10
        for view in pictureScroller.subviews
        {
            view.removeFromSuperview()
        }
        
        var inspectionItemPhotos : [UIImage]
        var fetchRequest = NSFetchRequest(entityName: "Photo")
        let resultPredicate1 = NSPredicate(format: "inspectionName = %@", inspectionItem.inspectionName)
        let resultPredicate2 = NSPredicate(format: "itemId = %@", inspectionItem.itemId)
        let resultPredicate3 = NSPredicate(format: "consentNumber = %@", inspectionItem.consentId)
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1,resultPredicate2,resultPredicate3])
        fetchRequest.predicate = compound
        
        if let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: nil) as? [Photo]
        {
            if fetchResults.count != 0
            {
                for photoInfo in fetchResults
                {
                    println(photoInfo.photoIdentifier)
                    let photo = PhotoHandler()
                    photo.sender = self
                    photo.retrieveImageWithIdentifer(photoInfo.photoIdentifier, completion: { (image) -> Void in
                        let retrievedImage = image
                    })
                    
                }
            }
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        cameraViewer.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        saveImageToAlbum(cameraViewer.image!)
    }
    
    func saveImageToAlbum(image: UIImage)
    {
        var identifier:String?
        let photo = PhotoHandler()
        photo.sender = self
        photo.saveImageAsAsset(image, completion: { (localIdentifier) -> Void in
            identifier = localIdentifier
        })
    }
    
    func photoLoaded(image : UIImage,imageIdentity: String)
    {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: curX, y: 0, width: 200, height: 200)
        imageView.userInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action:Selector("handleTap:"))
        tap.delegate = self
        let swipeUp = UISwipeGestureRecognizer(target: self, action:Selector("handleSwipeUp:"))
        swipeUp.direction = UISwipeGestureRecognizerDirection.Up
        swipeUp.delegate = self
        let swipeDown = UISwipeGestureRecognizer(target: self, action:Selector("handleSwipeDown:"))
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        swipeDown.delegate = self
        let identifier = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        identifier.text = imageIdentity

        imageView.addGestureRecognizer(swipeDown)
        imageView.addGestureRecognizer(swipeUp)
        imageView.addGestureRecognizer(tap)
        imageView.addSubview(identifier)
        curX = curX + 210
        pictureScroller.addSubview(imageView)
        pictureScroller.contentSize = CGSize(width: CGFloat(curX + 300), height: pictureScroller.frame.height)
        cameraViewer.image = image
        
    }
    
    func completedSave(identifier: String, image : UIImage)
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
        
        //clear view and reload
        for view in pictureScroller.subviews
        {
            view.removeFromSuperview()
        }
        curX = 10
        loadImages()
        
        
    }
    
     func handleTap(sender: UITapGestureRecognizer)
     {
        let imageview = sender.view! as! UIImageView
        cameraViewer.image = imageview.image
        
    }
    func handleSwipeUp(sender: UITapGestureRecognizer)
    {
        //clear other delete buttons
        for view in pictureScroller.subviews
        {
            if view.isKindOfClass(UIImageView)
            {
                for subview in view.subviews
                {
                    if subview.isKindOfClass(UIButton)
                    {
                        subview.removeFromSuperview()
                    }
                }
            }
        }
        
        let imageview = sender.view! as! UIImageView

        let deleteBtn = UIButton.buttonWithType(UIButtonType.System) as! UIButton
        deleteBtn.frame = CGRectMake(0, 150, 200, 50)
        deleteBtn.setTitle("Delete", forState: .Normal)
        deleteBtn.layer.backgroundColor = UIColor.redColor().CGColor
        deleteBtn.tintColor = UIColor.whiteColor()
        deleteBtn.addTarget(self, action: "deleteImage:", forControlEvents: UIControlEvents.TouchUpInside)
        imageview.addSubview(deleteBtn)
    }
    func handleSwipeDown(sender: UITapGestureRecognizer)
    {
        let imageview = sender.view! as! UIImageView
        
       for view in imageview.subviews
       {
        view.removeFromSuperview()
        }
    }
    
    func deleteImage(sender: UIButton)
    {
        var idnt = ""
        for view in sender.superview!.subviews
        {
            if view.isKindOfClass(UILabel)
            {
                let label = view as! UILabel
                idnt = label.text!
            }
        }
        var fetchRequest = NSFetchRequest(entityName: "Photo")
        let resultPredicate1 = NSPredicate(format: "inspectionName = %@", inspectionItem.inspectionName)
        let resultPredicate2 = NSPredicate(format: "itemId = %@", inspectionItem.itemId)
        let resultPredicate3 = NSPredicate(format: "consentNumber = %@", inspectionItem.consentId)
        let resultPredicate4 = NSPredicate(format: "photoIdentifier = %@", idnt)
        var compound = NSCompoundPredicate.andPredicateWithSubpredicates([resultPredicate1,resultPredicate2,resultPredicate3,resultPredicate4])
        fetchRequest.predicate = compound
        
        if let fetchResults = managedContext.executeFetchRequest(fetchRequest, error: nil) as? [Photo]
        {
            if fetchResults.count != 0
            {
                for image in fetchResults
                {
                     managedContext.deleteObject(image as NSManagedObject)
                    let photo = PhotoHandler()
                    photo.sender = self
                    photo.deleteImage(idnt)
                }
            }
            else
            {
                println("error: duplicate image returned")
            }
            managedContext.save(nil)
            
          
            loadImages()

        }}


    
}
