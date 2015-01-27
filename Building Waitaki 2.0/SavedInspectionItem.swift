//
//  SavedInspectionItem.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 27/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class SavedInspectionItem: NSManagedObject {

    @NSManaged var camera: NSNumber
    @NSManaged var name: String
    @NSManaged var required: Bool
    @NSManaged var type: String
    @NSManaged var value: String
    @NSManaged var inspection: SavedInspection
    @NSManaged var image: NSSet

}
