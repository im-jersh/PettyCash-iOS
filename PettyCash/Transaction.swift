//
//  Transaction.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 9/29/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation
import CloudKit


typealias Transactions = [Transaction]


struct Transaction {
    
// MARK: Properties
    let amount : Double         // The amount of this transaction (negative represents a deduction)
    let description : String    // A description of this transaction
    let date : Date             // The date of this transaction
    
    
// MARK: Initializers
    // Initialization from a CKRecord
    init(fromRecord record: CKRecord) {
        self.amount = record.object(forKey: "amount") as! Double
        self.description = record.object(forKey: "description") as! String
        self.date = record.object(forKey: "date") as! Date
        
    }
    
}
