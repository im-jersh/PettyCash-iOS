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
        request.fetchBankAccountBalance(with: "test_us")
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
    
    enum BaseURL {
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
                self.baseURL = "https://tartan.plaid.com/connect"
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
        
        func fetchBankAccountBalance(with accessToken: String){
            //Create URL String
            let urlString:String = "\(self.baseURL)?client_id=\(self.clientID)&secret=\(self.secret)&access_token=\(accessToken)"
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
                    //print(response ?? "Default")
                } catch {
                    print("Could not parse jSON")
                }
            }
            task.resume()

        }
        
    }
    
}




















