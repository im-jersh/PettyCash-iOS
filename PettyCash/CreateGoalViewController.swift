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
        guard self.validateForm() else {
            return
        }
        
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


extension Date {
    static func tomorrow() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
}






































