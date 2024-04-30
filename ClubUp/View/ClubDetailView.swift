//
//  ClubDetailView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/19/24.
//

import SwiftUI
import SwiftData

struct ClubDetailView: View {
    @State var club: Club
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var userPrefs: [UserPrefs]
    
    var prefs: UserPrefs
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
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
                    HStack {
                        if (prefs.distanceUnit == Unit.Imperial) {
                            Text("Distance (Yards)")
                                .font(.title2)
                                .padding(.leading)
                                .bold()
                            Spacer()
                            TextField("0", value: $club.distanceYards, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: 75)
                                .font(.title2)
                                .bold()
                                .multilineTextAlignment(.center)
                                .padding(.trailing)
                        } else if (prefs.distanceUnit == Unit.Metric) {
                            Text("Distance (Meters)")
                                .font(.title2)
                                .padding(.leading)
                                .bold()
                            Spacer()
                            TextField("0", value: $club.distanceMeters, format: .number)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .keyboardType(.numberPad)
                                .frame(width: 75)
                                .font(.title2)
                                .bold()
                                .multilineTextAlignment(.center)
                                .padding(.trailing)
                        }

                    }
                    .padding()
                }
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
                        if (club.distanceYards != nil) {
                            modelContext.insert(club)
                            dismiss()
                        } else {
                            club.distanceYards = 0
                            modelContext.insert(club)
                            dismiss()
                        }
                    }, label: {
                        Image(systemName:"chevron.backward")
                            .foregroundStyle(.gray)
                    })
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: SettingsView(userPrefs: userPrefs.first ?? UserPrefs(), isFirst: userPrefs.isEmpty)) {
                        Image(systemName:"gearshape")
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }
}

#Preview {
    let newItem = Club.createClub(brand: "Callaway", model: "Apex", name: "", type: ClubType.iron, number: "9", degree: "", distanceYards: 140, distanceMeters: nil, favorite: false)
    return ClubDetailView(club: newItem, prefs: UserPrefs())
}
