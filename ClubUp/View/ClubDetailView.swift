//
//  ClubDetailView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/19/24.
//
//  Description:
//  This file contains the implementation of a Detail view for displaying a club dedicated page 
//  where the user can view club stats.

import SwiftUI
import SwiftData

struct ClubDetailView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusItem: Bool
    
    @State var club: Club
    @Query private var userPrefs: [UserPrefs]
    
    var prefs: UserPrefs
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                /// display stylized image of club with name brand and model
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    Image(club.imageName)
                        .resizable()
                        .shadow(radius: 8)
                    HStack {
                        VStack(alignment: .leading) {
                            Spacer()
                            Text(club.brand)
                                .font(.custom("Arial Rounded MT Bold", size: 28))
                                .textCase(.uppercase)
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 1, x: 0, y: 1)
                                .tracking(1)
                            HStack {
                                Text(club.model)
                                    .font(.custom("Avenir-Heavy", size: 36))
                                    .textCase(.uppercase)
                                    .foregroundColor(.white)
                                    .italic()
                                    .shadow(color: .black, radius: 1, x: 0, y: 1)
                                    .tracking(1)
                                Text(club.name)
                                    .font(.custom("Avenir-Heavy", size: 36))
                                    .textCase(.uppercase)
                                    .foregroundColor(.white)
                                    .shadow(color: .black, radius: 1, x: 0, y: 1)
                                    .tracking(1)
                            }
                        }
                        .padding()
                        Spacer()
                    }
                }
                .frame(height: 400)
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                        .frame(height: 75)
                        .padding(.horizontal)
                    
                    /// display current distance of club and option to edit it
                    HStack {
                        Text("Distance " + (prefs.distanceUnit == Unit.Imperial ? "(Yards)" : "(Meters)"))
                            .font(.title2)
                            .padding(.leading)
                            .bold()
                        Spacer()
                        if (prefs.distanceUnit == Unit.Imperial) { //TODO: THis can be done better
                            TextField("0", value: $club.distanceYards, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: 75)
                                .font(.title2)
                                .bold()
                                .multilineTextAlignment(.center)
                                .padding(.trailing)
                                .onSubmit { focusItem = false }
                                .focused($focusItem)
                        } else if (prefs.distanceUnit == Unit.Metric) {
                            TextField("0", value: $club.distanceMeters, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: 75)
                                .font(.title2)
                                .bold()
                                .multilineTextAlignment(.center)
                                .padding(.trailing)
                                .onSubmit { focusItem = false }
                                .focused($focusItem)
                        }

                    }
                    .padding()
                }
                
                /// present favorite icon and option to toggle it
                if (prefs.favoritesOn) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                            .frame(height: 75)
                            .padding(.horizontal)
                        HStack {
                            Text("Favorite")
                                .font(.title2)
                                .padding(.leading)
                                .bold()
                            Spacer()
                            Image(systemName: club.favorite ? "star.fill" : "star")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 40, height: 40)
                                .fontWeight(.thin)
                                .foregroundStyle(.yellow)
                                .padding(.trailing, 25)
                                .onTapGesture {
                                    club.favorite.toggle()
                                }
                        }
                        .padding()
                    }
                }
                
                /// present shot tracker good shot bad shot percentage
                if (prefs.trackersOn) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white)
                            .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2)
                            .frame(height: 75)
                            .padding(.horizontal)
                        HStack {
                            Text("Good Shot %")
                                .font(.title2)
                                .padding(.leading)
                                .bold()
                            Spacer()
                            Text("\(club.calculateGoodShotPercentage()) %")
                                .font(.title2)
                                .padding(.trailing)
                                .bold()
                        }
                        .padding()
                    }
                }
            }
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        /// on dismiss, format distance if it was edited and update swiftdata object
                        if let distance = prefs.distanceUnit == Unit.Imperial ? club.distanceYards : club.distanceMeters {
                            if prefs.distanceUnit == Unit.Imperial {
                                club.modifyDistanceYards(yards: distance)
                            } else {
                                club.modifyDistanceMeters(meters: distance)
                            }
                        } else {
                            if prefs.distanceUnit == Unit.Imperial {
                                club.distanceYards = 0
                            } else {
                                club.distanceMeters = 0
                            }
                        }
                        modelContext.insert(club)
                        dismiss()
                    }, label: {
                        Image(systemName:"chevron.backward")
                            .foregroundStyle(.gray)
                    })
                }
            }
        }
        .onTapGesture{
            focusItem = false
        }
    }
}

#Preview {
    let newItem = Club.createClub(brand: "Callaway", model: "Apex", name: "", type: ClubType.iron, number: "9", degree: "", distanceYards: 140, distanceMeters: nil, favorite: false)
    return ClubDetailView(club: newItem, prefs: UserPrefs())
}
