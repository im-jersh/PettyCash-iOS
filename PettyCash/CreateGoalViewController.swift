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
    
    
// MARK: Properties
    fileprivate(set) var pcHandler : PCHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the form
        self.buildForm()
        
        self.pcHandler = PCController(delegate: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        // Check to see if the sender is a Goal. If it is, we should pass that object back to the Goal List Controller
        if sender is Goal && segue.identifier == "unwindToGoalsListSegue" {
            if let destination = segue.destination as? GoalsViewController {
                destination.addGoalToList(sender as! Goal)
            }
        }
    }
    
    
    
// MARK: Actions
    @IBAction func saveBarButtonWasTapped(_ sender: AnyObject) {
        
        // Validate inputs
        guard self.validateForm() else {
            // Form will display errors internally
            return
        }
        
        // Create and save the goal to CloudKit
        guard let goal = self.extractFormValues() else {
            return
        }
        
        self.pcHandler.saveNew(goal)
    
    }
    
    @IBAction func cancelBarButtonWasTapped(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "unwindToGoalsListSegue", sender: nil)
    }

}


// MARK: Eureka Form
extension CreateGoalViewController {
    
    func buildForm() {
        
        form = Section()
            <<< TextRow(GoalKey.description.rawValue) { row in
                
                // UI
                row.title = "Goal *"
                row.placeholder = "Description"
                
                // Validation
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnDemand
            }.onRowValidationChanged { cell, row in
                cell.textLabel?.textColor = .red
            }
            <<< DecimalRow(GoalKey.amount.rawValue) { row in
                
                // UI
                row.title = "Amount *"
                row.placeholder = "$100.00"
                
                // Format the value
                row.useFormatterDuringInput = true
                let formatter = CurrencyFormatter()
                formatter.locale = .current
                formatter.numberStyle = .currency
                row.formatter = formatter
                
                // Validation
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnDemand
            }.onRowValidationChanged { cell, row in
                cell.textLabel?.textColor = .red
            }
        +++ Section(footer: "You can optionally add a future end date that you would like to have the full amount saved by.")
            <<< SwitchRow("Set End Date"){ row in
                
                // UI
                row.title = row.tag
                row.value = false
            }
            <<< DateInlineRow(GoalKey.endDate.rawValue) { row in
                
                // UI
                row.title = "End Date"
                
                // Conditional
                row.hidden = .function(["Set End Date"], { form -> Bool in
                    let row: RowOf<Bool>! = form.rowBy(tag: "Set End Date")
                    return row.value ?? false == false
                })
                
                // Validation
                row.add(rule: RuleGreaterThan(min: Date.tomorrow()))
                row.validationOptions = .validatesOnChange
            }.cellUpdate { cell, row in
                if !row.isValid {
                    cell.textLabel?.text = "Date Must Be In Future"
                    cell.textLabel?.textColor = .red
                }
            }
        +++ Section(footer: "* Required Field")
            <<< SegmentedRow<Priority>(GoalKey.priority.rawValue) { row in
                
                // UI
                row.title = "Priority *"
                row.options = [Priority.low, Priority.medium, Priority.high]
                row.value = Priority.low
            }
        
    }
    
    func validateForm() -> Bool {
        
        return self.form.validate().isEmpty
        
    }
    
    func extractFormValues() -> Goal? {
        
        // Get all the values as a dictionary
        let formValuesDictionary = self.form.values(includeHidden: false)
        
        // Extract the required values
        guard let description = formValuesDictionary[GoalKey.description.rawValue] as? String, let amount = formValuesDictionary[GoalKey.amount.rawValue] as? Double, let priority = formValuesDictionary[GoalKey.priority.rawValue] as? Priority, let endDateIsVisible = formValuesDictionary["Set End Date"] as? Bool else {
            // We have an issue with the form inputs. Maybe the validation failed somehow?
            return nil
        }
        
        // See if the the end date field was shown
        if endDateIsVisible {
            // The user made the end date visible. However, they could have left the row empty. Either way, the endDate property of a Goal is optional so we can just assign whatever value is in the dictionary directly to the Goal
            let endDate = formValuesDictionary[GoalKey.endDate.rawValue] as? Date
            return Goal(with: description, startDate: Date(), amount: amount, priority: priority, andEndDate: endDate)
        }
        
        return Goal(with: description, startDate: Date(), amount: amount, priority: priority, andEndDate: nil)
    }
    
}

// MARK: PettyCashDataNotifier 
extension CreateGoalViewController : PettyCashDataNotifier {
    
    func pcController(_ controller: PCHandler, didSaveNewGoal goal: Goal) {
        // Return to the list
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "unwindToGoalsListSegue", sender: goal)
        }
    }
    
    func pcController(_ controller: PCHandler, didFinishFetchingGoals goals: Goals) {
        
    }
    
    func pcController(_ controller: PCHandler, didFinishFetchingTransactions transactions: Transactions) {
        
    }
    
}


class CurrencyFormatter : NumberFormatter, FormatterProtocol {
    override func getObjectValue(_ obj: AutoreleasingUnsafeMutablePointer<AnyObject?>?, for string: String, range rangep: UnsafeMutablePointer<NSRange>?) throws {
        guard obj != nil else { return }
        let str = string.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        obj?.pointee = NSNumber(value: (Double(str) ?? 0.0)/Double(pow(10.0, Double(minimumFractionDigits))))
    }
    
    func getNewPosition(forPosition position: UITextPosition, inTextInput textInput: UITextInput, oldValue: String?, newValue: String?) -> UITextPosition {
        return textInput.position(from: position, offset:((newValue?.characters.count ?? 0) - (oldValue?.characters.count ?? 0))) ?? position
    }
}









































