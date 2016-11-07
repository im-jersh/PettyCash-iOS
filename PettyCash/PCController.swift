//
//  PettyCashController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 11/4/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation

protocol PettyCashDataNotifier {
    func pcController(_ controller: PCHandler, didFinishFetchingGoals goals: Goals)
    func pcController(_ controller: PCHandler, didSaveNewGoal goal: Goal)
}

// This extension essentially makes the included methods optional for any comforming type
//extension PettyCashDataNotifier {
//    func pcController(_ controller: PCHandler, didFinishFetchingGoals goals: Goals) { }
//    func pcController(_ controller: PCHandler, didSaveNewGoal goal: Goal) { }
//}

protocol PCHandler {
    var delegate : PettyCashDataNotifier? { get }
    func fetchAllGoals()
    func fetchAllTransactions(for goal: Goal, completionHandler: (Transactions?, Error?) -> Void)
    func saveNew(_ goal: Goal)
    func fetchAllExpenses(completionHandler: @escaping (Expenses?, Error?)-> Void)
}

class PCController : PCHandler {
    
    private(set) var delegate : PettyCashDataNotifier?
    private(set) var ckEngine = CKEngine()
    private(set) var plaidEngine = PlaidEngine()
    
    init(delegate: PettyCashDataNotifier? = nil) {
        self.delegate = delegate
    }
    
    func fetchAllGoals() {
        
        var goals = Goals()
        self.ckEngine.fetchAllGoals { (result, error) in
            
            guard let fetchedGoals = result?.value else {
                fatalError(error!.localizedDescription)
            }
            
            goals = fetchedGoals
            self.delegate?.pcController(self, didFinishFetchingGoals: goals)
        }
        
    }
    
    func fetchAllTransactions(for goal: Goal, completionHandler: (Transactions?, Error?) -> Void) {
        
        
        
        
        
    }
    
    func saveNew(_ goal: Goal) {
        
        self.ckEngine.saveNew(goal) { (result, error) in
            guard let savedGoal = result?.value as? Goal else {
                fatalError(error!.localizedDescription)
            }
            
            self.delegate?.pcController(self, didSaveNewGoal: savedGoal)
        }
        
        
    }
    
    
    func fetchAllExpenses(completionHandler: @escaping (Expenses?, Error?)-> Void){
        
        self.plaidEngine.fetchBankAccountTransactions(with: "test_us") { result in
            
            guard result.value is Expenses else {
                completionHandler(nil, result.value as? Error)
                return
            }
            
            completionHandler(result.value as! Expenses, nil)
        }
        
    }
    
    
    
    
    
    
    
    
}
