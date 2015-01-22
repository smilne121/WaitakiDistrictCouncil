//
//  CameraViewController.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 12/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import UIKit
import MobileCoreServices

class CameraViewController: UIViewController ,UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    var imagePicker: UIImagePickerController!
    var newMedia: Bool?
    var imageArray: [UIImage]?
    var delegate: CameraDelegate! = nil
    @IBOutlet var imageScrollView: UIScrollView!

    
    var onDataAvailable : ((data: [UIImage]) -> ())?
    
    
    @IBOutlet var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
         imagePicker = UIImagePickerController()
        if imageArray == nil
        {
            imageArray = []
        }
        

        addImagesToScrollView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func useCamera(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.Camera) {
                
                // let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = true
        }
    }
    
    func addImagesToScrollView()
    {
        //clear scroll view
        for view in imageScrollView.subviews
        {
            view.removeFromSuperview()
        }
    
        //generate scroll view
        let x: CGFloat = 40
        var totalWidth:CGFloat = 0;
        for var i: Int = 0; i < imageArray!.count; i++
        {
            let deleteButton = UIButton.buttonWithType(UIButtonType.System) as UIButton
            deleteButton.frame = CGRectMake(20, 170, 110, 30)
            deleteButton.backgroundColor = UIColor.darkGrayColor()
            deleteButton.tintColor = UIColor.whiteColor()
            deleteButton.setTitle("Delete", forState: UIControlState.Normal)
            deleteButton.layer.cornerRadius = 12.0
            var imageView = UIImageView()
            imageView.image = imageArray![i]
            imageView.frame = CGRectMake((x + CGFloat(150)) * (CGFloat(i)),40, 150, 200)
            totalWidth = imageView.frame.origin.x + CGFloat(200)
            imageView.tag = i
            deleteButton.tag = i
            deleteButton.addTarget(self, action: "imageDeleteButton:", forControlEvents: UIControlEvents.TouchUpInside)
            imageView.addSubview(deleteButton)
            imageView.userInteractionEnabled = true
            imageScrollView.addSubview(imageView)
        }

        imageScrollView.contentSize = CGSize(width: totalWidth, height: 200)
        
        
    }
    
    func deleteFromImageArray(TagNumber: Int)
    {
        imageArray?.removeAtIndex(TagNumber)
        addImagesToScrollView();
    }
    
    func imageDeleteButton(sender: UIButton!)
    {
        println("delete image")
        
        var deleteAlert = UIAlertController(title: "Delete Image", message: "Image will be removed from inspection", preferredStyle: UIAlertControllerStyle.Alert)
        
        deleteAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { (action: UIAlertAction!) in
            self.deleteFromImageArray(sender.tag)
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Cancel", style: .Default, handler: { (action: UIAlertAction!) in

        }))
        
        presentViewController(deleteAlert, animated: true, completion: nil)
        
    }
    
    func useCameraRoll(sender: AnyObject) {
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.SavedPhotosAlbum) {
                let imagePicker = UIImagePickerController()
                
                imagePicker.delegate = self
                imagePicker.sourceType =
                    UIImagePickerControllerSourceType.PhotoLibrary
                imagePicker.mediaTypes = [kUTTypeImage as NSString]
                imagePicker.allowsEditing = false
                self.presentViewController(imagePicker, animated: true,
                    completion: nil)
                newMedia = false
        }
    }
    
    @IBAction func backToInspection (sender: UIButton)
    {
        delegate.didFinishCamera(self)
        navigationController?.popViewControllerAnimated(true)
    }
    
    
    //delagate methods
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as NSString        
        if mediaType.isEqualToString(kUTTypeImage as NSString) {
            let image = info[UIImagePickerControllerOriginalImage]
                as UIImage
            
            //  imageView.image = image
            if imageArray == nil
            {
            imageArray = []
            }
            imageArray!.append(image)
            imageView.image = image
            
            //remake imagescrollview
            addImagesToScrollView()
            
            
            
            if (newMedia == true) {
                UIImageWriteToSavedPhotosAlbum(image, self,
                    "image:didFinishSavingWithError:contextInfo:", nil)
            } else if mediaType.isEqualToString(kUTTypeMovie as NSString) {
                // Code to support video here
            }
            
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func image(image: UIImage, didFinishSavingWithError error: NSErrorPointer, contextInfo:UnsafePointer<Void>) {
        
        if error != nil {
            let alert = UIAlertController(title: "Save Failed",
                message: "Failed to save image",
                preferredStyle: UIAlertControllerStyle.Alert)
            
            let cancelAction = UIAlertAction(title: "OK",
                style: .Cancel, handler: nil)
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true,
                completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //pass data back
    func sendData(data: [UIImage]) {
        // Whenever you want to send data back to viewController1, check
        // if the closure is implemented and then call it if it is
        self.onDataAvailable?(data: data)
    }
    

}
