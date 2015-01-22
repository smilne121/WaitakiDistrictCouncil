//
//  Consent.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 13/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation

class Consent
{
    var inspectionArray: [Inspection]
    let siteAddress: String
    let consentNumber: String
    var applicate: String
    var otherContacts: [Contact]?
    
    init(consentNumber: String, siteAddress: String, inspectionArray: [Inspection], applicate: String, otherContacts: [Contact]?)
    {
        self.inspectionArray = inspectionArray
        self.siteAddress = siteAddress
        self.consentNumber = consentNumber
        self.applicate = applicate
        self.otherContacts = otherContacts?
    }
    
}
