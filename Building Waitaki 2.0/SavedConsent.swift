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
    @NSManaged var inspections: NSSet
    @NSManaged var contacts: NSSet
}

class SavedInspection: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var comments: String
    @NSManaged var officer: String
    @NSManaged var consent: SavedConsent
    @NSManaged var inspectionItems: NSSet
}

class SavedContact: NSManagedObject {
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var position: String
    @NSManaged var homePhone: String
    @NSManaged var cellPhone: String
    @NSManaged var consent:SavedConsent
}

class SavedInspectionItem: NSManagedObject {
    @NSManaged var camera: Bool
    @NSManaged var name: String
    @NSManaged var required: Bool
    @NSManaged var type: String
    @NSManaged var value: String
    @NSManaged var inspection: SavedInspection
    @NSManaged var images:NSSet
}

class SavedImages: NSManagedObject {
    @NSManaged var image:Byte
    @NSManaged var inspectionItem: SavedInspectionItem
}
