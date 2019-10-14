//
//  JournalController.swift
//  JournalCloudKit
//
//  Created by Josh Sparks on 10/14/19.
//  Copyright © 2019 Josh Sparks. All rights reserved.
//

import Foundation
import CloudKit

class JournalController {
    
    static let sharedInstance = JournalController()
    let privateDataBase = CKContainer.default().privateCloudDatabase
    
    var entries: [Entry] = []
    
    
    // CRUD
    func saveEntry(with title: String, bodyText: String, completion: @escaping (_ success: Bool) ->(Void)) {
        
        let newEntry = Entry(title: title, bodyText: bodyText)
        
        let entryRecord = CKRecord(entry: newEntry)
        
        privateDataBase.save(entryRecord) { (record, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            
            guard let record = record,
            let savedEntry = Entry(ckRecord: record)
                else { completion(false) ; return }
            self.entries.append(savedEntry)
            print("Saved entry successfully")
            completion(true)
        }
    }
    
    
} //end of class
