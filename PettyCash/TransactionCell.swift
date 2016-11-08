//
//  TransactionCell.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 11/4/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit

class TransactionCell: UITableViewCell {
    
// MARK: Outlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
