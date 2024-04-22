//
//  ClubGroupType.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/17/24.
//

import Foundation

enum ClubType: Codable {
    case wood
    case iron
    case hybrid
    case wedge
}

enum Unit: String, CaseIterable, Codable {
    case Imperial = "Imperial (Yards, Miles)"
    case Metric = "Metric (Meters, Kilometers)"
}


