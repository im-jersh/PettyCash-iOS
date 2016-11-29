//
//  ExpensesViewController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 10/25/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit
import FTIndicator
import ChameleonFramework
import Charts

fileprivate let expenseRowIdentifier = "ExpenseRowIdentifier"
fileprivate let loadingIndicatorMessage = "Loading Expenses"

class ExpensesViewController: UIViewController {
    
    var pcHandler : PCHandler!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    //@IBOutlet var chartView: UIView!

    @IBOutlet var pieChartView: PieChartView!
    
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
    
    var isExpanded = Set<IndexPath>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // size the supplementary view and add to view
        self.pieChartView.frame = self.view.frame
        self.customizePieChart()
        self.view.insertSubview(self.pieChartView, aboveSubview: self.tableView)
        
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
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.pieChartView.animate(xAxisDuration: 0.0, yAxisDuration: 1.0)
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

    @IBAction func segmentControlIndexDidChange(_ sender: Any) {
        
        guard let sender = sender as? UISegmentedControl else {
            return
        }
        
        switch sender.selectedSegmentIndex {
        case 0:
            self.view.insertSubview(self.pieChartView, aboveSubview: self.tableView)
        case 1:
            self.pieChartView.removeFromSuperview()
        default:
            return
        }
        
        
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
        cell.expenseAmountLabel.backgroundColor = expense.amount < 0 ? UIColor.flatLime() : UIColor.flatRed()
        cell.expenseDateLabel.text = expense.date
        cell.expenseNameLabel.text = expense.name
        cell.expenseAmountLabel.text = expense.amount.formattedCurrency
        if self.isExpanded.contains(indexPath) {
            cell.expenseCategoryLabel.isHidden = false
        } else {
            cell.expenseCategoryLabel.isHidden = true
        }
        cell.expenseCategoryLabel.text = "Categories: " + expense.categories.joined(separator: ", ")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.cellForRow(at: indexPath) as? ExpenseCell else {
            return
        }
        
        tableView.beginUpdates()
        
        if self.isExpanded.contains(indexPath) {
            self.isExpanded.remove(indexPath)
            UIView.animate(withDuration: 0.4) {
                cell.expenseCategoryLabel.isHidden = true
            }
        } else {
            self.isExpanded.insert(indexPath)
            UIView.animate(withDuration: 0.4) {
                cell.expenseCategoryLabel.isHidden = false
            }
        }
        
        //tableView.deselectRow(at: indexPath, animated: true)
        tableView.endUpdates()
        
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

extension ExpensesViewController {
    func customizePieChart(){
        //Call method to get all expense categories
        self.getExpenseCategories()
        
        let ys1 = Array(1..<10).map { x in return sin(Double(x) / 2.0 / 3.141 * 1.5) * 100.0 }
        
        let yse1 = ys1.enumerated().map { x, y in return PieChartDataEntry(value: y, label: String(x)) }
        
        let data = PieChartData()
        let ds1 = PieChartDataSet(values: yse1, label: "Hello")
        
        ds1.colors = ChartColorTemplates.vordiplom()
        
        data.addDataSet(ds1)
        
        //self.pieChartView.centerAttributedText = centerText
        
        self.pieChartView.data = data
        self.pieChartView.usePercentValuesEnabled = true
        let myShadow = NSShadow()
        myShadow.shadowBlurRadius = 1
        myShadow.shadowOffset = CGSize(width: 1, height: 1)
        myShadow.shadowColor = UIColor.gray
        let centerText: NSAttributedString = NSAttributedString(string: "Expense Categories", attributes: [NSFontAttributeName: UIFont(name: "Verdana-Italic", size: 17.0)!, NSShadowAttributeName: myShadow])
        self.pieChartView.centerAttributedText = centerText
    }
    
    func getExpenseCategories(){
//        var expenseCategories: [String]
//        for expense in self.expenses {
//            if expense.categories.isEmpty {
//                continue
//            } else {
//                conti
//            }
//        }
        
    }
    
    
}


    


