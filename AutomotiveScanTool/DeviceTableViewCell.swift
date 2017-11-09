//
//  DeviceTableViewCell.swift
//  AutomotiveScanTool
//
//  Created by James Hall on 11/8/17.
//  Copyright © 2017 James Hall. All rights reserved.
//

import Foundation
import QuartzCore
import UIKit

internal class DeviceTableViewCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        self.deviceCellBackgroundView.layer.cornerRadius = 6.0
//        self.deviceCellBackgroundView.layer.masksToBounds = true
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @IBOutlet weak var deviceCellBackgroundView: UIView!
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var deviceTypeLabel: UILabel!
    @IBOutlet weak var deviceStateImageView: UIImageView!
    //    @IBOutlet weak var deviceIDLabel: UILabel!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceStateLabel: UILabel!
    

    }
