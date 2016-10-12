//
//  GameViewController.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 9/8/16.
//  Copyright (c) 2016 Joshua O'Steen. All rights reserved.
//

import UIKit
import SpriteKit
import PathMenu
import ChameleonFramework

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"GameScene") {
            // Configure the view.
            let skView = self.view as! SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* Sprite Kit applies additional optimizations to improve rendering performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .aspectFill
            scene.backgroundColor = UIColor.flatSkyBlue()
            //scene.backgroundColor = GradientColor(.TopToBottom, frame: view.frame, colors: [UIColor.flatGreenColor(), UIColor.flatWhiteColor(), UIColor.flatSkyBlueColor()])
            //scene.backgroundColor = UIColor(gradientStyle: UIGradientStyle.TopToBottom, withFrame: self.view.bounds, andColors: [UIColor.flatGreenColor(), UIColor.flatWhiteColor(), UIColor.flatSkyBlueColor()])
            
            skView.presentScene(scene)
        }
        
        self.makePathMenu()
        
    }

    override var shouldAutorotate : Bool {
        return true
    }

    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    func makePathMenu() {
        
        let menuItemImage = UIImage(named: "bg-menuitem")!
        let menuItemHighlitedImage = UIImage(named: "bg-menuitem-highlighted")!
        let starImage = UIImage(named: "icon-star")!
        
        let starMenuItem1 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
        let starMenuItem2 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
        let starMenuItem3 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
        let starMenuItem4 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
        let starMenuItem5 = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: starImage)
        
        let items = [starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5]
        
        let startItem = PathMenuItem(image: UIImage(named: "bg-addbutton")!,
                                     highlightedImage: UIImage(named: "bg-addbutton-highlighted"),
                                     contentImage: UIImage(named: "icon-plus"),
                                     highlightedContentImage: UIImage(named: "icon-plus-highlighted"))
        
        let menu = PathMenu(frame: view.bounds, startItem: startItem, items: items)
        menu.delegate = self
        
        menu.startPoint     = CGPoint(x: UIScreen.main.bounds.width/2, y: view.frame.size.height - 30.0)
        menu.menuWholeAngle = CGFloat(M_PI) - CGFloat(M_PI/5)
        menu.rotateAngle    = -CGFloat(M_PI_2) + CGFloat(M_PI/5) * 1/2
        menu.timeOffset     = 0.0
        menu.farRadius      = 110.0
        menu.nearRadius     = 90.0
        menu.endRadius      = 100.0
        menu.animationDuration = 0.5
        
        view.addSubview(menu)
        
    }
    
}


extension GameViewController : PathMenuDelegate {

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
