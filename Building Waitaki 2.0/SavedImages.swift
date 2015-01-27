//
//  SavedImages.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 27/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class SavedImages: NSManagedObject {

    @NSManaged var image: NSData
    @NSManaged var inspectionItem: SavedInspectionItem

}
