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

class InspectionCameraViewController:  UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIGestureRecognizerDelegate, PhotoCompletionDelegate
{
    @IBOutlet weak var cameraViewer : UIImageView!
    @IBOutlet weak var takePicBtn : UIButton!
    @IBOutlet weak var pictureScroller : UIScrollView!
    var currentImageIdentifer : String?
    var inspectionItem : ConsentInspectionItem!
    var managedContext : NSManagedObjectContext!
    var imagePicker: UIImagePickerController!
    var library:ALAssetsLibrary = ALAssetsLibrary()
    var curX = 10

    
    override func viewDidLoad()
    {
            super.viewDidLoad()
        view.backgroundColor = AppSettings().getViewBackground()
        view.tintColor = AppSettings().getTintColour()
        
        self.title = inspectionItem.inspectionName + " - " + inspectionItem.itemName
        self.automaticallyAdjustsScrollViewInsets = false
           // loadImages()
        
        if inspectionItem.consentInspection.locked == NSNumber(bool: true)
        {
            takePicBtn.enabled = false
            takePicBtn.tintColor = AppSettings().getTintColour()
            takePicBtn.titleLabel?.font = AppSettings().getTextFont()
            takePicBtn.titleLabel?.textColor = AppSettings().getTintColour()
        }
        
        let swipeEdit = UISwipeGestureRecognizer(target: self, action:Selector("handleImageEditSwipeUp:"))
        swipeEdit.direction = UISwipeGestureRecognizerDirection.Up
        swipeEdit.delegate = self
        cameraViewer.addGestureRecognizer(swipeEdit)
        cameraViewer.userInteractionEnabled = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        loadImages()
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
        
       // var inspectionItemPhotos : [UIImage]
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        let resultPredicate1 = NSPredicate(format: "inspectionName = %@", inspectionItem.inspectionName)
        let resultPredicate2 = NSPredicate(format: "itemId = %@", inspectionItem.itemId)
        let resultPredicate3 = NSPredicate(format: "consentNumber = %@", inspectionItem.consentId)
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates:[resultPredicate1,resultPredicate2,resultPredicate3])
        fetchRequest.predicate = compound
        
        if let fetchResults = (try? managedContext.executeFetchRequest(fetchRequest)) as? [Photo]
        {
            if fetchResults.count != 0
            {
                for photoInfo in fetchResults
                {
                    print(photoInfo.photoIdentifier)
                    let photo = PhotoHandler()
                    photo.delegate = self
                    photo.retrieveImageWithIdentifer(photoInfo.photoIdentifier, completion: { (image) -> Void in
                        //let retrievedImage = image
                    })
                    
                }
            }
        }
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        imagePicker.dismissViewControllerAnimated(true, completion: nil)
        cameraViewer.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        saveImageToAlbum(cameraViewer.image!)
    }
    
    func saveImageToAlbum(image: UIImage)
    {
        var identifier:String?
        let photo = PhotoHandler()
        photo.delegate = self
        photo.saveImageAsAsset(image, completion: { (localIdentifier) -> Void in identifier = localIdentifier})
        
    }
    
    func photoLoaded(image : UIImage,imageIdentity: String)
    {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: CGFloat(curX), y: (pictureScroller.frame.height - 200) / 2 , width: CGFloat(200), height: CGFloat(200))
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
        
        currentImageIdentifer = imageIdentity
    }
    
    func photoSaveCompleted(identifier: String, image : UIImage)
    {
        let data = UIImageJPEGRepresentation(image as UIImage, 1)
        let encodedImage = data!.base64EncodedStringWithOptions([])
        
       // add photo details to database
        let currentImage = NSEntityDescription.insertNewObjectForEntityForName("Photo", inManagedObjectContext: managedContext) as! Photo
        currentImage.consentNumber = inspectionItem.consentId
        currentImage.inspectionName = inspectionItem.inspectionName
        currentImage.itemId = inspectionItem.itemId
        currentImage.consentInspectionItem = inspectionItem
        currentImage.encodedString = encodedImage
        currentImage.dateTaken = NSDate()
        currentImage.photoIdentifier = identifier
        do {
            try managedContext.save()
        } catch _ {
        }
        
        //clear view and reload
        for view in pictureScroller.subviews
        {
            view.removeFromSuperview()
        }
        curX = 10
        loadImages()
        
        inspectionItem.consentInspection.needSynced = NSNumber(bool: true)
        do {
            try managedContext.save()
        } catch _ {
        }
        
        
    }
    
     func handleTap(sender: UITapGestureRecognizer)
     {
        for view in cameraViewer.subviews
        {
            view.removeFromSuperview()
        }
        
        
        let imageview = sender.view! as! UIImageView
        cameraViewer.image = imageview.image
        
        for view in sender.view!.subviews
        {
            if view.isKindOfClass(UILabel)
            {
                let label = view as! UILabel
                currentImageIdentifer = label.text!
            }
        }

        
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

        let deleteBtn = UIButton(type: UIButtonType.System)
        deleteBtn.frame = CGRectMake(0, 150, 200, 50)
        deleteBtn.setTitle("Delete", forState: .Normal)
        deleteBtn.layer.backgroundColor = UIColor(red: 235/255.0, green: 5/255.0, blue: 5/255.0, alpha: 1.0).CGColor
        deleteBtn.tintColor = UIColor.whiteColor()
        deleteBtn.addTarget(self, action: "deleteImage:", forControlEvents: UIControlEvents.TouchUpInside)
        imageview.addSubview(deleteBtn)
    }
    
    func handleImageEditSwipeUp(sender: UITapGestureRecognizer)
    {
        let imageview = sender.view! as! UIImageView
        
        let deleteBtn = UIButton(type: UIButtonType.System)
        deleteBtn.frame = CGRectMake(0, imageview.frame.height - 50, imageview.frame.width, 50)
        deleteBtn.setTitle("Edit", forState: .Normal)
        deleteBtn.layer.backgroundColor = AppSettings().getTintColour().CGColor
        deleteBtn.tintColor = AppSettings().getBackgroundColour()
        deleteBtn.titleLabel?.font = AppSettings().getTextFont()
        deleteBtn.addTarget(self, action: "editImage:", forControlEvents: UIControlEvents.TouchUpInside)
        imageview.addSubview(deleteBtn)
    }
    
    func editImage (sender: UIButton)
    {
       
        let viewController = DrawingViewController()
        viewController.managedContext = self.managedContext
        viewController.inspectionItem = inspectionItem
        viewController.localIdentifier = currentImageIdentifer
        viewController.imageToEdit = (sender.superview as! UIImageView).image
        
        
         sender.removeFromSuperview()
        navigationController!.pushViewController(viewController, animated: true)

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
        let fetchRequest = NSFetchRequest(entityName: "Photo")
        let resultPredicate1 = NSPredicate(format: "inspectionName = %@", inspectionItem.inspectionName)
        let resultPredicate2 = NSPredicate(format: "itemId = %@", inspectionItem.itemId)
        let resultPredicate3 = NSPredicate(format: "consentNumber = %@", inspectionItem.consentId)
        let resultPredicate4 = NSPredicate(format: "photoIdentifier = %@", idnt)
        let compound = NSCompoundPredicate(andPredicateWithSubpredicates:[resultPredicate1,resultPredicate2,resultPredicate3,resultPredicate4])
        fetchRequest.predicate = compound
        
        if let fetchResults = (try? managedContext.executeFetchRequest(fetchRequest)) as? [Photo]
        {
            if fetchResults.count != 0
            {
                for image in fetchResults
                {
                     managedContext.deleteObject(image as NSManagedObject)
                    let photo = PhotoHandler()
                    photo.delegate = self
                    photo.deleteImage(idnt)
                }
            }
            else
            {
                print("error: duplicate image returned")
            }
            do {
                try managedContext.save()
            } catch _ {
            }
            
          
            loadImages()

        }}


    
}
