//
//  PetViewController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 11/13/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit
import PathMenu
import SlideMenuControllerSwift
import FTIndicator

class PetViewController: UIViewController {
    
    fileprivate let petActions : [PetAction] = [PetAction.feed, PetAction.poop, PetAction.bathe, PetAction.groom, PetAction.treat]
    fileprivate let pcHandler : PCHandler = PCController()
    
    override var prefersStatusBarHidden : Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(PetMenu(frame: self.view.bounds, delegate: self))
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
    
    @IBAction func menuButtonWasTapped(_ sender: AnyObject) {
        self.slideMenuController()?.openLeft()
    }
    

}


extension PetViewController : PathMenuDelegate {
    
    func pathMenu(_ menu: PathMenu, didSelectIndex idx: Int) {
        
        FTIndicator.showProgressWithmessage("Generating a contribution amount", userInteractionEnable: false)
        self.pcHandler.generateSavings(for: self.petActions[idx]) { (tca, error) in
            
            guard let tca = tca else {
                fatalError("Error generating TCA: \(error?.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                FTIndicator.dismissProgress()
                FTIndicator.showSuccess(withMessage: "\(tca.formattedCurrency) has been deposited into your savings account!", userInteractionEnable: false)
            }
        }
        
    }
    
    func pathMenuWillAnimateOpen(_ menu: PathMenu) {
        
    }
    
    func pathMenuWillAnimateClose(_ menu: PathMenu) {
        
    }
    
    func pathMenuDidFinishAnimationOpen(_ menu: PathMenu) {
        
    }
    
    func pathMenuDidFinishAnimationClose(_ menu: PathMenu) {
        
    }
    
}


extension PetViewController : SlideMenuControllerDelegate {
    
}
