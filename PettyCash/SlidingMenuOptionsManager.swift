//
//  SlidingMenuOptionsManager.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 10/14/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation
import UIKit

enum SVMenuOptions {
    case Pet
    case Goals
    case Expenses
    case Settings
    
    var menuTitle: String {
        
        return String(describing: self)
    }
    
}


class SVMenuOptionManager: NSObject {
    
    static let sharedInstance = SVMenuOptionManager()
    
    let slidingPanel: SVSlidingPanelViewController
    
    
    override init() {
        
        self.slidingPanel = SVSlidingPanelViewController()
        
        super.init()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let  lefthamburgerMenuController : SVMenuViewController = storyboard.instantiateViewController(withIdentifier: "SVMenuViewController") as! SVMenuViewController
        
        let  righthamburgerMenuController : SVMenuViewController = storyboard.instantiateViewController(withIdentifier: "SVMenuViewController") as! SVMenuViewController
        
        
        let  detailController : SVDetailViewController = storyboard.instantiateViewController(withIdentifier: "SVDetailViewController") as! SVDetailViewController
        let navigation = UINavigationController(rootViewController:detailController)
        
        self.slidingPanel.leftPanel = lefthamburgerMenuController
        self.slidingPanel.centerPanel = navigation
        //        self.slidingPanel.rightPanel = righthamburgerMenuController
        
        
        lefthamburgerMenuController.menuSelectionClosure = {[weak self](selectedMenuOption: SVMenuOptions, animated:Bool) in
            
            self?.showScreenForMenuOption(menuOntion: selectedMenuOption, animation: animated)
        }
        
        righthamburgerMenuController.menuSelectionClosure = {[weak self](selectedMenuOption: SVMenuOptions, animated:Bool) in
            
            self?.showScreenForMenuOption(menuOntion: selectedMenuOption, animation: animated)
        }
        
        
    }
    
    func showScreenForMenuOption(menuOntion: SVMenuOptions, animation animated: Bool) {
        
        
        let navigationController = self.slidingPanel.centerPanel as! UINavigationController
        let detailController = navigationController.viewControllers.first as! SVDetailViewController
        detailController.logoImageView.image = UIImage(named: menuOntion.menuTitle)
        
        self.slidingPanel.showCenterPanel(animated: animated)
        
    }
}
