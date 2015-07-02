//
//  TransferItemArray.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 2/07/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation

class ResultTransferInspection: Serializable
{
    var status: NSString
    var inspectionId: NSString
    var inspectionName: NSString
    var userCreated: NSString
    var locked: NSString
    var inspectionItems: [ResultTransferItem]
    
    init(inspection : ConsentInspection)
    {
        self.status = inspection.status!
        self.inspectionId = inspection.inspectionId
        self.inspectionName = inspection.inspectionName
        self.userCreated = inspection.userCreated.stringValue
        self.locked = inspection.locked.stringValue
        self.inspectionItems =  [ResultTransferItem]()
    }
}
