//
//  Inspection+CoreData.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 27/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
extension SavedInspection {
    func addInspectionItemObject(value: SavedInspectionItem){
       self.inspectionItem.addObject(value)
    }
    
    func removeInspectionItemObject(value: SavedInspectionItem){
        self.inspectionItem.removeObject(value)
}
}