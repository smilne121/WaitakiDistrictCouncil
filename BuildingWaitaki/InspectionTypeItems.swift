//
//  InspectionTypeItems.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 21/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class InspectionTypeItems: NSManagedObject {

    @NSManaged var inspectionId: String
    @NSManaged var itemId: String
    @NSManaged var itemName: String
    @NSManaged var itemType: String
    @NSManaged var photosAllowed: NSNumber
    @NSManaged var required: NSNumber
    @NSManaged var order: String
    @NSManaged var inspectionType: InspectionType
    
    func getOrderAsInt() -> Int
    {
        return self.order.toInt()!
    }

}
