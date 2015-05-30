//
//  Consent.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 30/05/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class Consent: NSManagedObject {

    @NSManaged var consentNumber: String
    @NSManaged var consentAddress: String
    @NSManaged var consentDescription: String

}
