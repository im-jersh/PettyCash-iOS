//
//  ExpensesViewController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 10/25/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit
import FTIndicator

fileprivate let expenseRowIdentifier = "ExpenseRowIdentifier"
fileprivate let loadingIndicatorMessage = "Loading Expenses"

class ExpensesViewController: UIViewController {
    
    var pcHandler : PCHandler!
    
    @IBOutlet weak var tableView: UITableView!
    
    /*fileprivate var expenses : Expenses = Expenses() {
        didSet {
            self.tableView.reloadData()
        }
    }*/
    var expenses : Expenses = Expenses() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        self.tableView.tableFooterView = UIView()
        
        self.pcHandler = PCController()
        self.fetchAll()
        
        //self.initExpenses()
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
        if let destination = segue.destination as? ExpensesViewController {
            destination.expenses = self.expenses
        }
    }
    */
    
    
// MARK: Actions
    @IBAction func menuBarButtonWasTapped(_ sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }


}

extension ExpensesViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.expenses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a cell and get the corresponding Goal
        guard let cell = tableView.dequeueReusableCell(withIdentifier: expenseRowIdentifier) as? ExpenseCell else {
            return UITableViewCell()
        }
        let expense = self.expenses[indexPath.row]
        // Configure the cell
//        cell.expenseDateLabel.text = "Date: " + expense.date
//        cell.expenseAmountLabel.text = "\(expense.amount)"
        cell.textLabel?.text = String(expense.amount)
        
        return cell
    }
}

extension ExpensesViewController {
    
    func fetchAll(){
        FTIndicator.showProgressWithmessage(loadingIndicatorMessage, userInteractionEnable: false)
        self.pcHandler.fetchAllExpenses() { expenses, error in
            
            DispatchQueue.main.async {
                FTIndicator.dismissProgress()
            }
            
            guard let expenses = expenses else {
                //TODO: Handle error
                return
            }
            self.expenses = expenses
        }
    }
    
//    
//    public func initExpenses(){
//        
//        let expenseDict : [String: Any] = [
//            "account":"acc",
//            "id":"",
//            "amount":0.0,
//            "date":"date",
//            "name":"Bob",
//            "pending":true
//        ]
//        let testExpense = Expense(expense: expenseDict)
//        addExpenseToList(testExpense)
//    }
//    
//    public func addExpenseToList(_ expense: Expense) {
//        self.expenses.append(expense)
//    }
    
}


    


