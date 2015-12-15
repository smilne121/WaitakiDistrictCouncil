//
//  Consent.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 11/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class Consent: NSManagedObject {

    @NSManaged var consentAddress: String
    @NSManaged var consentDescription: String
    @NSManaged var consentConditions: String?
    @NSManaged var consentNumber: String
    @NSManaged var consentInspection: NSSet
    @NSManaged var contact: NSSet
}
