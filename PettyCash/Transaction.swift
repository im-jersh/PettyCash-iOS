//
//  Transaction.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 9/29/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation
import CloudKit
import UIKit

// Represents various CKRecord keys corresponding to this class's properties
enum TransactionKey : String {
    case id = "id"
    case description = "description"
    case date = "date"
    case amount = "amount"
    case goal = "goal"
}

typealias Transactions = [Transaction]


class Transaction {
    
// MARK: Properties
    let id : String             // The unique id to the corresponding CKRecord
    let amount : Double         // The amount of this transaction (negative represents a deduction)
    let description : String    // A description of this transaction
    let date : Date             // The date of this transaction
    
    
// MARK: Initializers
    // Initialization from a CKRecord
    init(for amount: Double, withDescription description: String, andDate date: Date = Date()) {
        
        // TODO: Make strategy to create unique id's
        let idString = String(NSDate().hashValue) + "_" + UIDevice.current.name + "_" + "transaction"
        
        self.id = idString.toBase64()
        self.amount = amount
        self.description = description
        self.date = date
    }
    
    init(fromRecord record: CKRecord) {
        self.id = record.recordID.recordName
        self.amount = record.object(forKey: "amount") as! Double
        self.description = record.object(forKey: "description") as! String
        self.date = record.object(forKey: "date") as! Date
    }
    
}

