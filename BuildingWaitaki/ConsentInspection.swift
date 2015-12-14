//
//  ConsentInspection.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 10/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class ConsentInspection: NSManagedObject {
    @NSManaged var status: String?
    @NSManaged var consentId: String
    @NSManaged var inspectionName: String
    @NSManaged var inspectionId: String
    @NSManaged var needSynced: NSNumber
    @NSManaged var userCreated: NSNumber
    @NSManaged var locked: NSNumber
    @NSManaged var timeTaken: Int32
    @NSManaged var consent: Consent
    @NSManaged var inspectionItem: NSSet
}


