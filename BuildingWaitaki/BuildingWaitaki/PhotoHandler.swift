//
//  PhotoHandler.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 11/08/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import UIKit
import Photos

class PhotoHandler {
    
    var manager = PHImageManager.defaultManager()
    //var sender : InspectionCameraViewController!
    var delegate: PhotoCompletionDelegate?

    
    func saveImageAsAsset(image: UIImage, completion: (localIdentifier:String?) -> Void) {
        
        var imageIdentifier: String?
        
        PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
            let changeRequest = PHAssetChangeRequest.creationRequestForAssetFromImage(image)
            let placeHolder = changeRequest.placeholderForCreatedAsset
            imageIdentifier = placeHolder!.localIdentifier
            }, completionHandler: { (success, error) -> Void in
                if success {
                    completion(localIdentifier: imageIdentifier)
                    self.delegate!.photoSaveCompleted(imageIdentifier!, image: image)
                } else {
                    completion(localIdentifier: nil)
                }
        })
    }
    
    
    func deleteImage(localIdentifier:String)
    {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.Image.rawValue)
        let fetchResults = PHAsset.fetchAssetsWithLocalIdentifiers([localIdentifier], options: fetchOptions)
        
        if fetchResults.count > 0
        {
            if let imageAsset = fetchResults.objectAtIndex(0) as? PHAsset
            {
                PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                    
                    // Delete asset
                    PHAssetChangeRequest.deleteAssets([imageAsset])
                    }, completionHandler: { (success, error) -> Void in
                        if success {
                        self.delegate!.loadImages()
                        }else{
                            
                        }
            })
            }
        }
       
    }
    
    func deleteAppImages(identifiers: [String])
    {
        if identifiers.count > 0
        {
        print(identifiers.count)
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.Image.rawValue)
        let fetchResults = PHAsset.fetchAssetsWithLocalIdentifiers(identifiers, options: fetchOptions)
        
        print(fetchResults.count)
        
        let total = fetchResults.count
        var assetArray : [PHAsset]
        assetArray = []
        for i in 1...total
        {
            assetArray.append(fetchResults.objectAtIndex(i-1) as! PHAsset)
        }
        
        if fetchResults.count > 0
        {
            PHPhotoLibrary.sharedPhotoLibrary().performChanges({ () -> Void in
                    
            // Delete asset
            PHAssetChangeRequest.deleteAssets(assetArray)
            }, completionHandler: { (success, error) -> Void in
            if success {
                print("Pictures deleted")
            }else{
                            
                }
                })
            }
        }
    }
    
    func retrieveImageWithIdentifer(localIdentifier:String, completion: (image:UIImage?) -> Void) {
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "mediaType == %d", PHAssetMediaType.Image.rawValue)
        let fetchResults = PHAsset.fetchAssetsWithLocalIdentifiers([localIdentifier], options: fetchOptions)
        
        if fetchResults.count > 0 {
            if let imageAsset = fetchResults.objectAtIndex(0) as? PHAsset {
                let requestOptions = PHImageRequestOptions()
                requestOptions.deliveryMode = .HighQualityFormat
                manager.requestImageForAsset(imageAsset, targetSize: PHImageManagerMaximumSize, contentMode: .AspectFill, options: requestOptions, resultHandler: { (image, info) -> Void in
                    completion(image: image)
                    self.delegate!.photoLoaded(image!, imageIdentity: localIdentifier)
                })
            } else {
                completion(image: nil)
            }
        } else {
            completion(image: nil)
        }
    }
}

import CoreData

protocol PhotoCompletionDelegate {
    func photoSaveCompleted(identifier: String, image: UIImage)
    func loadImages()
    func photoLoaded(image: UIImage, imageIdentity: String)
}


