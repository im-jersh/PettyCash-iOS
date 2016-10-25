//
//  CreateGoalViewController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 10/25/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit

class CreateGoalViewController: UIViewController {

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
    
    
// MARK: Actions
    @IBAction func saveBarButtonWasTapped(_ sender: AnyObject) {
        
        // Validate inputs
        
        // Save the goal to CloudKit
        
        // Return to the list
        self.performSegue(withIdentifier: "unwindToGoalsListSegue", sender: nil)
    }
    
    @IBAction func cancelBarButtonWasTapped(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "unwindToGoalsListSegue", sender: nil)
    }

}
