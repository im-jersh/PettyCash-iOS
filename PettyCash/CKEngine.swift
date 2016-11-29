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

public struct CKContributionData {
    
    let goals : [(goal: Goal, ica: Double)]
    let amount : Double
    let toAccount : String
    let fromAccount : String
    let tca : Double
    let action : PetAction
    
}

class CKEngine {
    
// MARK: Properties
    fileprivate static let defaultContainer = CKContainer.default()
    fileprivate static let privateDatabase = CKContainer.default().privateCloudDatabase


    func fetchAllGoals(completionHandler: @escaping (CKResult<Goals>?, Error?) -> Void) {
        
        let opQueue = OperationQueue()
        
        // Fetch all the goals
        let allGoalsOperation = FetchAllOperation(recordType: RecordType.goal, inReferenceTo: nil)
        CKEngine.privateDatabase.add(allGoalsOperation)
        
        // Process the goals
        let processGoalsOperation = ProcessRecordsOperation(recordType: RecordType.goal)
        processGoalsOperation.addDependency(allGoalsOperation)
        processGoalsOperation.completionBlock = {
            
            guard let goals = processGoalsOperation.objects as? Goals else {
                completionHandler(nil, NSError(domain: "cloudkit", code: 1, userInfo: nil))
                return
            }
            
            // Make a completion block that is dependent on all fetch transaction blocks
            let completionBlock = BlockOperation {
                print("ALL TRANSACTION QUERIES HAVE FINISHED")
                completionHandler(CKResult(result: goals), nil)
            }
            
            for goal in goals {
                let transactionOp = FetchAllOperation(recordType: .transaction, inReferenceTo: goal)
                let processOp = ProcessRecordsOperation(recordType: .transaction)
                processOp.addDependency(transactionOp)
                processOp.completionBlock = {
                    guard let transactions = processOp.objects as? Transactions else {
                        completionHandler(nil, NSError(domain: "cloudkit", code: 1, userInfo: nil))
                        return
                    }
                    goal.replaceTransactions(transactions)
                }
                CKEngine.privateDatabase.add(transactionOp)
                completionBlock.addDependency(processOp)
                opQueue.addOperation(processOp)
            }
            
            opQueue.addOperation(completionBlock)
        }
        
        opQueue.addOperation(processGoalsOperation)
        
    }
    
    func saveNew(_ transportable: Transportable, completionHandler: @escaping (CKResult<Transportable>?, Error?) -> Void) {
        
        var record : CKRecord!
        
        // TODO: Remove guard after implementing transaction check
        guard transportable is Goal else {
            completionHandler(nil, NSError(domain: "cloudkit", code: -1, userInfo: nil))
            return
        }
        
        if transportable is Goal {
            let goal = transportable as! Goal
            let zoneID = CKRecordZoneID(zoneName: RecordZone.savings.zoneName, ownerName: CKOwnerDefaultName)
            let recordID = CKRecordID(recordName: goal.id, zoneID: zoneID)
            record = CKRecord(recordType: RecordType.goal.rawValue, recordID: recordID)
            record.setObject(goal.description as CKRecordValue, forKey: GoalKey.description.rawValue)
            record.setObject(goal.startDate as CKRecordValue, forKey: GoalKey.startDate.rawValue)
            record.setObject(goal.amount as CKRecordValue, forKey: GoalKey.amount.rawValue)
            record.setObject(goal.priority.rawValue as CKRecordValue, forKey: GoalKey.priority.rawValue)
            if let endDate = goal.endDate {
                record.setObject(endDate as CKRecordValue, forKey: GoalKey.endDate.rawValue)
            }
        }
        
        CKEngine.privateDatabase.save(record) { (savedRecord, error) in
            
            guard error == nil else {
                completionHandler(nil, error!)
                return
            }
            
            if let savedRecord = savedRecord {
                print("SAVED RECORD")
                completionHandler(CKResult(result: Goal(fromRecord: savedRecord)), nil)
            }
            
        }
        
        
        
    }
    
    func fetchAllTransactions(_ completionHandler: @escaping (CKResult<Transactions>?, Error?) -> Void) {
        
        let opQueue = OperationQueue()
        
        // Create a fetch all transactions operations
        let allTransactions = FetchAllOperation(recordType: RecordType.transaction, inReferenceTo: nil)
        
        // Process the transactions
        let processTransactionsOperation = ProcessRecordsOperation(recordType: RecordType.transaction)
        processTransactionsOperation.addDependency(allTransactions)
        processTransactionsOperation.completionBlock = {
            
            guard let transactions = processTransactionsOperation.objects as? Transactions else {
                completionHandler(nil, NSError(domain: "cloudkit", code: -1, userInfo: nil))
                return
            }
            
            completionHandler(CKResult(result: transactions), nil)
        }
        
        CKEngine.privateDatabase.add(allTransactions)
        opQueue.addOperation(processTransactionsOperation)
    
    }
    
    func processTotalContributionAmount(in prepData: CKContributionData, _ completionHandler: @escaping (CKResult<Any>?, Error?) -> Void) {
        
        // Prepare
        let zoneID = CKRecordZoneID(zoneName: RecordZone.savings.zoneName, ownerName: CKOwnerDefaultName)
        var actionDescription = ""
        switch prepData.action {
        case .poop:
            actionDescription += "Poop scoop'n 💩"
        case .feed:
            actionDescription += "Chow time 🍖"
        case .bathe:
            actionDescription += "Squeeky clean! 🚿"
        case .treat:
            actionDescription += "Treat yo self 🍬"
        case .groom:
            actionDescription += "Look'n sharp 🕶"
        }
        let bundleName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
        
        // Iterate over the goals, create contributions, then save the contributions
        let contributionRecords : [CKRecord] = prepData.goals.map { (data : (goal: Goal, ica: Double)) in
            
            // Set the record values
            let record = CKRecord(recordType: RecordType.transaction.rawValue, zoneID: zoneID)
            record.setObject(data.ica as CKRecordValue, forKey: TransactionKey.amount.rawValue)
            record.setObject(Date() as CKRecordValue, forKey: TransactionKey.date.rawValue)
            record.setObject("\(actionDescription) \(bundleName) transfer to \(prepData.toAccount)" as CKRecordValue, forKey: TransactionKey.description.rawValue)
            
            // Set a reference to the associated goal
            let goalID = CKRecordID(recordName: data.goal.id, zoneID: zoneID)
            let ref = CKReference(recordID: goalID, action: CKReferenceAction.none)
            record.setObject(ref, forKey: TransactionKey.goal.rawValue)
            
            return record
        }
        
        let saveOp = CKModifyRecordsOperation(recordsToSave: contributionRecords, recordIDsToDelete: nil)
        saveOp.perRecordCompletionBlock = { record, error in
            guard let record = record else {
                print("Error saving contribution record")
                return
            }
            print("Contribution Record Saved Successfully")
        }
        saveOp.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            guard let savedRecords = savedRecords else {
                print("Error saving contribution records")
                return
            }
            
            guard savedRecords.count == prepData.goals.count else {
                print("Error saving contribution records")
                return
            }
            
            completionHandler(CKResult(result: true), nil)
        }
        
        CKEngine.privateDatabase.add(saveOp)
        
    }
    
}


public class CKResult<T> {
    
    var value : T?
    
    init(result: T?) {
        self.value = result
    }
    
}

fileprivate class FetchAllOperation : CKQueryOperation {
    
    var records = [CKRecord]()
    let recordType : RecordType
    let reference : Transportable?
    
    init(recordType: RecordType, with cursor: CKQueryCursor) {
        
        self.recordType = recordType
        self.reference = nil
        
        super.init()
        
        self.cursor = cursor
        
    }
    
    init(recordType: RecordType, inReferenceTo reference: Transportable?) {
        
        self.recordType = recordType
        self.reference = reference
        
        super.init()
        
        // Setup the query
        switch self.recordType {
        case .goal:
            let predicate = NSPredicate(value: true)
            let query = CKQuery(recordType: self.recordType.rawValue, predicate: predicate)
            self.query = query
            break
        case .transaction where reference is Goal: // We should always require that we get transactions that reference a particular goal
            guard let goal = reference as? Goal else {
                self.cancel()
                return
            }
            
            let recordID = CKRecordID(recordName: goal.id)
            let reference = CKReference(recordID: recordID, action: .none)
            let predicate = NSPredicate(format: "goal == %@", reference)
            let sort = NSSortDescriptor(key: "creationDate", ascending: false)
            let query = CKQuery(recordType: RecordType.transaction.rawValue, predicate: predicate)
            query.sortDescriptors = [sort]
            self.query = query
            break
        case .transaction:
            
            let predicate = NSPredicate(value: true)
            let sortDescriptor = NSSortDescriptor(key: TransactionKey.date.rawValue, ascending: false)
            let query = CKQuery(recordType: self.recordType.rawValue, predicate: predicate)
            self.query = query
            query.sortDescriptors = [sortDescriptor]
            break
        }
        
        // Set up the blocks
        self.recordFetchedBlock = { savedRecord in
            self.records.append(savedRecord)
        }
        
        self.queryCompletionBlock = { cursor, error in
            guard error == nil else {
                print("*** Error fetching records ***\n\(error?.localizedDescription)")
                return
            }
            
            if let _ = cursor {
                // TODO: Create function for recursive call to get next back of goals
                print("\n\nThere are more records to be fetched.\n\n")
            } else {
                print("\(self.records.count) RECORDS FETCHED!")
            }
        }
    }
    
}

fileprivate class ProcessRecordsOperation : Operation {
    
    var objects = [AnyObject]()
    let recordType : RecordType
    
    init(recordType: RecordType) {
        self.recordType = recordType
    }
    
    override func main() {
        
        if self.isCancelled {
            return
        }
        
        print("PROCESSING RECORDS")
        
        // Grab the fetched records from the fetch operation that is stored in the dependencies
        guard let fetchOp = self.dependencies.last as? FetchAllOperation else {
            self.cancel()
            return
        }
        
        // Make goals from the records
        for record in fetchOp.records {
            switch self.recordType {
            case .goal:
                self.objects.append(Goal(fromRecord: record))
                continue
            case .transaction:
                self.objects.append(Transaction(fromRecord: record))
                continue
            }
            
        }
        
    }

}

fileprivate class PrepareTransactionQueriesOperation : Operation {
    
    var queries = [CKQueryOperation]()
    var goals = Goals()
    
    override func main() {
        
        // Get the goal objects that we need to make transaction queries for
        guard let processOp = self.dependencies.last as? ProcessRecordsOperation, let goals = processOp.objects as? Goals else {
            self.cancel()
            return
        }
        self.goals = goals
        
        for goal in self.goals {
            
            let recordZone = CKRecordZoneID(zoneName: RecordZone.savings.zoneName, ownerName: CKOwnerDefaultName)
            let recordID = CKRecordID(recordName: goal.id, zoneID: recordZone)
            let reference = CKReference(recordID: recordID, action: .none)
            let predicate = NSPredicate(format: "goal == %@", reference)
            let query = CKQuery(recordType: RecordType.transaction.rawValue, predicate: predicate)
            query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
            
            self.queries.append(CKQueryOperation(query: query))
        }
    }
}


extension CKEngine {
    
    class func seedDummyData(completionHandler: @escaping () -> Void) {
        
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
        CKEngine.privateDatabase.add(deleteZoneOperation)
        CKEngine.privateDatabase.add(saveNewZoneOperation)
        
        // Create some goals with transactions
        let firstGoal = CKRecord(recordType: RecordType.goal.rawValue, zoneID: savingsZone.zoneID)
        firstGoal.setObject("Dumb Phone" as NSString, forKey: GoalKey.description.rawValue)
        firstGoal.setObject(Date.days(away: -10) as NSDate, forKey: GoalKey.startDate.rawValue)
        firstGoal.setObject(Date.weeks(away: 10) as NSDate, forKey: GoalKey.endDate.rawValue)
        firstGoal.setObject(200.00 as NSNumber, forKey: GoalKey.amount.rawValue)
        firstGoal.setObject(Priority.medium.rawValue as NSNumber, forKey: GoalKey.priority.rawValue)
        
        let secondGoal = CKRecord(recordType: RecordType.goal.rawValue, zoneID: savingsZone.zoneID)
        secondGoal.setObject("Dumb Computer" as NSString, forKey: GoalKey.description.rawValue)
        secondGoal.setObject(Date.days(away: -37) as NSDate, forKey: GoalKey.startDate.rawValue)
        secondGoal.setObject(Date.weeks(away: 15) as NSDate, forKey: GoalKey.endDate.rawValue)
        secondGoal.setObject(1300.00 as NSNumber, forKey: GoalKey.amount.rawValue)
        secondGoal.setObject(Priority.high.rawValue as NSNumber, forKey: GoalKey.priority.rawValue)
        
        let firstReference = CKReference(record: firstGoal, action: .none)
        let firstTrans = CKRecord(recordType: RecordType.transaction.rawValue, zoneID: savingsZone.zoneID)
        firstTrans.setObject("Dummy savings transaction #1" as NSString, forKey: TransactionKey.description.rawValue)
        firstTrans.setObject(Date.days(away: -9) as NSDate, forKey: TransactionKey.date.rawValue)
        firstTrans.setObject(10.00 as NSNumber, forKey: TransactionKey.amount.rawValue)
        firstTrans.setObject(firstReference, forKey: TransactionKey.goal.rawValue)
        
        let secondTrans = CKRecord(recordType: RecordType.transaction.rawValue, zoneID: savingsZone.zoneID)
        secondTrans.setObject("Dummy savings transaction #2" as NSString, forKey: TransactionKey.description.rawValue)
        secondTrans.setObject(Date.days(away: -7) as NSDate, forKey: TransactionKey.date.rawValue)
        secondTrans.setObject(3.22 as NSNumber, forKey: TransactionKey.amount.rawValue)
        secondTrans.setObject(firstReference, forKey: TransactionKey.goal.rawValue)
        
        let secondReference = CKReference(record: secondGoal, action: .none)
        let thirdTrans = CKRecord(recordType: RecordType.transaction.rawValue, zoneID: savingsZone.zoneID)
        thirdTrans.setObject("Dummy savings transaction #3" as NSString, forKey: TransactionKey.description.rawValue)
        thirdTrans.setObject(Date.days(away: -30) as NSDate, forKey: TransactionKey.date.rawValue)
        thirdTrans.setObject(18.27 as NSNumber, forKey: TransactionKey.amount.rawValue)
        thirdTrans.setObject(secondReference, forKey: TransactionKey.goal.rawValue)
        
        let fourthTrans = CKRecord(recordType: RecordType.transaction.rawValue, zoneID: savingsZone.zoneID)
        fourthTrans.setObject("Dummy savings transaction #4" as NSString, forKey: TransactionKey.description.rawValue)
        fourthTrans.setObject(Date.days(away: -29) as NSDate, forKey: TransactionKey.date.rawValue)
        fourthTrans.setObject(32.20 as NSNumber, forKey: TransactionKey.amount.rawValue)
        fourthTrans.setObject(secondReference, forKey: TransactionKey.goal.rawValue)
        
        let fifthTrans = CKRecord(recordType: RecordType.transaction.rawValue, zoneID: savingsZone.zoneID)
        fifthTrans.setObject("Dummy savings transaction #5" as NSString, forKey: TransactionKey.description.rawValue)
        fifthTrans.setObject(Date.days(away: -27) as NSDate, forKey: TransactionKey.date.rawValue)
        fifthTrans.setObject(167.30 as NSNumber, forKey: TransactionKey.amount.rawValue)
        fifthTrans.setObject(secondReference, forKey: TransactionKey.goal.rawValue)
        
        
        // Make a save records operation that is dependent on the create zone operation
        let saveDummyRecordsOperation = CKModifyRecordsOperation(recordsToSave: [firstGoal, firstTrans, secondTrans, secondGoal, thirdTrans, fourthTrans, fifthTrans], recordIDsToDelete: nil)
        saveDummyRecordsOperation.modifyRecordsCompletionBlock = { savedRecords, deletedRecordIDs, error in
            print("Saved dummy data to private database")
            completionHandler()
        }
        saveDummyRecordsOperation.addDependency(saveNewZoneOperation)
        
        CKEngine.privateDatabase.add(saveDummyRecordsOperation)
        
    }
    
}

























