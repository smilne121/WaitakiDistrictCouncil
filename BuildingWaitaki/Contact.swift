//
//  Contact.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 30/05/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

class Contact: NSManagedObject {

    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var position: String
    @NSManaged var cellPhone: String
    @NSManaged var homePhone: String
    @NSManaged var consentNumber: String

}
