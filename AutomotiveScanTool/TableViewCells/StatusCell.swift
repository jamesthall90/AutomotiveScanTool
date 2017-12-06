//
//  StatusCell.swift
//  AutomotiveScanTool
//
//  Created by Stephen Lomangino on 11/28/17.
//  Copyright © 2017 James Hall. All rights reserved.
//

import UIKit

class StatusCell: UITableViewCell {

    @IBOutlet weak var codeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var expandArrow: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
