//
//  DateExtension.swift
//  JournalCloudKit
//
//  Created by Josh Sparks on 10/14/19.
//  Copyright © 2019 Josh Sparks. All rights reserved.
//

import Foundation

extension Date {
    
    func formatDate() -> String {
             
             let formatter = DateFormatter()
             formatter.dateStyle = .short
             formatter.timeStyle = .short
             return formatter.string(from: self)
         }
}
