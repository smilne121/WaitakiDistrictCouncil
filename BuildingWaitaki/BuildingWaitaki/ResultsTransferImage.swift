//
//  ResultsTransferImage.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 12/08/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation


class ResultTransferImage : Serializable
{
    var image: String
    var dateTime: String
    
    init(image: String, dateTime: NSDate)
    {
        self.image = image
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let stringDate = dateFormatter.stringFromDate(dateTime)
        self.dateTime = stringDate
    }
    
}