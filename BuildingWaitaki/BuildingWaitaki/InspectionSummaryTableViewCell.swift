//
//  InspectionSummaryTableViewCell.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 18/12/15.
//  Copyright © 2015 Waitaki District Council. All rights reserved.
//

import UIKit

class InspectionSummaryTableViewCell: UITableViewCell {
    @IBOutlet weak var inspectionName: UILabel!
    @IBOutlet weak var inspectionItemName: UILabel!
    @IBOutlet weak var inspectionItemComments: UILabel!
    @IBOutlet weak var inspectionResult: UILabel!
    
    @IBOutlet weak var inspectionResultFail: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = AppSettings().getViewBackground()
        self.tintColor = AppSettings().getTintColour()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
