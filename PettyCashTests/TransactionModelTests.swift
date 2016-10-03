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
    var testCKRecord : CKRecord!
    
    override func setUp() {
        super.setUp()
        
        self.testCKRecord = self.createMockTransactionRecord()
    }
    
    override func tearDown() {
        super.tearDown()
        
        
    }
    
    func testCreateTransactionFromPassedInValues_ValidTransaction() {
        
        let transaction = Transaction(for: 100.0, withDescription: "Test transaction description", andDate: Date()) // We'll consider this exhaustive testing for this initializer even though it has an optional third parameter
        
        XCTAssertNotNil(transaction)
        XCTAssertNotNil(transaction.id)
        XCTAssertNotNil(transaction.description)
        XCTAssertNotNil(transaction.amount)
        XCTAssertNotNil(transaction.date)
    }
    
    func testCreateTransactionFromCKRecord_ValidTransaction() {
        
        let transaction = Transaction(fromRecord: self.testCKRecord)
        
        XCTAssertNotNil(transaction)
        XCTAssertNotNil(transaction.id)
        XCTAssertNotNil(transaction.description)
        XCTAssertNotNil(transaction.amount)
        XCTAssertNotNil(transaction.date)
    }
    
    func testTransactionProperties_AllPropertiesAreExpectedValues() {

        let transaction = Transaction(fromRecord: self.testCKRecord)
        
        XCTAssertEqual(transaction.id, "testTransactionRecord")
        XCTAssertEqual(transaction.description, "Test transaction description")
        XCTAssertEqual(transaction.amount, 100.0)
        XCTAssertEqual(transaction.date, self.testStartDate as? Date)
    }
    
    func createMockTransactionRecord() -> CKRecord {
        
        // Create the record
        let recordID = CKRecordID(recordName: "testTransactionRecord")
        let record = CKRecord(recordType: "Transaction", recordID: recordID)
        
        self.testStartDate = NSDate()
        
        // Add the required fields
        record.setObject(NSString(string: "Test transaction description"), forKey: TransactionKey.description.rawValue)
        record.setObject(self.testStartDate, forKey: TransactionKey.date.rawValue)
        record.setObject(NSNumber(value: 100.0), forKey: TransactionKey.amount.rawValue)

        
        return record
    }
    
}
