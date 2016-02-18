//
//  SimpleTitleTableViewCell.swift
//  VishnuExample
//
//  Created by Daniel Lu on 2/18/16.
//  Copyright © 2016 Daniel Lu. All rights reserved.
//

import UIKit

class SimpleTitleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    var title:String? {
        get {
            return titleLabel.text
        }
        set {
            titleLabel.text = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
