//
//  AllContributionsTableViewController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 11/7/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import FTIndicator
import ChameleonFramework

fileprivate let rowIdentifier = "contributionCellIdentifier"
fileprivate let loadingIndicatorMessage = "Loading All Goal Contributions"

class AllContributionsTableViewController: UITableViewController {
    

    var pcHandler : PCHandler! = PCController()
    var contributions = Transactions() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.fetchAllContributions()
        
        self.tableView.tableFooterView = UIView()
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 100
        
        self.refreshControl?.addTarget(self, action: #selector(AllContributionsTableViewController.fetchAllContributions), for: UIControlEvents.valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.contributions.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: rowIdentifier, for: indexPath) as? TransactionCell else {
            return UITableViewCell()
        }
        let contribution = self.contributions[indexPath.row]
        
        cell.descriptionLabel.text = contribution.description
        cell.dateLabel.text = contribution.date.formattedDate(.short, time: .short)
        cell.amountLabel.text = contribution.formattedAmount

        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension AllContributionsTableViewController {
    
    func fetchAllContributions() {
        FTIndicator.showProgressWithmessage(loadingIndicatorMessage, userInteractionEnable: false)
        self.pcHandler.fetchAllTransactions { transactions, error in
            
            DispatchQueue.main.async {
                FTIndicator.dismissProgress()
            }
            
            guard let transactions = transactions else {
                // Handle error 
                return
            }
            
            // Sort the contributions by descending date
            self.contributions = transactions.sorted(by: { $0.date > $1.date })
        }
    }
    
}



extension AllContributionsTableViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        return UIImage(named: "piggy-bank")!
        
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = "No Contributions Yet"
        
        let attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18.0), NSForegroundColorAttributeName : UIColor.darkGray]
        
        return NSAttributedString(string: text, attributes: attributes)
        
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = "It doesn't look like you have any contributions just yet. Taking care of your pet will make contributions toward your goals and will populate this list."
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineBreakMode = .byWordWrapping
        
        let attributes = [NSFontAttributeName : UIFont.systemFont(ofSize: 14.0), NSForegroundColorAttributeName : UIColor.lightGray, NSParagraphStyleAttributeName : paragraph]
        
        return NSAttributedString(string: text, attributes: attributes)
        
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        
        let attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17.0), NSForegroundColorAttributeName : UIColor.flatLime() ] as [String : Any]
        
        return NSAttributedString(string: "Refresh", attributes: attributes)
        
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        
        self.fetchAllContributions()
        
    }

    
}
































