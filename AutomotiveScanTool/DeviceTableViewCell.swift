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

class DeviceTableViewCell: UITableViewCell {

    @IBOutlet weak var deviceCellBackground: UIView!
    @IBOutlet weak var deviceImageView: UIImageView!
    @IBOutlet weak var deviceTypeLabel: UILabel!
    @IBOutlet weak var deviceStateImageView: UIImageView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceStateLabel: UILabel!
}
