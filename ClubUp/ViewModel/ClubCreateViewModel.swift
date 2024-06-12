//
//  ClubCreateViewModel.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 5/8/24.
//
//  Description:
//  This file contains the implementation of a viewmodel for supporting the data retrieval and formatting
//  of the ClubCreateView

import Foundation
import SwiftData

extension ClubCreateView{
    @Observable
    class ClubCreateViewModel: ObservableObject {
    
        //Create Club Fields
        public var brand: String = ""
        public var model: String = ""
        public var distance: Int = 0
        public var isFavorite: Bool = false
        public var type: ClubType?
        public var selectedValue: String = ""
        
        //Multiple Value
        let woodValues = (1...10).map { String($0) }
        let hybridValues = (1...10).map { String($0) }
        let ironValues = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "P"]
        let wedgeValues = ["E", "A", "D", "F", "G", "M", "MB", "S", "L"] + (46...72).map { String($0) }
        
        var modelContext: ModelContext
        public var prefs: UserPrefs = UserPrefs()
        
        /// Initialize VM with model context to have access to swiftdata structures
        /// - Parameter modelContext: model context for the application
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
        }
        
        /// Fetch relevante swiftdata objects
        public func fetchData() {
            do {
                let descriptor = FetchDescriptor<UserPrefs>()
                let fetchedPrefs = try modelContext.fetch(descriptor)
                if (fetchedPrefs.first != nil) {
                    prefs = fetchedPrefs.first!
                }
            } catch {
                print("Prefs Fetch failed")
            }
        }
        
        /// Determin what clubs numeric values to present based on selected club type
        /// - Parameter type: selected club type
        /// - Returns: returns array of numeric club values
        public func getSelection(type: ClubType) -> [String] {
            switch type {
            case .wood:
                return woodValues
            case .iron:
                return ironValues
            case .hybrid:
                return hybridValues
            case .wedge:
                return wedgeValues
            }
        }
        
        /// Create custom club based on user inputs
        /// - Returns: returns club object
        public func createClub() -> Club {
            if (selectedValue == "") {
                switch type! {
                case .wood:
                    fallthrough
                case .iron:
                    fallthrough
                case .hybrid:
                    selectedValue = "1"
                case .wedge:
                    selectedValue = "E"
                }
            }
            
            let isImperial: Bool = prefs.distanceUnit == Unit.Imperial
            
            return Club.createClub(brand: brand, model: model, name: "", type: type!, number: selectedValue, degree: selectedValue, distanceYards: isImperial ? distance : nil, distanceMeters: isImperial ? nil : distance, favorite: isFavorite)
        }
    }
}
