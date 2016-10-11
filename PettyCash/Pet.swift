//
//  Pet.swift
//  PettyCash
//
//  Created by Emeka Okoye on 10/6/16.
//  Copyright © 2016 Joshua O'Steen. All rights reserved.
//

import Foundation
import CloudKit
import UIKit
// Represents various CKRecord keys corresponding to this class's properties
enum PetKey : String {
    case id = "id"
    case name = "name"
    case type = "type"
}

typealias Pets = [Pet]

struct Pet {
    let id : String
    let name : String
    let type : String
    
    init(withName name: String, isType type: String){
        if #available(iOS 10.0, *) {
            self.id = CKCurrentUserDefaultName + "_" + UIDevice.current.name
        } else {
            self.id = name + "_" + UIDevice.current.name
            // Fallback on earlier versions
        } //new id generated from current user
        self.name = name
        self.type = type
    }
    
    init(fromRecord record: CKRecord) {
        self.id = record.recordID.recordName
        self.name = record.object(forKey: "name") as! String
        self.type = record.object(forKey: "type") as! String
    }

}
