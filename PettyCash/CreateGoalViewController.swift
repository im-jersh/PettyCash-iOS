//
//  CreateGoalViewController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 10/25/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit
import Eureka

class CreateGoalViewController : FormViewController {
    
// MARK: Outlets
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the form
        self.buildForm()
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


// MARK: Eureka Form
extension CreateGoalViewController {
    
    func buildForm() {
        
        self.form = Section("Section 1")
            <<< TextRow(GoalKey.description.rawValue) { row in
                row.title = "Goal"
                row.placeholder = "Description"
            }
            <<< DecimalRow(GoalKey.amount.rawValue) { row in
                row.title = "Amount"
                row.placeholder = "$$$"
            }
        +++ Section("Section 2")
            <<< DateInlineRow(GoalKey.endDate.rawValue) { row in
                row.title = "End Date"
                row.placeholder = "Optional"
            }
        +++ Section("Section 3")
            <<< SegmentedRow(GoalKey.priority.rawValue) { row in
                row.title = "Priority"
                row.options = ["Low", "Medium", "High"]
                row.value = "Low"
            }
        
    }
    
}











































