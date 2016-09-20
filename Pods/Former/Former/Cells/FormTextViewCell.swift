//
//  FormTextViewCell.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/28/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

open class FormTextViewCell: FormCell, TextViewFormableRow {
    
    // MARK: Public
    
    open fileprivate(set) weak var textView: UITextView!
    open fileprivate(set) weak var titleLabel: UILabel!
    
    open func formTextView() -> UITextView {
        return textView
    }
    
    open func formTitleLabel() -> UILabel? {
        return titleLabel
    }
    
    open override func updateWithRowFormer(_ rowFormer: RowFormer) {
        super.updateWithRowFormer(rowFormer)
        leftConst.constant = titleLabel.text?.isEmpty ?? true ? 5 : 15
    }
    
    open override func setup() {
        super.setup()
        
        let titleLabel = UILabel()
        titleLabel.setContentHuggingPriority(500, for: .horizontal)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(titleLabel, at: 0)
        self.titleLabel = titleLabel
        
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.font = .systemFont(ofSize: 17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        contentView.insertSubview(textView, at: 0)
        self.textView = textView
        
        let constraints = [
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-10-[label(>=0)]",
                options: [],
                metrics: nil,
                views: ["label": titleLabel]
            ),
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:|-0-[text]-0-|",
                options: [],
                metrics: nil,
                views: ["text": textView]
            ),
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:[label]-5-[text]-10-|",
                options: [],
                metrics: nil,
                views: ["label": titleLabel, "text": textView]
            )
            ].flatMap { $0 }
        let leftConst = NSLayoutConstraint(
            item: titleLabel,
            attribute: .leading,
            relatedBy: .equal,
            toItem: contentView,
            attribute: .leading,
            multiplier: 1,
            constant: 15
        )
        contentView.addConstraints(constraints + [leftConst])
        self.leftConst = leftConst
    }
    
    // MARK: Private
    
    fileprivate weak var leftConst: NSLayoutConstraint!
    fileprivate weak var rightConst: NSLayoutConstraint!
}
