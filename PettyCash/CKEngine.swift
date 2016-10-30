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
        
        // Delete existing zones (effectively deleting all records)
        self.delete(zones: RecordZone.savings, RecordZone.expenses)
        
        // Create the zones and corresponding dummy data
        let savingsZone = CKRecordZone(zoneName: RecordZone.savings.zoneName)
        self.saveRecordZone(savingsZone)
        
        let expensesZone = CKRecordZone(zoneName: RecordZone.expenses.zoneName)
        self.saveRecordZone(expensesZone)
        
        // Create some goals with transactions
        let firstGoal = CKRecord(recordType: RecordType.goal.rawValue, zoneID: savingsZone.zoneID)
        firstGoal.setObject("Dumb Phone" as NSString, forKey: GoalKey.description.rawValue)
        firstGoal.setObject(Date.days(away: -10) as NSDate, forKey: GoalKey.startDate.rawValue)
        firstGoal.setObject(Date.weeks(away: 40) as NSDate, forKey: GoalKey.endDate.rawValue)
        firstGoal.setObject(200.00 as NSNumber, forKey: GoalKey.amount.rawValue)
        firstGoal.setObject(Priority.high.rawValue as NSNumber, forKey: GoalKey.priority.rawValue)
        
        self.privateDatabase.save(firstGoal) { record, error in
            if error != nil {
                fatalError("*** ERROR SAVING DUMMY GOAL ***")
            }
        }
        
        let reference = CKReference(record: firstGoal, action: CKReferenceAction.deleteSelf)
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
        
        self.privateDatabase.save(firstTrans) { record, error in
            if error != nil {
                fatalError("*** ERROR SAVING DUMMY GOAL ***")
            }
        }
        
        self.privateDatabase.save(secondTrans) { record, error in
            if error != nil {
                fatalError("*** ERROR SAVING DUMMY GOAL ***")
            }
        }
        
        
    }
    
    private class func delete(zones zonesToDelete: RecordZone...) {
        
        // Get a reference to all the zones in the private database
        self.privateDatabase.fetchAllRecordZones { (returnZones, error) in
            
            if error != nil {
                fatalError("*** ERROR FETCHING ALL RECORD ZONES ***")
            }
            
            guard let returnZones = returnZones else {
                fatalError("*** FETCHING ALL ZONES RETURNED NO ZONES IDs ***")
            }
            
            for zone in returnZones {
                guard let zoneType = RecordZone(rawValue: zone.zoneID.zoneName) else {
                    continue
                }
                
                if zonesToDelete.contains(zoneType) {
                    self.privateDatabase.delete(withRecordZoneID: zone.zoneID) { zoneID, error in
                        if error != nil {
                            fatalError("*** ERROR DELETING ZONE WITH ID: \(zoneID?.zoneName) ***")
                        } else {
                            print("Deleted the \(zoneID?.zoneName) zone")
                        }
                    }
                }
            }
            
        }
        
    }
    
    
    private class func saveRecordZone(_ recordZone: CKRecordZone) {
        
        CKEngine.privateDatabase.save(recordZone) { zone, error in
            
            if error != nil {
                // Error saving the zone
                fatalError("*** ERROR SAVING RECORD ZONE ***\n\n" + error!.localizedDescription)
            } else {
                print("Saved the \(zone?.zoneID.zoneName)) zone")
            }
            
        }
        
    }
    
}















































