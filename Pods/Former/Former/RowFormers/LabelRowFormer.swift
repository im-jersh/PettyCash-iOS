//
//  LabelRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/24/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol LabelFormableRow: FormableRow {
    
    func formTextLabel() -> UILabel?
    func formSubTextLabel() -> UILabel?
}

open class LabelRowFormer<T: UITableViewCell>
: BaseRowFormer<T>, Formable where T: LabelFormableRow {
    
    // MARK: Public
    
    open var text: String?
    open var subText: String?
    open var textDisabledColor: UIColor? = .lightGray
    open var subTextDisabledColor: UIColor? = .lightGray
    
    public required init(instantiateType: Former.InstantiateType = .class, cellSetup: ((T) -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    open override func update() {
        super.update()
        
        let textLabel = cell.formTextLabel()
        let subTextLabel = cell.formSubTextLabel()
        textLabel?.text = text
        subTextLabel?.text = subText
        
        if enabled {
            _ = textColor.map { textLabel?.textColor = $0 }
            _ = subTextColor.map { subTextLabel?.textColor = $0 }
            textColor = nil
            subTextColor = nil
        } else {
            if textColor == nil { textColor = textLabel?.textColor ?? .black }
            if subTextColor == nil { subTextColor = subTextLabel?.textColor ?? .black }
            textLabel?.textColor = textDisabledColor
            subTextLabel?.textColor = subTextDisabledColor
        }
    }
    
    // MARK: Private
    
    fileprivate final var textColor: UIColor?
    fileprivate final var subTextColor: UIColor?
}
