//
//  CKEngine.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 10/28/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation
import CloudKit

enum RecordType : String {
    case goal = "Goal"
    case transaction = "Transaction"
}

enum RecordZone : String {
    case settings
    case savings
    case accounts
    case pets
    case expenses
    
    var zoneName : String {
        return String(describing: self)
    }
}

class CKEngine {
    
// MARK: Properties
    private static let defaultContainer = CKContainer.default()
    private static let privateDatabase = CKContainer.default().privateCloudDatabase
    
    class func seedDummyData() {
        
        // Delete the appropriate zones first by creating an operation to delete the zones by ID.
        // This effectively deletes all the records within the zone
        let savingsZoneID = CKRecordZoneID(zoneName: RecordZone.savings.zoneName, ownerName: CKOwnerDefaultName)
        let deleteZoneOperation = CKModifyRecordZonesOperation(recordZonesToSave: nil, recordZoneIDsToDelete: [savingsZoneID])
        deleteZoneOperation.modifyRecordZonesCompletionBlock = { savedRecordZones, deletedRecordZoneIDs, error in
            print("Deleted record zone")
        }
        
        // Make a new zone and the operation to save it
        let savingsZone = CKRecordZone(zoneID: savingsZoneID)
        let saveNewZoneOperation = CKModifyRecordZonesOperation(recordZonesToSave: [savingsZone], recordZoneIDsToDelete: nil)
        saveNewZoneOperation.modifyRecordZonesCompletionBlock = { savedRecordZones, deletedRecordZoneIDs, error in
            print("Created record zone")
        }
        
        // Make the delete operation a dependency of the save new operation then add them to the queue for execution
        saveNewZoneOperation.addDependency(deleteZoneOperation)
        self.privateDatabase.add(deleteZoneOperation)
        self.privateDatabase.add(saveNewZoneOperation)
        
        // Create some goals with transactions
        let firstGoal = CKRecord(recordType: RecordType.goal.rawValue, zoneID: savingsZone.zoneID)
        firstGoal.setObject("Dumb Phone" as NSString, forKey: GoalKey.description.rawValue)
        firstGoal.setObject(Date.days(away: -10) as NSDate, forKey: GoalKey.startDate.rawValue)
        firstGoal.setObject(Date.weeks(away: 40) as NSDate, forKey: GoalKey.endDate.rawValue)
        firstGoal.setObject(200.00 as NSNumber, forKey: GoalKey.amount.rawValue)
        firstGoal.setObject(Priority.high.rawValue as NSNumber, forKey: GoalKey.priority.rawValue)
        
        let reference = CKReference(record: firstGoal, action: .none)
        let firstTrans = CKRecord(recordType: RecordType.transaction.rawValue, zoneID: savingsZone.zoneID)
        firstTrans.setObject("Dummy savings transaction #1" as NSString, forKey: TransactionKey.description.rawValue)
        firstTrans.setObject(Date.days(away: -9) as NSDate, forKey: TransactionKey.date.rawValue)
        firstTrans.setObject(10.00 as NSNumber, forKey: TransactionKey.amount.rawValue)
        firstTrans.setObject(reference, forKey: TransactionKey.goal.rawValue)
        
        let secondTrans = CKRecord(recordType: RecordType.transaction.rawValue, zoneID: savingsZone.zoneID)
        secondTrans.setObject("Dummy savings transaction #2" as NSString, forKey: TransactionKey.description.rawValue)
        secondTrans.setObject(Date.days(away: -7) as NSDate, forKey: TransactionKey.date.rawValue)
        secondTrans.setObject(3.22 as NSNumber, forKey: TransactionKey.amount.rawValue)
        secondTrans.setObject(reference, forKey: TransactionKey.goal.rawValue)
        
        // Make a save records operation that is dependent on the create zone operation
        let saveDummyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [firstGoal, firstTrans, secondTrans], recordIDsToDelete: nil)
        saveDummyRecordsOperation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            print("Saved dummy data to private database")
        }
        saveDummyRecordsOperation.addDependency(saveNewZoneOperation)
        
        self.privateDatabase.add(saveDummyRecordsOperation)
        
    }
    

    func fetchAllGoals(completionHandler: @escaping (CKResult<Goals>?, Error?) -> Void) {
        
        // A result wrapper that we will return upon successful completion of the method
        let result : CKResult<[String:Any]> = CKResult(result: Dictionary<String,Any>())
        
        // Fetch all the goals
        let allGoalsOperation = FetchAllGoalsOperation(result: result)
        CKEngine.privateDatabase.add(allGoalsOperation)
        
        let finishedOperation = BlockOperation { [unowned result] in
            print("FETCH COMPLETED")
            guard let goals = result.value?["goals"] as? Goals else {
                let error = NSError(domain: "cloudkit", code: 1, userInfo: nil)
                completionHandler(nil, error)
                return
            }
            completionHandler(CKResult(result: goals), nil)
        }
        finishedOperation.addDependency(allGoalsOperation)
        OperationQueue().addOperation(finishedOperation)
    }
    
}


public class CKResult<T> {
    
    var value : T?
    
    init(result: T?) {
        self.value = result
    }
    
}


fileprivate class FetchAllGoalsOperation : CKQueryOperation {
    
    let result : CKResult<[String:Any]>
    
    init(result: CKResult<[String:Any]>) {
        
        self.result = result
        self.result.value?["goals"] = Goals()
        
        super.init()
        
        // Setup the query
        let goalPredicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RecordType.goal.rawValue, predicate: goalPredicate)
        self.query = query
        
        // Set up the blocks
        self.recordFetchedBlock = { savedRecord in
            
            guard var goals = self.result.value?["goals"] as? Goals else {
                print("*** Error accessing value of CKResult ***\n\(result.value)")
                return
            }
            
            goals.append(Goal(fromRecord: savedRecord))
            print("ADDED GOAL TO RESULT")
            
        }
        
        self.queryCompletionBlock = { cursor, error in
            guard error == nil else {
                print("*** Error fetching all goals ***\n\(error?.localizedDescription)")
                return
            }
            
            if let _ = cursor {
                // TODO: Create function for recursive call to get next back of goals
                print("\n\nThere are more goals to be fetched.\n\n")
            } else {
                print("\(result.value!.count) GOALS FETCHED!")
            }
        }
    }
    
}

fileprivate class ProcessGoalsOperation : Operation {
    
    let result : CKResult<[String:Any]>
    
    init(result: CKResult<[String:Any]>) {
        self.result = result
        self.result.value?["transactionQueries"] = [CKQueryOperation]()
    }
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        
        guard let goals = self.result.value?["goals"] as? Goals else {
            self.cancel()
            return
        }
        
        // We should process each goal and make a transaction query for each
        for goal in goals {
            let recordID = CKRecordID(recordName: goal.id)
            let reference = CKReference(recordID: recordID, action: .none)
            let predicate = NSPredicate(format: "goal == %@", reference)
            let sort = NSSortDescriptor(key: "creationDate", ascending: false)
            let query = CKQuery(recordType: RecordType.transaction.rawValue, predicate: predicate)
            query.sortDescriptors = [sort]
            
            let transactionOperation = CKQueryOperation(query: query)
            transactionOperation.recordFetchedBlock = { [unowned result = self.result] savedRecord in
                // Create a transaction from the record and append it to the goal
                let transaction = Transaction(fromRecord: savedRecord)
                goal.addTransaction(transaction)
                print("ADDED TRANSACTION TO GOAL")
            }
            transactionOperation.queryCompletionBlock = { [unowned result = self.result] cursor, error in
                
                guard error == nil else {
                    print("*** Error fetching transactions for goal ***\n\(error?.localizedDescription)")
                    return
                }
                
                if let _ = cursor {
                    // TODO: Create function for recursive call to get next back of goals
                    print("\n\nThere are more transactions to be fetched.\n\n")
                } else {
                    print("ALL TRANSACTIONS FOR GOAL HAVE BEEN FETCHED!")
                }
            }
        }
        
        
    }
    
}

fileprivate class FetchAllTransactionsOperation : CKQueryOperation {
    
    var result : CKResult<[String:Any]>
    
    init(result: CKResult<[String:Any]>) {
        self.result = result
    }
    
    
    
}


































