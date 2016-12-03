//
//  PettyCashController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 11/4/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation

public let dataUpdateKey = "dataUpdateKey"

public enum PetAction : Double {
    case poop = 2.0
    case feed = 3.5
    case bathe = 10.0
    case treat = 5.5
    case groom = 7.7
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
    
    class func notifyDataObservers() {
        print("CLOUDKIT UPDATES ARE AVAILABLE")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: dataUpdateKey), object: self)
    }
    
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
            
            // calculate each goal's individual contribution amount and package it up with the goal
            let goalsWithICA : [(goal: Goal, ica: Double)] = goals.map { goal in
                let ica = (tra / (goal.daysRemaining * goal.amountRemaining)) * Double(goal.priority.rawValue) * action.rawValue
                return (goal, ica)
            }
            
            // Calculate the total contribution amount
            let tca = goalsWithICA.reduce(0.0, { result, gICA in
                return result + gICA.ica
            })
            print("TOTAL CONTRIBUTION AMOUNT IS \(tca)")
            
            // We now have our goals, their ICAs, and the TCA
            // We need to send our TCA to our contribution API for account transfer
            MockContributionAPI.transfer(funds: tca) { result in
                
                // Let's check our results
                guard let dict = result.value as? [String : Any], let transferredAmount = dict["transfer-amount"] as? Double, let toAccount = dict["to-account"] as? String, let fromAccount = dict["from-account"] as? String else {
                    completionHandler(nil, NSError(domain: "mockAPI", code: -1, userInfo: nil))
                    return
                }
                
                // Double check the amount requested to transfer was the amount that actually was transferred
                guard tca == transferredAmount else {
                    completionHandler(nil, NSError(domain: "mockAPI", code: -2, userInfo: nil))
                    return
                }
                
                // Package up the result data and send it over to the CKEngine for saving to CloudKit
                let prepData = CKContributionData(goals: goalsWithICA, amount: transferredAmount, toAccount: toAccount, fromAccount: fromAccount, tca: tca, action: action)
                
                self.ckEngine.processTotalContributionAmount(in: prepData) { result, error in
                    
                    // Check the result
                    guard let result = result?.value as? Bool else {
                        completionHandler(nil, NSError(domain: "cloudkit", code: -1, userInfo: nil))
                        return
                    }
                    
                    guard result else {
                        completionHandler(nil, NSError(domain: "cloudkit", code: -1, userInfo: nil))
                        return
                    }
                    
                    // Notify the caller
                    completionHandler(tca, nil)
                    
                    // Notify any data observers of the updates
                    PCController.notifyDataObservers()
                    
                }
                
            }
            
        }
        
    }
    
    
    class func fullReset(completionHandler: @escaping () -> Void) {
        
        // Reset settings and app data stored in UserDefaults
        UserDefaults.standard.set(false, forKey: "onboarding-complete")
        
        // Reset CloudKit
        CKEngine.resetPrivateDatabase {
            PCController.notifyDataObservers()
            completionHandler()
        }
        
    }
    
    
}






























