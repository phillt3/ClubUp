//
//  ClubsListCellView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/18/24.
//
//  Description:
//  This file contains the implementation of a cell view for displaying data for a specific club
//  that the user has created. This data includes brand, model name, distance and more.

import SwiftUI
import SwiftData

struct ClubsListCellView: View {
    var club: Club
    var prefs: UserPrefs
    
    var body: some View {
        /// Setup the cell to navigate to the detail page when tapped
        NavigationLink(destination: ClubDetailView(club: club, prefs: prefs)) {
            HStack {
                /// Provide option to mark club as a favorite from the list cell
                if (prefs.favoritesOn) {
                    Image(systemName: club.favorite ? "star.fill" : "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 25, height: 25)
                        .fontWeight(.thin)
                        .foregroundStyle(Color("Favorite"))
                        .onTapGesture {
                            club.favorite.toggle()
                        }
                }
                Image(club.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .padding(.bottom, -20)
                
                VStack(alignment: .leading) {
                    Text(club.name)
                        .font(.title)
                        .fontWeight(.bold)
                    Text(club.brand)
                        .font(.subheadline)
                        .italic()
                        .foregroundColor(.secondary)
                }
                Spacer()
                /// Present the current assigned distance of the club in the preferred distance unit
                VStack(alignment: .trailing) {
                    if prefs.distanceUnit == Unit.Imperial {
                        distanceView(unitText: "Yards", distance: club.distanceYards)
                    } else {
                        distanceView(unitText: "Meters", distance: club.distanceMeters)
                    }
                }
            }
        }
    }
}

/// A dedicated view builder func to present a reminder label if no distance has been assigned
@ViewBuilder
func distanceView(unitText: String, distance: Int?) -> some View {
    if distance ?? 0 > 0 {
        Text("\(distance!)")
            .font(.title)
            .fontWeight(.bold)
        Text(unitText)
            .font(.subheadline)
            .foregroundColor(.secondary)
    } else {
        Text("Add Distance")
            .font(.subheadline)
            .foregroundStyle(.blue)
    }
}



#Preview {
    let newItem = Club.createClub(brand: "Titleist", model: "Apex", name: "", type: ClubType.iron, number: "9", degree: "", distanceYards: 140, distanceMeters: nil, favorite: false)
    let prefs = UserPrefs()
    return ClubsListCellView(club: newItem, prefs: prefs)
}
