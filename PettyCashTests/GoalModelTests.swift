//
//  GoalModelTests.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 9/29/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import XCTest
import CloudKit

class GoalModelTests: XCTestCase {
    
    var testCKRecord : CKRecord!
    var testStartDate : NSDate!
    
    override func setUp() {
        super.setUp()
        
        self.testCKRecord = self.createMockGoalRecord()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCreateGoalFromCKRecord_ValidGoal() {
        
        let goal = Goal(fromRecord: self.testCKRecord)
        
        XCTAssertNotNil(goal)
        XCTAssertNotNil(goal.id)
        XCTAssertNotNil(goal.description)
        XCTAssertNotNil(goal.startDate)
        XCTAssertNotNil(goal.amount)
        XCTAssertNotNil(goal.priority)
    }
    
    func testGoalProperties_AllPropertiesAreExpectedValues() {
        
        let goal = Goal(fromRecord: self.testCKRecord)
        
        XCTAssertEqual(goal.id, "testGoalRecord")
        XCTAssertEqual(goal.description, "Test goal description")
        XCTAssertEqual(goal.startDate, self.testStartDate as? Date)
        XCTAssertEqual(goal.amount, 100.0)
        XCTAssertEqual(goal.priority, Priority.low)
        
    }
    
    func testContributionOnNilTransactions_ZeroAmount() {
        
        let goal = Goal(fromRecord: self.testCKRecord)
        
        XCTAssertNil(goal.transactions)
        XCTAssertTrue(goal.contributionAmount == 0.0)
        
    }
    
    func testProgressOnNilTransactions_ZeroProgress() {
        
        let goal = Goal(fromRecord: self.testCKRecord)
        
        XCTAssertTrue(goal.progress == 0.0)
    }
    
    func testCompleteOnNilTransactions_FalseComplete() {
        
        let goal = Goal(fromRecord: self.testCKRecord)
        
        XCTAssertFalse(goal.complete)
    }
    
    func createMockGoalRecord() -> CKRecord {
        
        // Create the record
        let recordID = CKRecordID(recordName: "testGoalRecord")
        let record = CKRecord(recordType: "Goal", recordID: recordID)
        
        self.testStartDate = NSDate()
        
        // Add the required fields
        record.setObject(NSString(string: "Test goal description"), forKey: GoalKey.description.rawValue)
        record.setObject(self.testStartDate, forKey: GoalKey.startDate.rawValue)
        record.setObject(NSNumber(value: 100.0), forKey: GoalKey.amount.rawValue)
        record.setObject(NSNumber(value: Priority.low.rawValue), forKey: GoalKey.priority.rawValue)
        
        return record
    }
    
    
    
    
}
