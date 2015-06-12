//
//  InspectionType.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 8/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class InspectionType: NSManagedObject {

    @NSManaged var inspectionId: String
    @NSManaged var inspectionName: String
    @NSManaged var inspectionTypeItems: NSSet
    
   /* func addInspectionTypeItem(inspectionItem: InspectionTypeItems)
    {
        self.inspectionTypeItems.setByAddingObject(inspectionItem)
    }*/

}
