//
//  AddBankViewController.swift
//  PettyCash
//
//  Created by Emeka Okoye on 11/3/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit

class AddBankViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        //request.fetchExpensesFromBankAccount()
        
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func addBankAccountButtonWasTapped(_ sender: AnyObject) {
        
        guard let plaidLink = PLDLinkNavigationViewController(environment: PlaidEnvironment.tartan, product: .connect) else {
            fatalError("")
        }
        
        
        plaidLink.linkDelegate = self
        plaidLink.providesPresentationContextTransitionStyle = true
        plaidLink.definesPresentationContext = true
        plaidLink.modalPresentationStyle = UIModalPresentationStyle.custom
        self.present(plaidLink, animated: true, completion: nil)
        
    }

}


extension AddBankViewController: PLDLinkNavigationControllerDelegate {
    
    func linkNavigationContoller(_ navigationController: PLDLinkNavigationViewController!, didFinishWithAccessToken accessToken: String!) {
        print(accessToken)
        
        let request = plaidEngine(env: .Testing, secret: "test_secret", clientID: "test_id")
        request.fetchBankAccountTransactions(with: "test_us")
        self.dismiss(animated: true, completion: nil)
    }

    func linkNavigationControllerDidCancel(_ navigationController: PLDLinkNavigationViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func linkNavigationControllerDidFinish(withBankNotListed navigationController: PLDLinkNavigationViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
}


// MARK: Actions
extension AddBankViewController {
    
    enum BaseURL: String {
        case Production
        case Testing
    }
    
    class plaidEngine {
        
        let baseURL: String
        let secret: String
        let clientID: String
        
        init(env: BaseURL, secret: String, clientID: String){
            switch env {
            case .Production:
                self.baseURL = "https://api.plaid.com/"
            case .Testing:
                self.baseURL = "https://tartan.plaid.com/"
            }
            self.secret = secret
            self.clientID = clientID
        }
        
        func fetchExpensesFromBankAccount(){
            
            guard let url = URL(string: baseURL) else {
                print("Could not create URL")
                return
            }
            
            let urlRequest = URLRequest(url: url)
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: urlRequest, completionHandler: { (data, response,error) in
                print(response ?? "Default response")
                //print(error ?? "Default error")
            })
            task.resume()

        }
        
        func fetchBankAccountTransactions(with accessToken: String){
            //Create URL String
            let urlString:String = "\(self.baseURL)connect?client_id=\(self.clientID)&secret=\(self.secret)&access_token=\(accessToken)"
            guard let url = URL(string: urlString) else {
                print("Could not create URL")
                return
            }
            
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            let task = session.dataTask(with: url) { data, response, error in
                do {
                    let jsonResult = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as? NSDictionary
                    print("jsonResult: \(jsonResult!)")
                    guard let dataArray:[[String:AnyObject]] = jsonResult?.value(forKey: "transactions") as? [[String:AnyObject]] else { print("JSON ERROR"); return
                    }
                    let userTransactions = dataArray.map{Expense(expense: $0)}
                    for trans in userTransactions {
                        print(trans.amount)
                    }
                } catch {
                    print("Could not parse jSON")
                }
            }
            task.resume()

        }
        
    }
    
}

public struct Expense {
    
    let account: String
    let id: String
    let amount: Double
    let date: String
    let name: String
    let pending: Bool
    
    let address: String?
    let city: String?
    let state: String?
    let zip: String?
    let storeNumber: String?
    let latitude: Double?
    let longitude: Double?
    
    let transType: String?
    let locationScoreAddress: Double?
    let locationScoreCity: Double?
    let locationScoreState: Double?
    let locationScoreZip: Double?
    let nameScore: Double?
    
    let category:NSArray?
    
    public init(expense: [String:AnyObject]) {
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




















