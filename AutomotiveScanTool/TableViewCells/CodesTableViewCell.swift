//
//  CodesTableViewCell.swift
//  AutomotiveScanTool
//
//  Created by Stephen Lomangino on 11/16/17.
//  Copyright © 2017 James Hall. All rights reserved.
//

import UIKit

class CodesTableViewCell: UITableViewCell {
    @IBOutlet weak var rowDescription: UILabel!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
