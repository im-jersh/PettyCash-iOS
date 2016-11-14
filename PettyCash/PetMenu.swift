//
//  SideMenu.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 11/13/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation
import PathMenu
import UIKit

class PetMenu : PathMenu {
    
    convenience init(frame: CGRect!, delegate: PathMenuDelegate?) {
        
        let menuItemImage = UIImage(named: "bg-menuitem")!
        let menuItemHighlitedImage = UIImage(named: "bg-menuitem-highlighted")!
        
        let foodImage = UIImage(named: "food-bowl")!
        let bathImage = UIImage(named: "bathe")!
        let poopImage = UIImage(named: "poop")!
        let groomImage = UIImage(named: "comb")!
        let treatsImage = UIImage(named: "treat")!
        
        
        let food = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: foodImage)
        let bath = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: bathImage)
        let poop = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: poopImage)
        let groom = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: groomImage)
        let treats = PathMenuItem(image: menuItemImage, highlightedImage: menuItemHighlitedImage, contentImage: treatsImage)
        
        let items = [food, poop, bath, groom, treats]
        
        let startItem = PathMenuItem(image: UIImage(named: "bg-addbutton")!,
                                     highlightedImage: UIImage(named: "bg-addbutton-highlighted"),
                                     contentImage: UIImage(named: "icon-plus"),
                                     highlightedContentImage: UIImage(named: "icon-plus-highlighted"))
        
        self.init(frame: frame, startItem: startItem, items: items)
        
        self.delegate = delegate
        
        self.startPoint     = CGPoint(x: UIScreen.main.bounds.width/2, y: frame.size.height - 30.0)
        self.menuWholeAngle = CGFloat(M_PI) - CGFloat(M_PI/5)
        self.rotateAngle    = -CGFloat(M_PI_2) + CGFloat(M_PI/5) * 1/2
        self.timeOffset     = 0.0
        self.farRadius      = 110.0
        self.nearRadius     = 90.0
        self.endRadius      = 100.0
        self.animationDuration = 0.5
        
    }
    
}
