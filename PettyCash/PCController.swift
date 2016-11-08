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
    func pcController(_ controller: PCHandler, didFinishFetchingTransactions transactions: Transactions)
}

// This extension essentially makes the included methods optional for any comforming type
//extension PettyCashDataNotifier {
//    func pcController(_ controller: PCHandler, didFinishFetchingGoals goals: Goals) { }
//    func pcController(_ controller: PCHandler, didSaveNewGoal goal: Goal) { }
//}

protocol PCHandler {
    var delegate : PettyCashDataNotifier? { get }
    func fetchAllGoals()
    func fetchAllTransactions(for goal: Goal, completionHandler: @escaping (Transactions?, Error?) -> Void)
    func saveNew(_ goal: Goal)
    func fetchAllTransactions(_ completionHandler: @escaping (Transactions?, Error?) -> Void)
}

class PCController : PCHandler {
    
    private(set) var delegate : PettyCashDataNotifier?
    private(set) var ckEngine = CKEngine()
    
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
    
    func saveNew(_ goal: Goal) {
        
        self.ckEngine.saveNew(goal) { (result, error) in
            guard let savedGoal = result?.value as? Goal else {
                fatalError(error!.localizedDescription)
            }
            
            self.delegate?.pcController(self, didSaveNewGoal: savedGoal)
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
    
    
    
    
}






























