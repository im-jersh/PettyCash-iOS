//
//  json.swift
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
    let longitude: Double
    
    let transType: String
    let locationScoreAddress: Double
    let locationScoreCity: Double
    let locationScoreState: Double
    let locationScoreZip: Double
    let nameScore: Double
    
    let categories : Array<String>
    let catID : String
    
    init(with json: [String:Any]) {
    
        account = json["_account"] as! String
        id = json["_id"] as! String
        amount = json["amount"] as! Double
        date = json["date"] as! String
        name = json["name"] as! String
        
        let meta = json["meta"] as! [String:Any]
        let location = meta["location"] as! [String:Any]
        let coordinates = location["coordinates"] as! [String:Any]
        address = location["address"] as! String
        city = location["city"] as! String
        state = location["state"] as! String
        zip = location["zip"] as! String
        storeNumber = location["store_number"] as! String
        latitude = coordinates["lat"] as! Double
        longitude = coordinates["lon"] as! Double
        pending = json["pending"] as! Bool
        let type = json["type"] as! [String:Any]
        transType = type["primary"] as! String
        categories = json["category"] as! Array<String>
        catID = json["category_id"] as! String
    
        let score = json["score"] as! [String:Any]
        let locationScore = score["location"] as! [String:Any]
        locationScoreAddress = locationScore["address"] as! Double
        locationScoreCity = locationScore["city"] as! Double
        locationScoreState = locationScore["state"] as! Double
        locationScoreZip = locationScore["zip"] as! Double
        nameScore = score["name"] as! Double
        
    }
}
