//
//  Photo.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 11/08/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class Photo: NSManagedObject {

    @NSManaged var consentNumber: String
    @NSManaged var inspectionName: String
    @NSManaged var itemId: String
    @NSManaged var photoIdentifier: String
    @NSManaged var consentInspectionItem: ConsentInspectionItem

}
