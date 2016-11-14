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

class PetViewController: UIViewController {

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
        print("Item \(idx) selected")
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
