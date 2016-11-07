//
//  PlaidEngine.swift
//  PettyCash
//
//  Created by Emeka Okoye on 11/7/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation


enum BaseURL: String {
    case production
    case testing
}

class PlaidEngine {
    
    let baseURL: String
    let secret: String
    let clientID: String
    
    init(env: BaseURL = .testing, secret: String = "test_secret", clientID: String = "test_id"){
        switch env {
        case .production:
            self.baseURL = "https://api.plaid.com/"
        case .testing:
            self.baseURL = "https://tartan.plaid.com/"
        }
        self.secret = secret
        self.clientID = clientID
    }
    
    func fetchExpensesFromBankAccount() {
        
        guard let url = URL(string: baseURL) else {
            print("Could not create URL")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response,error) in
            print(response ?? "Default response")
        })
        task.resume()
        
    }
    
    func fetchBankAccountTransactions(with accessToken: String,with completionHandler: @escaping (PlaidResult<Any>) -> Void) {
        //Create URL String
        let urlString:String = "\(self.baseURL)connect?client_id=\(self.clientID)&secret=\(self.secret)&access_token=\(accessToken)"
        guard let url = URL(string: urlString) else {
            print("Could not create URL")
            return
        }
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        //var userTransactions : Expenses = []
        let task = session.dataTask(with: url) { data, response, error in
            do {
                let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                
                if let error = error {
                    let error = NSError(domain: "plaidEngine", code: -1, userInfo: nil)
                    completionHandler(PlaidResult(result: error))
                    return
                }
                
                // Check the response code
                
                guard let transactionsArray = jsonResult?.value(forKey: "transactions") as? [[String:Any]] else {
                    let error = NSError(domain: "plaidEngine", code: -1, userInfo: nil)
                    completionHandler(PlaidResult(result: error))
                    return
                }
            
                let transactions = transactionsArray.map{ Expense(with: $0) }
                for trans in transactions {
                    print(trans.amount)
                }
                
                completionHandler(PlaidResult(result: transactions))
                
            } catch {
                print("Could not parse jSON")
            }
        }
        task.resume()
    }
    
}

public class PlaidResult<T> {
    
    var value : T?
    
    init(result: T?) {
        self.value = result
    }
    
}











