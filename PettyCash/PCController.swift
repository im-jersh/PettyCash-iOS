//
//  PettyCashController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 11/4/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation

protocol PettyCashDataNotifier {
    func pcController(_ controller: PCController, didFinishFetchingGoals goals: Goals)
}

protocol PCHandler {
    var delegate : PettyCashDataNotifier? { get }
    func fetchAllGoals()
    func fetchAllTransactions(for goal: Goal, completionHandler: (Transactions?, Error?) -> Void)
}

class PCController : PCHandler {
    
    private(set) var delegate : PettyCashDataNotifier?
    
    
    init(delegate: PettyCashDataNotifier? = nil) {
        self.delegate = delegate
    }
    
    func fetchAllGoals() {
        
        let ckengine = CKEngine()
        var goals = Goals()
        ckengine.fetchAllGoals { (result, error) in
            
            guard let fetchedGoals = result?.value else {
                fatalError(error!.localizedDescription)
            }
            
            goals = fetchedGoals
            self.delegate?.pcController(self, didFinishFetchingGoals: goals)
        }
        
    }
    
    func fetchAllTransactions(for goal: Goal, completionHandler: (Transactions?, Error?) -> Void) {
        
        
        
        
        
    }
    
    
    
    
}
