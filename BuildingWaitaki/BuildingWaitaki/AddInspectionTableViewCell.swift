//
//  AddInspectionTableViewCell.swift
//  BuildingWaitaki
//
//  Created by Scott Milne on 26/06/15.
//  Copyright (c) 2015 Waitaki District Council. All rights reserved.
//

import UIKit

class AddInspectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = AppSettings().getViewBackground()
        self.tintColor = AppSettings().getTintColour()
        
        for curview in self.subviews
        {
            if curview.isKindOfClass(UILabel)
            {
                (curview as! UILabel).textColor = AppSettings().getTintColour()
                (curview as! UILabel).font = AppSettings().getTitleFont()
            }
        }
        
       
        
        let border = CALayer()
        border.backgroundColor = AppSettings().getTintColour().CGColor
        border.frame = CGRect(x: CGFloat(((self.frame.width - (self.frame.width - 50)) / 2)) , y: CGFloat(149), width: CGFloat(self.frame.width - 50), height: CGFloat(1))
        
        self.layer.addSublayer(border)

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
