//
//  MenuViewController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 10/25/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit

enum MenuOption : Int {
    case pet
    case goals
    case expenses
    case settings
    
    var menuDescription : String {
        return String(describing: self)
    }
}

protocol MenuProtocol : class {
    func changeViewController(_ menu: MenuOption)
}

class MenuViewController: UITableViewController {
    
    var mainViewController : UIViewController!
    var goalsViewController : UIViewController!
    var expensesViewController : UIViewController!
    var settingsViewController : UIViewController!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = true

        // Create the view controllers that will be presented on menu selection
        self.createViewControllers()
        
        // A little trick to remove empty cells below cells that have content
        self.tableView.tableFooterView = UIView()
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
        return 4
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let menu = MenuOption(rawValue: indexPath.row) {
            self.changeViewController(menu)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}



extension MenuViewController {
    
    func createViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        self.goalsViewController = storyboard.instantiateViewController(withIdentifier: "GoalsNavController")
        self.expensesViewController = storyboard.instantiateViewController(withIdentifier: "ExpensesNavController")
        self.settingsViewController = storyboard.instantiateViewController(withIdentifier: "SettingsNavController")
    }
    
}


extension MenuViewController : MenuProtocol {
    
    func changeViewController(_ menu: MenuOption) {
        switch menu {
        case .pet:
            self.slideMenuController()?.changeMainViewController(self.mainViewController, close: true)
        case .goals:
            self.slideMenuController()?.changeMainViewController(self.goalsViewController, close: true)
        case .expenses:
            self.slideMenuController()?.changeMainViewController(self.expensesViewController, close: true)
        case .settings:
            self.slideMenuController()?.changeMainViewController(self.settingsViewController, close: true)
        }
    }
    
}

































