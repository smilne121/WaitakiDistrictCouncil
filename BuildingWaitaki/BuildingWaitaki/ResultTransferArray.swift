//
//  ResultTransferArray.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 3/07/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation
class ResultTransferArray : Serializable
{
    var consentsArray = [ResultTransferInspection]()
    
    init(consents: [ConsentInspection])
    {
        super.init()
        for consent in consents
        {
            self.append(consent)
        }
    }
    
    func append(inspection: ConsentInspection)
    {
        let newInspection = ResultTransferInspection(inspection: inspection)
        consentsArray.append(newInspection)
    }
    
}