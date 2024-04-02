//
//  ClubDetailView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/19/24.
//

import SwiftUI

struct ClubDetailView: View {
    @State var club: Club
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.black, Color.blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    Image("golf-club")
                        .resizable()
                        .shadow(radius: 8)
                    HStack {
                        VStack(alignment: .leading) {
                            Spacer()
                            Text(club.brand)
                                .font(.custom("Arial Rounded MT Bold", size: 28))
                                .textCase(.uppercase)
                                .foregroundColor(.white)
                                .shadow(color: .black, radius: 1, x: 0, y: 1) // Adding shadow
                                .tracking(1) // Adding letter spacing
                            HStack {
                                Text(club.model)
                                    .font(.custom("Avenir-Heavy", size: 36))
                                    .textCase(.uppercase)
                                    .foregroundColor(.white)
                                    .italic()
                                    .shadow(color: .black, radius: 1, x: 0, y: 1) // Adding shadow
                                    .tracking(1) // Adding letter spacing
                                Text(club.name)
                                    .font(.custom("Avenir-Heavy", size: 36))
                                    .textCase(.uppercase)
                                    .foregroundColor(.white)
                                    .shadow(color: .black, radius: 1, x: 0, y: 1) // Adding shadow
                                    .tracking(1) // Adding letter spacing
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
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2) // Adding shadow
                        .frame(height: 75)
                        .padding(.horizontal)
                    HStack {
                        Text("Distance (Yds)")
                            .font(.title2)
                            .padding(.leading)
                            .bold()
                        Spacer()
                        TextField("0", value: $club.distanceYards, format: .number)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .keyboardType(.numberPad)
                            .frame(width: 75) // Adjust the width as per your requirement
                            .font(.title2) // Increase font size
                            .bold()
                            .multilineTextAlignment(.center)
                            .padding(.trailing)
                    }
                    .padding()
                }
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2) // Adding shadow
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
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: 2) // Adding shadow
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
                    Button(action: {
                        
                    }, label: {
                        Image(systemName:"gearshape")
                            .foregroundStyle(.gray)
                    })
                }
            }
        }
    }
}

#Preview {
    let newItem = Club.createClub(brand: "Callaway", model: "Apex", name: "", type: ClubType.iron, number: "9", degree: "", distanceYards: 140, distanceMeters: nil, favorite: false)
    return ClubDetailView(club: newItem)
}
