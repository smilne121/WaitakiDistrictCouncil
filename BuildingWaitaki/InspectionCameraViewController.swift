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

class InspectionCameraViewController:  UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate
{
    @IBOutlet weak var cameraViewer : UIImageView!
    @IBOutlet weak var takePicBtn : UIButton!
    var imagePicker: UIImagePickerController!
    var library:ALAssetsLibrary = ALAssetsLibrary()
    
    override func viewDidLoad()
    {
            super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func takePhoto(sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .Camera
        
        presentViewController(imagePicker, animated: true, completion: nil)
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
        photo.saveImageAsAsset(image, completion: { (localIdentifier) -> Void in
            identifier = localIdentifier
        })
        //library.writeImageToSavedPhotosAlbum(image.CGImage, orientation: ALAssetOrientation(rawValue: image.imageOrientation.rawValue)!, completionBlock:saveDone)
    }
    
   /* func saveDone(assetURL:NSURL!, error:NSError!)
    {
        println("saveDone")
        library.assetForURL(assetURL, resultBlock: self.saveToAlbum, failureBlock: nil)
    }
    
    func saveToAlbum(asset:ALAsset!)
    {
        library.enumerateGroupsWithTypes(ALAssetsGroupAlbum, usingBlock: { group, stop in stop.memory = false
        if(group != nil)
        {
            let str = group.valueForProperty(ALAssetsGroupPropertyName) as! String
            if(str == "Building Inspection Photos")
            {
                group!.addAsset(asset!)
                let assetRep:ALAssetRepresentation = asset.defaultRepresentation()
                let iref = assetRep.fullResolutionImage().takeUnretainedValue()
                let image:UIImage = UIImage(CGImage:iref)!   }
            }
            }, failureBlock:
            { error in println("NOOOOOOO")
        })
    }*/

}
