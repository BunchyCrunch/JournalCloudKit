//
//  Journal.swift
//  JournalCloudKit
//
//  Created by Josh Sparks on 10/14/19.
//  Copyright © 2019 Josh Sparks. All rights reserved.
//

import Foundation
import CloudKit

struct JournalStrings {
    static let recordTypeKey = "Entry"
    fileprivate static let titleKey = "title"
    fileprivate static let bodyTextKey = "bodyText"
    fileprivate static let timestampKey = "timestamp"
}

class Entry {
    var title: String
    var bodyText: String
    var timestamp: Date
    var ckRecordID: CKRecord.ID
    
    init(title: String, bodyText: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.bodyText = bodyText
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
    
}

extension Entry {
    convenience init? (ckRecord: CKRecord) {
        guard let title = ckRecord[JournalStrings.titleKey] as? String,
            let bodyText = ckRecord[JournalStrings.bodyTextKey] as? String,
            let timestamp = ckRecord[JournalStrings.timestampKey] as? Date
            else { return nil }
        
        self.init(title: title, bodyText: bodyText, timestamp: timestamp)
    }
}

extension CKRecord {
    
    convenience init(entry: Entry) {
        self.init(recordType: JournalStrings.recordTypeKey, recordID: entry.ckRecordID)
        
        self.setValuesForKeys([
            JournalStrings.titleKey : entry.title,
            JournalStrings.bodyTextKey : entry.bodyText,
            JournalStrings.timestampKey : entry.timestamp
        ])
        
    }
}

extension Entry: Equatable {
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
}
