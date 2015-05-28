//
//  Consent+CoreData.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 27/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation

extension SavedConsent {
    func addInspectionObject(value: SavedInspection){
        self.inspection.addObject(value)
    }
    
    func removeInspectionObject(value: SavedInspection){
        self.inspection.removeObject(value)
    }
    
    func addContactObject(value: SavedContact){
        self.contact.addObject(value)
    }
    
    func removeContactObject(value: SavedContact){
        self.contact.removeObject(value)
    }
}
