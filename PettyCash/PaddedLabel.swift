//
//  PaddedLabel.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 11/14/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import UIKit

@IBDesignable
class PaddedLabel: UILabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    @IBInspectable var paddingTop : CGFloat = 0.0 {
        didSet {
            
        }
    }
    
    @IBInspectable var paddingRight : CGFloat = 0.0 {
        didSet {
            
        }
    }
    
    @IBInspectable var paddingBottom : CGFloat = 0.0 {
        didSet {
            
        }
    }
    
    @IBInspectable var paddingLeft : CGFloat = 0.0 {
        didSet {
            
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 0.0 {
        didSet {
            layer.cornerRadius = cornerRadius
            layer.masksToBounds = cornerRadius > 0.0
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor? = UIColor.clear {
        didSet {
            layer.borderColor = borderColor?.cgColor
        }
    }
    
    override var intrinsicContentSize: CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize
        intrinsicSuperViewContentSize.height += self.paddingTop + self.paddingBottom
        intrinsicSuperViewContentSize.width += self.paddingLeft + self.paddingRight
        return intrinsicSuperViewContentSize
    }
    
    
    override func drawText(in rect: CGRect) {
        
        let insets = UIEdgeInsetsMake(self.paddingTop, self.paddingLeft, self.paddingBottom, self.paddingRight)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        
    }
    
}
































