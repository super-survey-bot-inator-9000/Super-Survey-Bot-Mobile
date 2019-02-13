//
//  CustomTableViewCell.swift
//  SuperSurveyBotMobile
//
//  Created by Sloan Anderson on 2/13/19.
//  Copyright © 2019 Sloan Anderson. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    @IBOutlet weak var answerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
