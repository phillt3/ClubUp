//  Created by Phillip  Tracy on 3/16/24.

import Foundation
import SwiftData

/*
 This model defines the structure and properties of a golf club for a virtual golf bag
 */
@Model
class Club {
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
    
    //General Init
    private init(brand: String, model: String, name: String, type: ClubType, number: String, degree: String, distanceYards: Int?, distanceMeters: Int?, favorite: Bool, id: UUID = UUID()) {
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
    }
    
    //Factory Method
    public static func createClub(brand: String, model: String, name: String, type: ClubType, number: String, degree: String, distanceYards: Int?, distanceMeters: Int?, favorite: Bool) -> Club{
        
        //Perform distance conversion
        var yards: Int?
        var meters: Int?
        
        if let yardsValue = distanceYards {
            yards = yardsValue
            meters = yardsToMeters(yards: yardsValue)
        } else if let metersValue = distanceMeters {
            meters = metersValue
            yards = metersToYards(meters: metersValue)
        }
        
        switch type {
        case .wood:
            return createWood(brand: brand, model: model, number: number, distanceYards: yards, distanceMeters: meters, favorite: favorite)
        case .iron:
            return createIron(brand: brand, model: model, number: number, distanceYards: yards, distanceMeters: meters, favorite: favorite)
        case .hybrid:
            return createHybrid(brand: brand, model: model, number: number, distanceYards: yards, distanceMeters: meters, favorite: favorite)
        case .wedge:
            return createWedge(brand: brand, model: model, degree: degree, distanceYards: yards, distanceMeters: meters, favorite: favorite)
        }

    }
    
    //Specialized Factory Methods
    
    /*
     This method creates a club object with wood specifications
     */
    private static func createWood(brand: String, model: String, number: String, distanceYards: Int?, distanceMeters: Int?, favorite: Bool) -> Club {
        
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
        
        return Club(brand: brand, model: model, name: name, type: ClubType.wood, number: number, degree: "", distanceYards: distanceYards, distanceMeters: distanceMeters, favorite: favorite)
    }
    
    /*
     This method creates a club object with hybrid specifications
     */
    private static func createHybrid(brand: String, model: String, number: String, distanceYards: Int?, distanceMeters: Int?, favorite: Bool) -> Club {
        
        //Hybrid naming convention is number + 'Hy'
        var name = ""
        if let _ = Int(number) {
            name = "\(number)Hy"
        } else {
            name = "Hy"
        }
        
        return Club(brand: brand, model: model, name: name, type: ClubType.hybrid, number: number, degree: "", distanceYards: distanceYards, distanceMeters: distanceMeters, favorite: favorite)
    }
    
    /*
     This method creates a club object with iron specifications
     */
    private static func createIron(brand: String, model: String, number: String, distanceYards: Int?, distanceMeters: Int?, favorite: Bool) -> Club {
        
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
        
        return Club(brand: brand, model: model, name: name, type: ClubType.iron, number: number, degree: "", distanceYards: distanceYards, distanceMeters: distanceMeters, favorite: favorite)
    }
    
    /*
     This method creates a club object with wedge specifications
     */
    private static func createWedge(brand: String, model: String, degree: String, distanceYards: Int?, distanceMeters: Int?, favorite: Bool) -> Club {
        
        //Wedge naming conventions are W-deg but for wedges with no specific degree then it is letter + 'w' like 'Pw, Gw, Sw, Lw'
        var name = ""
        if let _ = Int(degree) {
            name = "W-\(degree)"
        } else {
            if let firstChar = degree.uppercased().first {
                name = "\(firstChar)w"
            } else {
                name = "W"
            }
        }
        
        return Club(brand: brand, model: model, name: name, type: ClubType.wedge, number: "", degree: degree, distanceYards: distanceYards, distanceMeters: distanceMeters, favorite: favorite)
    }
    
    //Class Functions
    func modifyDistanceYards(yards: Int) {
        self.distanceYards = yards
        self.distanceMeters = Club.yardsToMeters(yards: yards)
    }
    
    func modifyDistanceMeters(meters: Int) {
        self.distanceMeters = meters
        self.distanceYards = Club.metersToYards(meters: meters)
    }
        
    //HelperMethods
    private static func yardsToMeters(yards: Int) -> Int {
        return Int(round(Double(yards) * 0.9144))
    }
    
    private static func metersToYards(meters: Int) -> Int {
        return Int(round(Double(meters) / 0.9144))
    }
}
