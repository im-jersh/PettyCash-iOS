//
//  SettingsViewController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 10/25/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

// MARK: Outlets
    @IBOutlet weak var testDataButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    
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
    @IBAction func menuBarButtonWasTapped(_ sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    
    @IBAction func useTestDataButtonWasTapped(_ sender: AnyObject) {
        self.confirmDummyDateInsertion()
    }
    
    @IBAction func resetButtonWasTapped(_ sender: AnyObject) {
        
    }
    
    
}


extension SettingsViewController {
    
    fileprivate func confirmDummyDateInsertion() {
        
        let alertController = UIAlertController(title: "WARNING", message: "Using dummy data will permanently delete all goals and savings transactions associated with those goals.", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in }
        let confirmAction = UIAlertAction(title: "I Understand", style: .destructive) { action in
            
            let confirmController = UIAlertController(title: "Last Chance", message: "This action can't be reversed. This is your last warning.", preferredStyle: .alert)
            let dummyDataAction = UIAlertAction(title: "Use Dummy Data", style: .destructive, handler: { alert in
                CKEngine.seedDummyData()
            })
            
            confirmController.addAction(cancelAction)
            confirmController.addAction(dummyDataAction)
            
            self.present(confirmController, animated: true, completion: nil)
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
