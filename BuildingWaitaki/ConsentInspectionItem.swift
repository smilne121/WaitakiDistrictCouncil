//
//  ConsentInspectionItem.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 10/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class ConsentInspectionItem: NSManagedObject {

    @NSManaged var consentId: String
    @NSManaged var inspectionId: String
    @NSManaged var inspectionName: String
    @NSManaged var itemId: String
    @NSManaged var itemName: String
    @NSManaged var itemResult: String?
    @NSManaged var consentInspection: ConsentInspection
    


}
