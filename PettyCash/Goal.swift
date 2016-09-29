//
//  Goal.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 9/29/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation
import CloudKit

// Indicates various levels of priority
enum Priority : Int {
    case low, medium, high
}

// Represents various CKRecord keys corresponding to this class's properties
enum GoalKey : String {
    case id = "id"
    case description = "description"
    case startDate = "startDate"
    case endDate = "endDate"
    case amount = "amount"
    case priority = "priority"
    case transactions = "transactions"
}


typealias Goals = [Goal]


struct Goal {
    
// MARK: Properties
    let id : String                         // The unique id to the corresponding CKRecord
    let description : String                // A description of the goal
    let startDate : Date                    // The date the goal will become active
    let endDate : Date?                     // The date the user would like to achieve the goal by
    let amount : Double                     // The amount of the goal
    let priority : Priority                 // The goal's priority among other goals
    var transactions : Transactions?        // A collection of transactions that have contributed to the progress of this goal
    
    
// MARK: Computed Properties
    // The sum of the contribution amounts towards achieving this goal
    var contributionAmount : Double {
        get {
            guard let transactions = self.transactions else { return 0.0 }
            return transactions.reduce(0.0) {(total, transaction) in total + transaction.amount}
        }
    }
    
    // A percentage representing the overall progress made towards this goal
    var progress : Double {
        get {
            guard let _ = self.transactions else { return 0.0 }
            return self.contributionAmount / self.amount
        }
    }
    
    // A boolean indicating if the goal has been completed
    var complete : Bool {
        get {
            return self.progress == 1.0 ? true : false
        }
    }
    
    
// MARK: Initializers
    // Initialization from a CKRecord
    init(fromRecord record: CKRecord) {
        
        self.id = record.recordID.recordName
        self.description = record.object(forKey: GoalKey.description.rawValue) as! String
        self.startDate = record.object(forKey: GoalKey.startDate.rawValue) as! Date
        self.endDate = record.object(forKey: GoalKey.endDate.rawValue) as? Date
        self.amount = record.object(forKey: GoalKey.amount.rawValue) as! Double
        self.priority = Priority(rawValue: record.object(forKey: GoalKey.priority.rawValue) as! Int)!
        
    }
    
    
}
