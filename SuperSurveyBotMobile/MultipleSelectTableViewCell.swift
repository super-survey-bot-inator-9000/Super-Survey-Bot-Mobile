//
//  MultipleSelectTableViewCell.swift
//  SuperSurveyBotMobile
//
//  Created by Sloan Anderson on 2/10/19.
//  Copyright © 2019 Sloan Anderson. All rights reserved.
//

import UIKit

class MultipleSelectTableViewCell: UITableViewCell {
    var cellLabel: UILabel!
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        cellLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 20))
        cellLabel.textColor = UIColor.black
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }
}
