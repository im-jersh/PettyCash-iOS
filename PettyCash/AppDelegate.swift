//
//  AppDelegate.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 9/8/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        Plaid.sharedInstance().setPublicKey("228476691a1099d884060513432690")
        //Plaid.sharedInstance().setPublicKey("test_key")
        
        // Check to see if this application has been setup yet
        UserDefaults.standard.bool(forKey: "onboarding-complete") ? self.createMenuView() : self.onboarding()
        
        
        return true
    }

}


extension AppDelegate {
    
    func createMenuView() {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let petViewController = storyboard.instantiateViewController(withIdentifier: "PetViewController") as! PetViewController
        let menuViewController = storyboard.instantiateViewController(withIdentifier: "MenuViewController") as! MenuViewController
        
        menuViewController.mainViewController = petViewController
        
        let slideMenuController = SlideMenuController(mainViewController: petViewController, leftMenuViewController: menuViewController)
        slideMenuController.automaticallyAdjustsScrollViewInsets = true
        slideMenuController.delegate = petViewController
        self.window?.backgroundColor = UIColor(red: 236.0, green: 238.0, blue: 241.0, alpha: 1.0)
        self.window?.rootViewController = slideMenuController
        self.window?.makeKeyAndVisible()
    }
    
    
    fileprivate func onboarding() {
        
        // Create the instance of the onboarding screen
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let onboardingVC = storyboard.instantiateViewController(withIdentifier: "OnboardingNavigationController") as! UINavigationController
        
        self.window?.rootViewController = onboardingVC
        
    }
    
}
