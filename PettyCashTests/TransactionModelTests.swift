//
//  TransactionModelTests.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 9/29/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import XCTest
import CloudKit

class TransactionModelTests: XCTestCase {
    
    var testStartDate : NSDate!
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        super.tearDown()
        
        
    }
    
    func testExample() {
        
        
        
    }
    
    
    func createMockTransactionRecord() -> CKRecord {
        
        // Create the record
        let recordID = CKRecordID(recordName: "testTransactionRecord")
        let record = CKRecord(recordType: "Transaction", recordID: recordID)
        
        self.testStartDate = NSDate()
        
        // Add the required fields
        record.setObject(NSString(string: "Test transactiondescription"), forKey: TransactionKey.description.rawValue)
        record.setObject(self.testStartDate, forKey: TransactionKey.date.rawValue)
        record.setObject(NSNumber(value: 100.0), forKey: TransactionKey.amount.rawValue)

        
        return record
    }
    
}
