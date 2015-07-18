//
//  CurrentConsentTableViewCell.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 15/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import UIKit

class CurrentConsentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var lockImage: UIImageView!
    @IBOutlet weak var inspectionName: UILabel!
    @IBOutlet weak var inspectionComments: UILabel!
    @IBOutlet weak var inspectionUpdatedBy: UILabel!
    @IBOutlet weak var inspectionUpdatedDate: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
