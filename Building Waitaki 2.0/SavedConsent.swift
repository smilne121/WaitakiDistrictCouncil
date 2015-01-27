//
//  SavedConsent.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 27/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class SavedConsent: NSManagedObject {

    @NSManaged var account: String
    @NSManaged var consentNumber: String
    @NSManaged var siteAddress: String
    @NSManaged var workDescription: String
    @NSManaged var contact: NSSet
    @NSManaged var inspection: NSSet

}
