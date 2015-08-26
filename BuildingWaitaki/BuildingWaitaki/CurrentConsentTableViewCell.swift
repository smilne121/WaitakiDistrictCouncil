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
        self.backgroundColor = UIColor.clearColor()
        self.tintColor = AppSettings().getTintColour()
        

        inspectionName.textColor = AppSettings().getTintColour()
        inspectionName.font = AppSettings().getTitleFont()
        inspectionComments.textColor = AppSettings().getTextColour()
        inspectionComments.font = AppSettings().getTextFont()
        inspectionUpdatedBy.textColor = AppSettings().getTextColour()
        inspectionUpdatedBy.font = AppSettings().getTextFont()
        inspectionUpdatedDate.textColor = AppSettings().getTextColour()
        inspectionUpdatedDate.font = AppSettings().getTextFont()
        
        let border = CALayer()
        border.backgroundColor = AppSettings().getTintColour().CGColor
        border.frame = CGRect(x: CGFloat(((self.frame.width - (self.frame.width - 50)) / 2)) , y: CGFloat(149), width: CGFloat(self.frame.width - 50), height: CGFloat(1))
        
        self.layer.addSublayer(border)
        
        
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
}
