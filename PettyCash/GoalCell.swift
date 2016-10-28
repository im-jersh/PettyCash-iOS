//
//  GoalCell.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 10/28/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit
import MBCircularProgressBar

class GoalCell: UITableViewCell {
    
// MARK: Outlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var goalDescriptionLabel: UILabel!
    @IBOutlet weak var goalEndDateLabel: UILabel!
    @IBOutlet weak var goalProgressBar: MBCircularProgressBarView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
