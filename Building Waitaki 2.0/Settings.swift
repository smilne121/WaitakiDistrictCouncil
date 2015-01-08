//
//  Settings.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 5/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
import CoreData

@objc(Settings)
class Settings: NSManagedObject {

    @NSManaged var serverAddress: String
    @NSManaged var user: String

}
