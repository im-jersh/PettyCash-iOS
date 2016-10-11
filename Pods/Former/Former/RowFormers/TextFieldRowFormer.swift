//
//  TextFieldRowFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/25/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public protocol TextFieldFormableRow: FormableRow {
    
    func formTextField() -> UITextField
    func formTitleLabel() -> UILabel?
}

open class TextFieldRowFormer<T: UITableViewCell>
: BaseRowFormer<T>, Formable where T: TextFieldFormableRow {
    
    // MARK: Public
    
    override open var canBecomeEditing: Bool {
        return enabled
    }
    
    open var text: String?
    open var placeholder: String?
    open var attributedPlaceholder: NSAttributedString?
    open var textDisabledColor: UIColor? = .lightGray
    open var titleDisabledColor: UIColor? = .lightGray
    open var titleEditingColor: UIColor?
    open var returnToNextRow = true
    
    public required init(instantiateType: Former.InstantiateType = .class, cellSetup: ((T) -> Void)? = nil) {
        super.init(instantiateType: instantiateType, cellSetup: cellSetup)
    }
    
    public final func onTextChanged(_ handler: @escaping ((String) -> Void)) -> Self {
        onTextChanged = handler
        return self
    }
    
    open override func cellInitialized(_ cell: T) {
        super.cellInitialized(cell)
        let textField = cell.formTextField()
        textField.delegate = observer
        let events: [(Selector, UIControlEvents)] = [(#selector(TextFieldRowFormer.textChanged(_:)), .editingChanged),
            (#selector(TextFieldRowFormer.editingDidBegin(_:)), .editingDidBegin),
            (#selector(TextFieldRowFormer.editingDidEnd(_:)), .editingDidEnd)]
        events.forEach {
            textField.addTarget(self, action: $0.0, for: $0.1)
        }
    }
    
    open override func update() {
        super.update()
        
        cell.selectionStyle = .none
        let titleLabel = cell.formTitleLabel()
        let textField = cell.formTextField()
        textField.text = text
        _ = placeholder.map { textField.placeholder = $0 }
        _ = attributedPlaceholder.map { textField.attributedPlaceholder = $0 }
        textField.isUserInteractionEnabled = false
        
        if enabled {
            if isEditing {
                if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
                _ = titleEditingColor.map { titleLabel?.textColor = $0 }
            } else {
                _ = titleColor.map { titleLabel?.textColor = $0 }
                titleColor = nil
            }
            _ = textColor.map { textField.textColor = $0 }
            textColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            if textColor == nil { textColor = textField.textColor ?? .black }
            titleLabel?.textColor = titleDisabledColor
            textField.textColor = textDisabledColor
        }
    }
    
    open override func cellSelected(_ indexPath: IndexPath) {        
        let textField = cell.formTextField()
        if !textField.isEditing {
            textField.isUserInteractionEnabled = true
            textField.becomeFirstResponder()
        }
    }
    
    // MARK: Private
    
    fileprivate final var onTextChanged: ((String) -> Void)?
    fileprivate final var textColor: UIColor?
    fileprivate final var titleColor: UIColor?
    
    fileprivate lazy var observer: Observer<T> = Observer<T>(textFieldRowFormer: self)
    
    fileprivate dynamic func textChanged(_ textField: UITextField) {
        if enabled {
            let text = textField.text ?? ""
            self.text = text
            onTextChanged?(text)
        }
    }
    
    fileprivate dynamic func editingDidBegin(_ textField: UITextField) {
        let titleLabel = cell.formTitleLabel()
        if titleColor == nil { textColor = textField.textColor ?? .black }
        _ = titleEditingColor.map { titleLabel?.textColor = $0 }
    }
    
    fileprivate dynamic func editingDidEnd(_ textField: UITextField) {
        let titleLabel = cell.formTitleLabel()
        if enabled {
            _ = titleColor.map { titleLabel?.textColor = $0 }
            titleColor = nil
        } else {
            if titleColor == nil { titleColor = titleLabel?.textColor ?? .black }
            _ = titleEditingColor.map { titleLabel?.textColor = $0 }
        }
        cell.formTextField().isUserInteractionEnabled = false
    }
}

private class Observer<T: UITableViewCell>: NSObject, UITextFieldDelegate where T: TextFieldFormableRow {
    
    fileprivate weak var textFieldRowFormer: TextFieldRowFormer<T>?
    
    init(textFieldRowFormer: TextFieldRowFormer<T>) {
        self.textFieldRowFormer = textFieldRowFormer
    }
    
    fileprivate dynamic func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let textFieldRowFormer = textFieldRowFormer else { return false }
        if textFieldRowFormer.returnToNextRow {
            let returnToNextRow = (textFieldRowFormer.former?.canBecomeEditingNext() ?? false) ?
                textFieldRowFormer.former?.becomeEditingNext :
                textFieldRowFormer.former?.endEditing
            returnToNextRow?()
        }
        return !textFieldRowFormer.returnToNextRow
    }
}
