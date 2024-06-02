//
//  ClubCreateViewModel.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 5/8/24.
//

import Foundation

extension ClubCreateView{
    @Observable
    class ClubCreateViewModel: ObservableObject {
        
        public var brand: String = ""
        public var model: String = ""
        public var distance: Int = 0
        public var isFavorite: Bool = false
        public var type: ClubType?
        public var selectedValue: String = ""
        
        let woodValues = (1...10).map { String($0) }
        let hybridValues = (1...10).map { String($0) }
        let ironValues = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "P"]
        let wedgeValues = ["E", "A", "D", "F", "G", "M", "MB", "S", "L"] + (46...72).map { String($0) }
        
        public var prefs: UserPrefs //TODO: Can we make it so that the user prefs are not passed in here?
        
        init(prefs: UserPrefs ) {
            self.prefs = prefs
        }
        
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
