//
//  GoalsViewController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 10/25/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class GoalsViewController: UIViewController {
    
// MARK: Outlets
    @IBOutlet weak var tableView: UITableView!
    
    
    
// MARK: Properties

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        self.tableView.tableFooterView = UIView()
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


// MARK: DZNEmptyDataSet Data Source & Delegate
extension GoalsViewController : DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
    
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = "Create a Goal to Get Started!"
        
        let attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 18.0), NSForegroundColorAttributeName : UIColor.darkGray]
        
        return NSAttributedString(string: text, attributes: attributes)
        
    }
    
    func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        
        let text = "Let's start by creating a goal. Before you know it, you'll be saving money and having fun doing so!"
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        paragraph.lineBreakMode = .byWordWrapping
        
        let attributes = [NSFontAttributeName : UIFont.systemFont(ofSize: 14.0), NSForegroundColorAttributeName : UIColor.lightGray, NSParagraphStyleAttributeName : paragraph]
        
        return NSAttributedString(string: text, attributes: attributes)
        
    }
    
    func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControlState) -> NSAttributedString! {
        
        let attributes = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: 17.0), NSForegroundColorAttributeName : UIColor.flatSkyBlue() ] as [String : Any]
        
        return NSAttributedString(string: "Let's Do It", attributes: attributes)
        
    }
    
    func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
        
        self.performSegue(withIdentifier: "addGoalSegue", sender: nil)
        
    }
    
    
}

























