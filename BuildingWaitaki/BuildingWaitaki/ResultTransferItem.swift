//
//  ResultTransferItem.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 2/07/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class ResultTransferItem : Serializable
{
    var itemId: NSString
    var itemResult: NSString?
    var itemComment: NSString?
    var inspectionItemPhoto: [ResultTransferImage]
    var managedContext: NSManagedObjectContext!
    
    init(item : ConsentInspectionItem)
    {
        self.itemId = item.itemId
        self.itemComment = item.itemComment
        self.inspectionItemPhoto = [ResultTransferImage]()
        
        if let result = item.itemResult
        {
            self.itemResult = result
        }
        else
        {
            self.itemResult = ""
        }
        
        for photo in item.photo
        {
            let image = photo as! Photo
            let newPhoto = ResultTransferImage(image: image.encodedString, dateTime: image.dateTaken)
            inspectionItemPhoto.append(newPhoto)
        }
    }
}