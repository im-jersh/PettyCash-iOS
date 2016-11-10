//
//  GoalDetailViewController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 11/4/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit
import MBCircularProgressBar
import DZNEmptyDataSet

let transactionCellIdentifier = "transactionCell"

class GoalDetailViewController: UIViewController {
    
// MARK: Outlets
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var progressView: MBCircularProgressBarView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
// MARK: Properties
    var goal : Goal!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureView()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Animate the progress bar
        self.progressView.setValue(CGFloat(self.goal.progress * 100), animateWithDuration: 1)
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Change the progress view to show the contribution dollar amount
        self.progressView.showUnitString = false
        self.progressView.maxValue = CGFloat(self.goal.amount)
        self.progressView.decimalPlaces = 2
        self.progressView.value = CGFloat(self.goal.contributionAmount)
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // Revert the progress view to percent complete
        self.progressView.showUnitString = true
        self.progressView.maxValue = CGFloat(100)
        self.progressView.decimalPlaces = 1
        self.progressView.value = CGFloat(self.goal.progress * 100)
    }

}


// MARK: UITableView DataSource & Delegate
extension GoalDetailViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.goal.transactions?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a cell and get the corresponding Goal
        guard let cell = tableView.dequeueReusableCell(withIdentifier: transactionCellIdentifier) as? TransactionCell, let transaction = self.goal.transactions?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.descriptionLabel.text = transaction.description
        cell.dateLabel.text = transaction.date.formattedDate(.short)
        cell.amountLabel.text = transaction.formattedAmount

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "showGoalDetail", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


extension GoalDetailViewController {
    
    func configureView() {
        
        self.amountLabel.text = self.goal.formattedAmount
        self.progressView.value = CGFloat(0)
        self.descriptionLabel.text = self.goal.description
        
    }
    
    
}


// MARK: DZNEmptyDataSet Data Source & Delegate
extension GoalDetailViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        return UIImage(named: "piggy-bank")!
        
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = "No Contributions Yet"
        
        let attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18.0), NSForegroundColorAttributeName : UIColor.darkGray]
        
        return NSAttributedString(string: text, attributes: attributes)
        
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = "You have not made any contributions to this goal yet. Once you have, they will appear here."
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineBreakMode = .byWordWrapping
        
        let attributes = [NSFontAttributeName : UIFont.systemFont(ofSize: 14.0), NSForegroundColorAttributeName : UIColor.lightGray, NSParagraphStyleAttributeName : paragraph]
        
        return NSAttributedString(string: text, attributes: attributes)
        
    }
    
    
}















