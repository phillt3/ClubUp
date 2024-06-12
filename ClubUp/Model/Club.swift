//
//  Club.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/16/24.
//
//  Description:
//  This file contains the implementation of a model that defines the 
//  structure and properties of a golf club for a virtual golf bag.

import Foundation
import SwiftData

@Model
class Club: CustomStringConvertible {
    
    //Model Properties
    @Attribute(.unique) var id: UUID // Unique identifier for the club
    var brand: String //Club Producer (Titleist, Callaway, PXG, TaylorMade...)
    var model: String //Club Title (Apex, Big Bertha, DCI 962B, MP 14...)
    var name: String //Club Name (Dr, 2w, 4Hy, 9i, PW, W-56...)
    var type: ClubType //Enum classification for club (wood, hybrid, iron, wedge
    var number: String // Number of club (1-10, 1-P)
    var degree: String // Loft degree (46 - 72)
    var distanceYards: Int? //How far club is hit in yards
    var distanceMeters: Int? //How far club is hit in meters
    var favorite: Bool //Is the club favored
    var shots: Int = 0
    var goodShots: Int = 0
    var rank: Int
    var imageName: String = ""
    
    var description: String {
        return "\(self.name)(rank: \(self.rank))"
    }
    
    /// Out of the box club objects, precrafted for the user to quick add
    public static let recommendedClubs : [String : Club] =
    [
        "Dr" : Club.createWood(brand: "", model: "", number: "1", distanceYards: 0, distanceMeters: 0, favorite: false, rank: 1),
        "3w" : Club.createWood(brand: "", model: "", number: "3", distanceYards: 0, distanceMeters: 0, favorite: false, rank: 3),
        "5w" : Club.createWood(brand: "", model: "", number: "5", distanceYards: 0, distanceMeters: 0, favorite: false, rank: 5),
        "3i" : Club.createIron(brand: "", model: "", number: "3", distanceYards: 0, distanceMeters: 0, favorite: false, rank: 23),
        "4i" : Club.createIron(brand: "", model: "", number: "4", distanceYards: 0, distanceMeters: 0, favorite: false, rank: 24),
        "5i" : Club.createIron(brand: "", model: "", number: "5", distanceYards: 0, distanceMeters: 0, favorite: false, rank: 25),
        "6i" : Club.createIron(brand: "", model: "", number: "6", distanceYards: 0, distanceMeters: 0, favorite: false, rank: 26),
        "7i" : Club.createIron(brand: "", model: "", number: "7", distanceYards: 0, distanceMeters: 0, favorite: false, rank: 27),
        "8i" : Club.createIron(brand: "", model: "", number: "8", distanceYards: 0, distanceMeters: 0, favorite: false, rank: 28),
        "9i" : Club.createIron(brand: "", model: "", number: "9", distanceYards: 0, distanceMeters: 0, favorite: false, rank: 29),
        "Pw" : Club.createIron(brand: "", model: "", number: "P", distanceYards: 0, distanceMeters: 0, favorite: false, rank: 30),
        "Aw" : Club.createWedge(brand: "", model: "", degree: "A", distanceYards: 0, distanceMeters: 0, favorite: false, rank: 51),
        "W52" : Club.createWedge(brand: "", model: "", degree: "52", distanceYards: 0, distanceMeters: 0, favorite: false, rank: 52),
        "W56" : Club.createWedge(brand: "", model: "", degree: "56", distanceYards: 0, distanceMeters: 0, favorite: false, rank: 56),
        "W60" : Club.createWedge(brand: "", model: "", degree: "60", distanceYards: 0, distanceMeters: 0, favorite: false, rank: 60)
    ]
    
    //General Init
    init(brand: String = "", model: String = "", name: String = "", type: ClubType = ClubType.iron, number: String = "", degree: String = "", distanceYards: Int? = 0, distanceMeters: Int? = 0, favorite: Bool = false, rank: Int = -1, imageName: String = "", id: UUID = UUID()) {
        self.id = id
        self.brand = brand
        self.model = model
        self.name = name
        self.type = type
        self.number = number
        self.degree = degree
        self.distanceYards = distanceYards
        self.distanceMeters = distanceMeters
        self.favorite = favorite
        self.rank = rank
        self.imageName = imageName
    }
    
    //Factory Method
    public static func createClub(brand: String, model: String, name: String, type: ClubType, number: String, degree: String, distanceYards: Int?, distanceMeters: Int?, favorite: Bool) -> Club{
        
        //Perform distance conversion
        var yards: Int?
        var meters: Int?
        
        if let yardsValue = distanceYards {
            yards = yardsValue
            meters = HelperMethods.yardsToMeters(yards: yardsValue)
        } else if let metersValue = distanceMeters {
            meters = metersValue
            yards = HelperMethods.metersToYards(meters: metersValue)
        }
        
        let rank = calculateRank(type: type, number: number, degree: degree)
        
        switch type {
        case .wood:
            return createWood(brand: brand, model: model, number: number, distanceYards: yards, distanceMeters: meters, favorite: favorite, rank: rank)
        case .iron:
            return createIron(brand: brand, model: model, number: number, distanceYards: yards, distanceMeters: meters, favorite: favorite, rank: rank)
        case .hybrid:
            return createHybrid(brand: brand, model: model, number: number, distanceYards: yards, distanceMeters: meters, favorite: favorite, rank: rank)
        case .wedge:
            return createWedge(brand: brand, model: model, degree: degree, distanceYards: yards, distanceMeters: meters, favorite: favorite, rank: rank)
        }

    }
    
    //Specialized Factory Methods
    
    /*
     This method creates a club object with wood specifications
     */
    private static func createWood(brand: String, model: String, number: String, distanceYards: Int?, distanceMeters: Int?, favorite: Bool, rank: Int) -> Club {
        
        //Wood naming conventions are typically number + 'w' but if number is 1, then the wood is a driver, so set to 'Dr'
        var name = ""
        if let i = Int(number) {
            if (i == 1){
                name = "Dr"
            } else {
                name = "\(number)w"
            }
        } else {
            name = "Wd"
        }
        
        return Club(brand: brand, model: model, name: name, type: ClubType.wood, number: number, degree: "", distanceYards: distanceYards, distanceMeters: distanceMeters, favorite: favorite, rank: rank, imageName: "default-driver")
    }
    
    /*
     This method creates a club object with hybrid specifications
     */
    private static func createHybrid(brand: String, model: String, number: String, distanceYards: Int?, distanceMeters: Int?, favorite: Bool, rank: Int) -> Club {
        
        //Hybrid naming convention is number + 'Hy'
        var name = ""
        if let _ = Int(number) {
            name = "\(number)Hy"
        } else {
            name = "Hy"
        }
        
        return Club(brand: brand, model: model, name: name, type: ClubType.hybrid, number: number, degree: "", distanceYards: distanceYards, distanceMeters: distanceMeters, favorite: favorite, rank: rank, imageName: "default-hybrid")
    }
    
    /*
     This method creates a club object with iron specifications
     */
    private static func createIron(brand: String, model: String, number: String, distanceYards: Int?, distanceMeters: Int?, favorite: Bool, rank: Int) -> Club {
        
        //Iron naming convention is number + 'i' but some consider low wedges as irons
        var name = ""
        if let _ = Int(number) {
            name = "\(number)i"
        } else {
            if let firstChar = number.uppercased().first {
                name = "\(firstChar)w"
            } else {
                name = "I"
            }
        }
        
        return Club(brand: brand, model: model, name: name, type: ClubType.iron, number: number, degree: "", distanceYards: distanceYards, distanceMeters: distanceMeters, favorite: favorite, rank: rank, imageName: "default-iron")
    }
    
    /*
     This method creates a club object with wedge specifications
     */
    private static func createWedge(brand: String, model: String, degree: String, distanceYards: Int?, distanceMeters: Int?, favorite: Bool, rank: Int) -> Club {
        
        //Wedge naming conventions are W-deg but for wedges with no specific degree then it is letter + 'w' like 'Pw, Gw, Sw, Lw'
        var name = ""
        if let _ = Int(degree) {
            name = "W\(degree)"
        } else {
            if let firstChar = degree.uppercased().first {
                name = "\(firstChar)w"
            } else {
                name = "W"
            }
        }
        
        return Club(brand: brand, model: model, name: name, type: ClubType.wedge, number: "", degree: degree, distanceYards: distanceYards, distanceMeters: distanceMeters, favorite: favorite, rank: rank, imageName: "default-wedge")
    }
    
    //Class Functions
    
    /// Convert the value of the current club distance in yards to meters
    /// - Parameter yards: Current club distance in yards
    func modifyDistanceYards(yards: Int) {
        self.distanceYards = yards
        self.distanceMeters = HelperMethods.yardsToMeters(yards: yards)
    }
    
    /// Convert the value of the current club distance in meters to yards
    /// - Parameter meters: Current club distance in meters
    func modifyDistanceMeters(meters: Int) {
        self.distanceMeters = meters
        self.distanceYards = HelperMethods.metersToYards(meters: meters)
    }
    
    /// Track good shot
    func addGoodShot() {
        self.goodShots += 1
        self.shots += 1
    }
    
    
    /// Track shot
    func addShot() {
        self.shots += 1
    }
    
    /// Calculate what percentage of total shots tracked have been marked as good shots
    /// - Returns: Int representing percentage of good shots
    func calculateGoodShotPercentage() -> Int {
        if(self.shots == 0) {
            return 0
        }
        let decimalPercentage = Double(self.goodShots) / Double(self.shots)
        return Int(decimalPercentage * 100)
    }
    
    /// Based on the type, number, and degree, determine how this club ranks so that it can be order properly in the clubs list
    /// - Parameters:
    ///   - type: Club type
    ///   - number: Club's numerical representation
    ///   - degree: Club's degree of loft
    /// - Returns: Int value representing its rank (1 being the farthest club - a driver)
    public static func calculateRank(type: ClubType, number: String, degree: String) -> Int {
        switch type {
        case .wood:
            return Int(number) ?? -1 //should never be -1, will include ranks 1 - 10
        case .hybrid:
            return (Int(number) ?? -11) + 10 //should never be -1, will include ranks 11 - 20
        case .iron:
            return (Int(number) ?? 10) + 20 //only a Pw is considered as an Iron and would not be converted to a int, will include ranks 21 - 30
        case .wedge:
            let wRank = Int(degree) ?? 0 //wwedges will range from 46 - 72, they will have their own ranking within this range
            //Wedges will always be at the bottom but if they are a letter club, need to convert to their degree
            if wRank == 0 {
                if number == "E" {
                    return 50
                } else if degree == "A" {
                    return 51
                } else if degree == "D" {
                    return 52
                } else if degree == "F" {
                    return 52
                } else if degree == "G" {
                    return 52
                } else if degree == "M" {
                    return 55
                } else if degree == "MB" {
                    return 56
                } else if degree == "S" {
                    return 56
                } else if degree == "L" {
                    return 60
                }
            } else {
                return wRank
            }
        }
        return -1
    }
    
    //TODO: Need to revisit the below method, because we are essentially performing nested loops twice, here and below in the view, very unoptimized.
    public static func isMissingRecommendedClubs(clubs: [Club]) -> Bool {
        for (key, _) in recommendedClubs {
            if !clubs.contains(where: {$0.name == key }) {
                return true
            }
        }
        return false
    }
}
