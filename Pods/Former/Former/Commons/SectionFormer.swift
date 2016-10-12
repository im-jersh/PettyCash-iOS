//
//  SectionFormer.swift
//  Former-Demo
//
//  Created by Ryo Aoyama on 7/23/15.
//  Copyright © 2015 Ryo Aoyama. All rights reserved.
//

import UIKit

public final class SectionFormer {
    
    // MARK: Public
    
    public init(rowFormer: RowFormer...) {
        self.rowFormers = rowFormer
    }
    
    public init(rowFormers: [RowFormer] = []) {
        self.rowFormers = rowFormers
    }
    
    /// All RowFormers. Default is empty.
    public fileprivate(set) var rowFormers = [RowFormer]()
    
    /// ViewFormer of applying section header. Default is applying simply 10px spacing section header.
    public fileprivate(set) var headerViewFormer: ViewFormer? = ViewFormer(viewType: FormHeaderFooterView.self, instantiateType: .class)
    
    /// ViewFormer of applying section footer. Default is nil.
    public fileprivate(set) var footerViewFormer: ViewFormer?
    
    /// Return all row count.
    public var numberOfRows: Int {
        return rowFormers.count
    }
    
    /// Returns the first element of RowFormers, or `nil` if `self.rowFormers` is empty.
    public var firstRowFormer: RowFormer? {
        return rowFormers.first
    }
    
    /// Returns the last element of RowFormers, or `nil` if `self.rowFormers` is empty.
    public var lastRowFormer: RowFormer? {
        return rowFormers.last
    }
    
    public subscript(index: Int) -> RowFormer {
        return rowFormers[index]
    }
    
    public subscript(range: Range<Int>) -> [RowFormer] {
        return Array<RowFormer>(rowFormers[range])
    }
    
    /// Append RowFormer to last index.
    public func append(rowFormer: RowFormer...) -> Self {
        add(rowFormers: rowFormer)
        return self
    }
    
    /// Add RowFormers to last index.
    public func add(rowFormers: [RowFormer]) -> Self {
        self.rowFormers += rowFormers
        return self
    }
    
    /// Insert RowFormer to any index.
    public func insert(rowFormer: RowFormer..., toIndex: Int) -> Self {
        let count = self.rowFormers.count
        if count == 0 ||  toIndex >= count {
            add(rowFormers: rowFormers)
            return self
        }
        self.rowFormers.insert(contentsOf: rowFormers, at: toIndex)
        return self
    }
    
    /// Insert RowFormers to any index.
    public func insert(rowFormers: [RowFormer], toIndex: Int) -> Self {
        let count = self.rowFormers.count
        if count == 0 ||  toIndex >= count {
            add(rowFormers: rowFormers)
            return self
        }
        self.rowFormers.insert(contentsOf: rowFormers, at: toIndex)
        return self
    }
    
    /// Insert RowFormer to above other SectionFormer.
    public func insert(rowFormer: RowFormer..., above: RowFormer) -> Self {
        for (row, rowFormer) in self.rowFormers.enumerated() {
            if rowFormer === above {
                insert(rowFormers: [rowFormer], toIndex: row)
                return self
            }
        }
        add(rowFormers: rowFormers)
        return self
    }
    
    /// Insert RowFormers to above other SectionFormer.
    public func insert(rowFormers: [RowFormer], above: RowFormer) -> Self {
        for (row, rowFormer) in self.rowFormers.enumerated() {
            if rowFormer === above {
                insert(rowFormers: [rowFormer], toIndex: row)
                return self
            }
        }
        add(rowFormers: rowFormers)
        return self
    }
    
    /// Insert RowFormer to below other SectionFormer.
    public func insert(rowFormer: RowFormer..., below: RowFormer) -> Self {
        for (row, rowFormer) in self.rowFormers.enumerated() {
            if rowFormer === below {
                insert(rowFormers: [rowFormer], toIndex: row + 1)
                return self
            }
        }
        add(rowFormers: rowFormers)
        return self
    }
    
    /// Insert RowFormers to below other SectionFormer.
    public func insert(rowFormers: [RowFormer], below: RowFormer) -> Self {
        for (row, rowFormer) in self.rowFormers.enumerated() {
            if rowFormer === below {
                insert(rowFormers: [rowFormer], toIndex: row + 1)
                return self
            }
        }
        add(rowFormers: rowFormers)
        return self
    }
    
    /// Remove RowFormers from instances of RowFormer.
    public func remove(rowFormer: RowFormer...) -> Self {
        var removedCount = 0
        for (index, rowFormer) in self.rowFormers.enumerated() {
            if rowFormers.contains(where: { $0 === rowFormer }) {
                remove(index)
                removedCount += 1
                if removedCount >= rowFormers.count {
                    return self
                }
            }
        }
        return self
    }
    
    /// Remove RowFormers from instances of RowFormer.
    public func remove(rowFormers: [RowFormer]) -> Self {
        var removedCount = 0
        for (index, rowFormer) in self.rowFormers.enumerated() {
            if rowFormers.contains(where: { $0 === rowFormer }) {
                remove(index)
                removedCount += 1
                if removedCount >= rowFormers.count {
                    return self
                }
            }
        }
        return self
    }
    
    /// Remove RowFormer from index.
    public func remove(_ atIndex: Int) -> Self {
        rowFormers.remove(at: atIndex)
        return self
    }
    
    /// Remove RowFormers from range.
    public func remove(_ range: Range<Int>) -> Self{
        rowFormers.removeSubrange(range)
        return self
    }
    
    /// Set ViewFormer to apply section header.
    public func set(headerViewFormer viewFormer: ViewFormer?) -> Self {
        headerViewFormer = viewFormer
        return self
    }
    
    /// Set ViewFormer to apply section footer.
    public func set(footerViewFormer viewFormer: ViewFormer?) -> Self {
        footerViewFormer = viewFormer
        return self
    }
}
