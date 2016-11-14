//
//  GoalsViewController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 10/25/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit
import DZNEmptyDataSet
import FTIndicator

fileprivate let goalRowIdentifier = "GoalRowIdentifier"
fileprivate let loadingIndicatorMessage = "Loading Goals"

class GoalsViewController: UIViewController {
    
// MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
// MARK: Properties
    fileprivate private(set) var pcHandler : PCHandler! = PCController()
    fileprivate var goals : Goals = Goals() {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.refreshControl.endRefreshing()
                self.navigationItem.title = self.goals.reduce(0.0, { result, goal in result + goal.contributionAmount }).formattedCurrency + " Saved"
            }
        }
    }
    fileprivate lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(GoalsViewController.handleRefresh), for: UIControlEvents.valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to Refresh")
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fetch the goals
        self.fetchAllGoals()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 120
        self.tableView.tableFooterView = UIView()
        self.tableView.addSubview(self.refreshControl)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleRefresh(refreshControl: UIRefreshControl) {
        self.fetchAllGoals()
    }
    
// MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "showGoalDetail" {
            guard let indexPath = sender as? IndexPath, let destVC = segue.destination as? GoalDetailViewController else {
                return
            }
            destVC.goal = self.goals[indexPath.row]
        }
    }
    
    @IBAction func unwindToGoalsList(segue: UIStoryboardSegue) {
        
    }
    
    
// MARK: Actions
    @IBAction func menuBarButtonWasTapped(_ sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func addGoalButtonWasTapped(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "addGoalSegue", sender: nil)
    }
    

}


// MARK: UITableView DataSource & Delegate
extension GoalsViewController : UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Create a cell and get the corresponding Goal
        guard let cell = tableView.dequeueReusableCell(withIdentifier: goalRowIdentifier) as? GoalCell else {
            return UITableViewCell()
        }
        let goal = self.goals[indexPath.row]
        
        // Configure the cell
        cell.goalDescriptionLabel.text = goal.description
        cell.goalProgressBar.value = CGFloat(goal.progress * 100)
        if let endDate = goal.endDate?.formattedDate(.short) {
            cell.goalEndDateLabel.text = "End Date: " + endDate
        } else { cell.goalEndDateLabel.text = "" }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "showGoalDetail", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}


// MARK: DZNEmptyDataSet Data Source & Delegate
extension GoalsViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        
        return UIImage(named: "piggy-bank")!
        
    }
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = "You Don't Have Any Goals Yet"
        
        let attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18.0), NSForegroundColorAttributeName : UIColor.darkGray]
        
        return NSAttributedString(string: text, attributes: attributes)
        
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = "Let's start by creating a goal. Tap the '+' in the top right. Before you know it, you'll be saving money and having fun doing it!\n\nIf your existing goals do not appear here, hit the refresh button below."
        
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
        
        self.fetchAllGoals()
        
    }
    
}


// MARK: Public & Private Methods
extension GoalsViewController {
    
    fileprivate func fetchAllGoals() {
        
        FTIndicator.showProgressWithmessage(loadingIndicatorMessage, userInteractionEnable: false)
        self.pcHandler.fetchAllGoals { (goals, error) in
            
            DispatchQueue.main.async {
                FTIndicator.dismissProgress()
            }
            
            guard let goals = goals else {
                // TODO: Handle Error
                return
            }
            
            self.goals = goals
        }
        
    }
    
    public func addGoalToList(_ goal: Goal) {
        self.goals.append(goal)
    }
    
    public func dummyData() {
        
        let testGoal = Goal(with: "Test Goal #1", startDate: Date(), amount: 100.00, priority: Priority.low, andEndDate: Date.tomorrow())
        let testTransaction = Transaction(for: 37.0, withDescription: "Some random goal contribution")
        
        testGoal.addTransaction(testTransaction)
        
        self.goals.append(testGoal)
        
    }
    
}






























