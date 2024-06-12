//
//  SettingsView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 4/22/24.
//
//  Description:
//  This file contains the implementation of a settings page where a user
//  can customize different application preferences.

import SwiftUI

struct SettingsView: View {
    @State var userPrefs: UserPrefs
    @State var isFirst: Bool
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Form {
            Picker("Distance Unit", selection: $userPrefs.distanceUnit) {
                ForEach(Unit.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.inline)
            Picker("Speed Unit", selection: $userPrefs.speedUnit) {
                ForEach(Unit.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.inline)
            Picker("Temperature Unit", selection: $userPrefs.tempUnit) {
                ForEach(TempUnit.allCases, id: \.self) {
                    Text($0.rawValue)
                }
            }
            .pickerStyle(.inline)
            Toggle("Favorites", isOn: $userPrefs.favoritesOn)
            Toggle("Shot Tracker", isOn: $userPrefs.trackersOn)
            Toggle("Clubs Quick Add", isOn: $userPrefs.quickAddClubsOn)
        }
        .navigationTitle("Settings")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    //TODO: Maybe the singular settings object logic can be solved or improved here
                    /// There will only every be one or no SwiftData userpref object, if one is not available create it to be used by the rest of the application
                    if (isFirst) {
                        modelContext.insert(userPrefs)
                    }
                    dismiss()
                }, label: {
                    Image(systemName:"chevron.backward")
                        .foregroundStyle(.gray)
                })
            }
        }
    }
}

#Preview {
    let testSettings = UserPrefs.init()
    return SettingsView(userPrefs: testSettings, isFirst: false)
}
