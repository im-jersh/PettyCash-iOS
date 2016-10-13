//
//  FormSelectorPickerCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 8/24/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

open class FormSelectorPickerCell: FormCell, SelectorPickerFormableRow {
    
    // MARK: Public
    
    open var selectorPickerView: UIPickerView?
    open var selectorAccessoryView: UIView?
    
    open fileprivate(set) weak var titleLabel: UILabel!
    open fileprivate(set) weak var displayLabel: UILabel!
    
    open func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    open func formDisplayLabel() -> UILabel? {
        return displayLabel
    }
    
    open override func updateWithRowFormer(_ rowFormer: RowFormer) {
        super.updateWithRowFormer(rowFormer)
        rightConst.constant = (accessoryType == .none) ? -15 : 0
    }
    
    open override func setup() {
        super.setup()
        
        let titleLabel = UILabel()
        titleLabel.setContentHuggingPriority(500, for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(titleLabel, at: 0)
        self.titleLabel = titleLabel
        
        let displayLabel = UILabel()
        displayLabel.textColor = .lightGray
        displayLabel.textAlignment = .right
        displayLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(displayLabel, at: 0)
        self.displayLabel = displayLabel
        
        let constraints = [
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[title]-0-|",
                options: [],
                metrics: nil,
                views: ["title": titleLabel]
            ),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[display]-0-|",
                options: [],
                metrics: nil,
                views: ["display": displayLabel]
            ),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-15-[title]-10-[display(>=0)]",
                options: [],
                metrics: nil,
                views: ["title": titleLabel, "display": displayLabel]
            )
            ].flatMap { $0 }
        let rightConst = NSLayoutConstraint(
            item: displayLabel,
            attribute: .trailing,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .trailing,
            multiplier: 1,
            constant: 0
        )        
        contentView.addConstraints(constraints + [rightConst])
        self.rightConst = rightConst
    }
    
    // MARK: Private
    
    fileprivate weak var rightConst: NSLayoutConstraint!
}
