//
//  CreateGoalOnboardingViewController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 12/2/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit

class CreateGoalOnboardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.setHidesBackButton(true, animated: false)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func createGoalButtonWasTapped(_ sender: Any) {
        
        let goalStoryboard = UIStoryboard(name: "Goals", bundle: nil)
        let navVC = goalStoryboard.instantiateViewController(withIdentifier: "createNewGoalNavigationController") as! UINavigationController
        navVC.topViewController?.navigationItem.leftBarButtonItem = nil
        
        self.present(navVC, animated: true, completion: nil)
    }
    
    @IBAction func unwindToGoalsList(segue: UIStoryboardSegue) {
    
        // A goal has been added. We should segue to the pet controller after recording the onboarding completion
        UserDefaults.standard.set(true, forKey: "onboarding-complete")
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.proceedToNormalFlow()
        }
        
    }
    
    func proceedToNormalFlow() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate, let window = appDelegate.window else {
            fatalError()
        }
        
        appDelegate.createMenuView()
        UIView.transition(with: window, duration: 1.0, options: UIViewAnimationOptions.transitionCrossDissolve, animations: { appDelegate.createMenuView() }, completion: nil)
    }

}
