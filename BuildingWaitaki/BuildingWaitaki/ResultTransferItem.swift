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
    var itemId: NSString
    var itemResult: NSString?
    
    init(item : ConsentInspectionItem)
    {
        self.itemId = item.itemId
        if let result = item.itemResult
        {
            self.itemResult = item.itemResult
        }
        else
        {
            self.itemResult = ""
        }
    }
}