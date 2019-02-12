//
//  MultipleSelectTableViewCell.swift
//  SuperSurveyBotMobile
//
//  Created by Sloan Anderson on 2/10/19.
//  Copyright © 2019 Sloan Anderson. All rights reserved.
//

import UIKit

class MultipleSelectTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }
}
