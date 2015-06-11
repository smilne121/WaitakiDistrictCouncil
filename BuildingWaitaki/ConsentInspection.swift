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

    @NSManaged var consentId: String
    @NSManaged var inspectionId: String
    @NSManaged var needSynced: NSNumber
    @NSManaged var consent: Consent
    @NSManaged var inspectionItem: NSSet

}
