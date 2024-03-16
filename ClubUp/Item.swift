//
//  Item.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/16/24.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
