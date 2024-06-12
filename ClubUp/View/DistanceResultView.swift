//
//  DistanceFoundView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 5/5/24.
//
//  Description:
//  This file contains the implementation of the result view for displaying the calculated distance.
//  From this view a user can also mark their shot as good or bad if they have shot tracking enabled in preferences.

import SwiftUI
import SwiftData

struct DistanceResultView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) var modelContext
    @State var distanceCalcVM: DistanceCalcView.DistanceCalcViewModel
    
    @Query public var userPrefs: [UserPrefs]
    
    var distance: Int
    var club: Club?
    
    var body: some View {
        VStack{
            /// club is the passed in recommended club, but recClub is used to safely update the shot tracker
            if let recClub = club {
                Text("\(distance) \(UserPrefs.getCurrentPrefs(prefs: userPrefs).distanceUnit == .Imperial ? "Yards" : "Meters")")
                    .font(.system(size: 55, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)

                Text(recClub.name)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(EdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)) // Add more padding
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0.8), Color.black.opacity(0.5)]), startPoint: .top, endPoint: .bottom)) // Apply a gradient background
                            .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 3) // Add a shadow to the background
                    )
                /// If the setting is turned on and the club is a favorite, add a star behind the club image
                if (UserPrefs.getCurrentPrefs(prefs: userPrefs).favoritesOn && recClub.favorite) {
                    ZStack {
                        Image(systemName: "star.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundStyle(.yellow)
                            .fontWeight(.thin)
                        
                        Image(recClub.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    }
                } else {
                    Image(recClub.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                
                /// if setting is turned on, allow user to track result shot as good or bad, reset the calculation data, and return to the calculation page
                if (UserPrefs.getCurrentPrefs(prefs: userPrefs).trackersOn) {
                    HStack {
                        Button("Bad Shot") {
                            recClub.addShot()
                            distanceCalcVM.calcData.reset()
                            dismiss()
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(.red)
                        .cornerRadius(10)
                        Button(action: {
                            recClub.addGoodShot()
                            distanceCalcVM.calcData.reset()
                            dismiss()
                        }) {
                          Text("Good Shot")
                            .padding()
                            .foregroundColor(.white)
                            .background(.green)
                            .cornerRadius(10)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                } else {
                    /// shot tracker is not turned on so simply give option to clear and return
                    Button("Reset") {
                        distanceCalcVM.calcData.reset()
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                }

            } else {
                /// a distance has been calculated but no club provided meaning no clubs are added, show distance but recommend adding clubs
                Text("\(distance) \(UserPrefs.getCurrentPrefs(prefs: userPrefs).distanceUnit == .Imperial ? "Yards" : "Meters")")
                    .font(.system(size: 55, weight: .bold, design: .monospaced))
                    .foregroundColor(.black)
                    .shadow(color: .gray, radius: 2, x: 0, y: 2)
                
                Text("Add Clubs To Get Recommendation")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding()
                
                Button("Reset") {
                    distanceCalcVM.calcData.reset()
                    dismiss()
                }
                .buttonStyle(.bordered)
            }
        }
        .padding()
    }
    
}


