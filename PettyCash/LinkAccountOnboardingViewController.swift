//
//  LinkAccountOnboardingViewController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 12/2/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit

class LinkAccountOnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }
    
    @IBAction func linkAccountButtonWasTapped(_ sender: AnyObject) {
        
        guard let plaidLink = PLDLinkNavigationViewController(environment: PlaidEnvironment.tartan, product: .connect) else {
            fatalError("")
        }
        
        plaidLink.linkDelegate = self
        plaidLink.providesPresentationContextTransitionStyle = true
        plaidLink.definesPresentationContext = true
        plaidLink.modalPresentationStyle = UIModalPresentationStyle.custom
        //self.present(plaidLink, animated: true, completion: nil)
        
        self.performSegue(withIdentifier: "createGoalOnboardingSegue", sender: self)
        
    }
    

}

extension LinkAccountOnboardingViewController: PLDLinkNavigationControllerDelegate {
    
    func linkNavigationContoller(_ navigationController: PLDLinkNavigationViewController!, didFinishWithAccessToken accessToken: String!) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func linkNavigationControllerDidCancel(_ navigationController: PLDLinkNavigationViewController!) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func linkNavigationControllerDidFinish(withBankNotListed navigationController: PLDLinkNavigationViewController!) {
        print("Do we come here?")
        self.dismiss(animated: true, completion: nil)
    }
    
}
