//
//  SavedInspection.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 27/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class SavedInspection: NSManagedObject {

    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var comments: String
    @NSManaged var officer: String
    @NSManaged var consent: SavedConsent
    @NSManaged var inspectionItem: NSMutableSet

}
