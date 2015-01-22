//
//  Contact.swift
//  Building Waitaki 2.0
//
//  Created by Scott Milne on 13/01/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import Foundation

class Contact
{
    var FirstName: String
    var LastName: String?
    var Phone: String?
    var Position: String?

    init(FirstName: String)
    {
        self.FirstName = FirstName
    }
}
