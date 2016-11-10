//
//  ExpenseCell.swift
//  PettyCash
//  
//  Created by Emeka Okoye on 11/6/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation

class ExpenseCell: UITableViewCell {
    
    // MARK: Outlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var expenseAmountLabel: UILabel!
    @IBOutlet weak var expenseDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
