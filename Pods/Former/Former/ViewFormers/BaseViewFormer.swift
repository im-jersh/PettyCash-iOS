//
//  BaseViewFormer.swift
//  Former
//
//  Created by Ryo Aoyama on 10/1/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

open class BaseViewFormer<T: UITableViewHeaderFooterView>
: ViewFormer, ConfigurableForm {
    
    // MARK: Public
    
    open var view: T {
        return viewInstance as! T
    }
    
    required public init(
        instantiateType: Former.InstantiateType = .class,
        viewSetup: ((T) -> Void)? = nil) {
        super.init(
            viewType: T.self,
            instantiateType: instantiateType,
            viewSetup: viewSetup
            )
    }
    
    public final func viewUpdate(_ update: ((T) -> Void)) -> Self {
        update(view)
        return self
    }
    
    open func viewInitialized(_ view: T) {}
    
    override func viewInstanceInitialized(_ view: UITableViewHeaderFooterView) {
        viewInitialized(view as! T)
    }
}
