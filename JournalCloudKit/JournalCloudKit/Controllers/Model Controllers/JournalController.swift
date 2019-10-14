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
    
    func addEntry(with title: String, bodyText: String, completion: @escaping (_ success: Bool) -> (Void)) {
        let newEntry = Entry(title: title, bodyText: bodyText)
        entries.append(newEntry)
    }
    
    func removeEntry(with entry: Entry) {
        guard let entryIndex = entries.firstIndex(of: entry) else { return }
        entries.remove(at: entryIndex)
    }
    
    func updateEntry(entry: Entry, with title: String, bodyText: String, completion: @escaping (_ success: Bool) -> (Void)) {
        entry.title = title
        entry.bodyText = bodyText
    }
    
    func fetchEntry(completion: @escaping (_ success: Bool) -> (Void)) {
        
        let predicate = NSPredicate(value: true)
        
        let query = CKQuery(recordType: JournalStrings.recordTypeKey, predicate: predicate)
        
        privateDataBase.perform(query, inZoneWith: nil) { (foundRecords, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                completion(false)
                return
            }
            
            guard let records = foundRecords else { completion(false) ; return }
            let entries = records.compactMap( { Entry(ckRecord: $0) } )
 
            // This is what compactMap is doing
//            var arrayOfEntries: [Entry] = []
//            for record in records {
//                let entry = Entry(ckRecord: record)
//                if entry != nil {
//                    arrayOfEntries.append(entry!)
//                }
//            }
            
            self.entries = entries
            completion(true)
        }
    }
    
} //end of class
