//
//  InspectionTypeItems.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 30/05/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class InspectionTypeItems: NSManagedObject {

    @NSManaged var itemId: String
    @NSManaged var itemType: String
    @NSManaged var itemName: String
    @NSManaged var required: String
    @NSManaged var photosAllowed: String
    @NSManaged var inspectionId: String

}
