//
//  Expense.swift
//  PettyCash
//
//  Created by Emeka Okoye on 11/6/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation

typealias Expenses = [Expense]

public struct Expense {
    
    let account: String
    let id: String
    let amount: Double
    let date: String
    let name: String
    let pending: Bool
    
    let address: String
    let city: String
    let state: String
    let zip: String
    let storeNumber: String
    let latitude: Double
    let longitude: Double?
    
    let transType: String?
    let locationScoreAddress: Double?
    let locationScoreCity: Double?
    let locationScoreState: Double?
    let locationScoreZip: Double?
    let nameScore: Double?
    
    let category:NSArray?
    
    public init(expense: [String:Any]) {
        let meta = expense["meta"] as! [String:AnyObject]
        let location = meta["location"] as? [String:AnyObject]
        let coordinates = location?["coordinates"] as? [String:AnyObject]
        let score = expense["score"] as? [String:AnyObject]
        let locationScore = score?["location"] as? [String:AnyObject]
        let type = expense["type"] as? [String:AnyObject]
        
        account = expense["_account"] as! String
        id = expense["_id"] as! String
        amount = expense["amount"] as! Double
        date = expense["date"] as! String
        name = expense["name"] as! String
        pending = expense["pending"] as! Bool
        
        address = location?["address"] as? String
        city = location?["city"] as? String
        state = location?["state"] as? String
        zip = location?["zip"] as? String
        storeNumber = location?["store_number"] as? String
        latitude = coordinates?["lat"] as? Double
        longitude = coordinates?["lon"] as? Double
        
        transType = type?["primary"] as? String
        locationScoreAddress = locationScore?["address"] as? Double
        locationScoreCity = locationScore?["city"] as? Double
        locationScoreState = locationScore?["state"] as? Double
        locationScoreZip = locationScore?["zip"] as? Double
        nameScore = score?["name"] as? Double
        
        category = expense["category"] as? NSArray
    }
}
