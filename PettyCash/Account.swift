//
//  Account.swift
//  PettyCash
//
//  Created by Emeka Okoye on 11/10/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation

typealias Accounts = [Account]

public struct Account {
    
    let id: String
    let item: String
    let user: String
    let balance: String //Just available for now
    let bank: String
    let meta: [String: Any]
    let type: String //Checkings or savings

    init(with json: [String:Any]) {
        id = json["_account"] as! String
        item = json["_item"] as! String
        user = json["_user"] as! String
        let availableBalance = json["balance"] as! [String:Any]
        balance = availableBalance["available"] as! String
        bank = json["institution_type"] as! String
        meta = json["meta"] as! [String: Any]
        type = json["subtype"] as! String
    }


}
