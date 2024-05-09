//
//  DistanceFoundView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 5/5/24.
//

import SwiftUI

struct DistanceResultView: View {
    @Environment(\.dismiss) private var dismiss
    var distance: Int
    var club: Club?
    var body: some View {
        VStack{
            if let recClub = club {
                Text("\(distance)" + " " + "Yards")
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
                
                Image(recClub.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                .padding()
                
                HStack {
                    Button("Reset") {
                        dismiss()
                    }
                    .buttonStyle(.bordered)
                    Button(action: {
                        recClub.addGoodShot() //will this add to the correct club? 
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
            }
        }
        .padding()
    }
}

#Preview {
    let club = Club.createClub(brand: "Callaway", model: "Apex", name: "", type: ClubType.iron, number: "9", degree: "", distanceYards: 140, distanceMeters: nil, favorite: false)
    return DistanceResultView(distance: 150, club: club)
}
