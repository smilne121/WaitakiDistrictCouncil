//
//  SavedContact.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 27/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class SavedContact: NSManagedObject {

    @NSManaged var cellPhone: String
    @NSManaged var firstName: String
    @NSManaged var homePhone: String
    @NSManaged var lastName: String
    @NSManaged var position: String
    @NSManaged var consent: SavedConsent

}
