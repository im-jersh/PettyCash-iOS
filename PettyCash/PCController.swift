//
//  PettyCashController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 11/4/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation

public enum PetAction : Double {
    case poop = 1.0
    case feed = 1.5
    case bathe = 5.0
    case treat = 2.5
    case groom = 3.7
}

protocol PCHandler {
    func fetchAllGoals(completionHandler: @escaping (Goals?, Error?) -> Void)
    func fetchAllTransactions(for goal: Goal, completionHandler: @escaping (Transactions?, Error?) -> Void)
    func saveNew(_ goal: Goal, completionHandler: @escaping (Goal?, Error?) -> Void)
    func fetchAllExpenses(completionHandler: @escaping (Expenses?, Error?)-> Void)
    func fetchAllTransactions(_ completionHandler: @escaping (Transactions?, Error?) -> Void)
    func generateSavings(for action: PetAction, completionHandler: @escaping (Double?, Error?) -> Void)
}

class PCController : PCHandler {
    
    private(set) var ckEngine = CKEngine()
    private(set) var plaidEngine = PlaidEngine()
    
    
    func fetchAllGoals(completionHandler: @escaping (Goals?, Error?) -> Void) {
        
        self.ckEngine.fetchAllGoals { (result, error) in
            
            guard let fetchedGoals = result?.value else {
                completionHandler(nil, error)
                fatalError(error!.localizedDescription)
            }
            
            completionHandler(fetchedGoals, nil)
        }
        
    }
    
    func saveNew(_ goal: Goal, completionHandler: @escaping (Goal?, Error?) -> Void) {
        
        self.ckEngine.saveNew(goal) { (result, error) in
            guard let savedGoal = result?.value as? Goal else {
                completionHandler(nil, error)
                fatalError(error!.localizedDescription)
            }
            
            completionHandler(savedGoal, nil)
        }
        
        
    }
    
    func fetchAllTransactions(for goal: Goal, completionHandler: @escaping (Transactions?, Error?) -> Void) {
        
    }
    
    func fetchAllTransactions(_ completionHandler: @escaping (Transactions?, Error?) -> Void) {
        
        self.ckEngine.fetchAllTransactions { result, error in
            
            guard let transactions = result?.value else {
                completionHandler(nil, error)
                return
            }
            
            completionHandler(transactions, nil)
        }
        
        
    }
    
    func fetchAllExpenses(completionHandler: @escaping (Expenses?, Error?)-> Void){
        
        self.plaidEngine.fetchBankAccountTransactions(with: "test_us") { result in
            
            guard result.value is Expenses else {
                completionHandler(nil, result.value as? Error)
                return
            }
            
            completionHandler((result.value as! Expenses), nil)
        }
        
    }
    
    func generateSavings(for action: PetAction, completionHandler: @escaping (Double?, Error?) -> Void) {
        
        // Get all the goals
        self.fetchAllGoals { (goals, error) in
            
            guard let goals = goals else {
                // TODO: Handle Error
                return
            }
            
            // Run the savings function on each of the goals to get the Total Contribution Amount
            let tra = goals.reduce(0.0, { result, goal in
                result + goal.amountRemaining
            })
            let tca = goals.reduce(0.0, { result, goal in
                result + (tra / (goal.daysRemaining * goal.amountRemaining)) * Double(goal.priority.rawValue)
            })
            
            let adjustedAmount = tca * action.rawValue
            
            print("TOTAL CONTRIBUTION AMOUNT IS \(adjustedAmount)")
            
            completionHandler(adjustedAmount, nil)
        }
        
    }
    
    
    
    
    
    
}






























