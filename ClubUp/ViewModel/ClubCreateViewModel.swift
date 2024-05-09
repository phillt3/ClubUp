//
//  ClubCreateViewModel.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 5/8/24.
//

import Foundation

extension ClubCreateView{
    class ClubCreateViewModel: ObservableObject {
        @Published public var brand: String = ""
        @Published public var model: String = ""
        @Published public var distance: Int = 0
        @Published public var isFavorite: Bool = false
        @Published public var type: ClubType?
        @Published public var selectedValue: String = ""
        
        let woodValues = (1...10).map { String($0) }
        let hybridValues = (1...10).map { String($0) }
        let ironValues = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "P"]
        let wedgeValues = ["E", "A", "D", "F", "G", "M", "MB", "S", "L"] + (46...72).map { String($0) }
        
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
    }
}
