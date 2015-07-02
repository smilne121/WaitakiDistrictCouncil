//
//  ResultTransferConsent.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 2/07/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation

class ResultTransferConsent : Serializable
{
    var consentNumber: String
    var inspections: [ResultTransferInspection]

    init(consent: Consent)
    {
        self.consentNumber = consent.consentNumber
        self.inspections = [ResultTransferInspection]()
    }
}
