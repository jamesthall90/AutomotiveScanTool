//
//  DateCell.swift
//  AutomotiveScanTool
//
//  Created by Stephen Lomangino on 12/1/17.
//  Copyright © 2017 James Hall. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {

    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        styleDateLabel()
        styleDateView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func styleDateLabel(){
        
        dateLabel.font = UIFont(name: "Copperplate-Bold", size: 17)
        dateLabel.textColor = astColor
    }
    
    func styleDateView(){
        
        //Creates a border for the bottom of the view only
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.black.cgColor
        border.frame = CGRect(x: 0, y: dateView.frame.size.height - width, width:  dateView.frame.size.width, height: dateView.frame.size.height)
        border.borderWidth = width
        dateView.layer.addSublayer(border)
        dateView.layer.masksToBounds = true
    }
}
