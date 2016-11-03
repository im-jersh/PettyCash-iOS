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
    
    
    
}




















