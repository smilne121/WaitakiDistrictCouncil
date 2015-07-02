//
//  ResultTransferItem.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 2/07/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation

class ResultTransferItem : Serializable
{
    var consentId: NSString
    var inspectionId: NSString
    var inspectionName: NSString
    var itemId: NSString
    var itemName: NSString
    var itemResult: NSString?
    
    init(consentId: NSString, inspectionId : NSString,inspectionName : NSString, itemId : NSString, itemName : NSString, itemResult : NSString?)
    {
        self.consentId = consentId
        self.inspectionId = inspectionId
        self.inspectionName = inspectionName
        self.itemId = itemId
        self.itemName = itemName
        if let result = itemResult
        {
            self.itemResult = itemResult
        }
        else
        {
            self.itemResult = ""
        }
    }
}