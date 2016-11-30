//
//  MockContributionAPI.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 11/28/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation

final class MockContributionAPI {
    
    static func transfer(funds amount: Double, completion: (Result<Any>) -> Void) {
        
        // Let's just make a simple dictionary for right now to mock a json retun from our API
        let dict : [String : Any] = ["transfer-amount" : amount, "from-account" : "**** 4040", "to-account" : "**** 8080"]
        
        completion(Result(result: dict))
    }
    
}

public class Result<T> {
    
    var value : T?
    
    init(result: T?) {
        self.value = result
    }
    
}
