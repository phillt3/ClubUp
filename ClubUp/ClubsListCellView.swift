//
//  ClubsListCellView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/18/24.
//

import SwiftUI

struct ClubsListCellView: View {
    var club: Club
    var body: some View {
        NavigationLink(destination: ClubDetailView(club: club)) {
            HStack {
                Image(systemName: club.favorite ? "star.fill" : "star")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 25, height: 25)
                    .fontWeight(.thin)
                    .foregroundStyle(.yellow)
                    .onTapGesture {
                        club.favorite.toggle()
                    }
                Image("golf-club")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .padding(.bottom, -20)
                
                VStack(alignment: .leading) {
                    Text(club.name)
                        .font(.title) // Larger font size
                        .fontWeight(.bold) // Optional: Make font bold
                    Text(club.brand)
                        .font(.subheadline)
                        .italic()
                        .foregroundColor(.secondary)
                }
                Spacer()
                VStack(alignment: .trailing) { // Adjusted spacing
                    if (club.distanceYards ?? 0 > 0) {
                        Text("\(club.distanceYards!)")
                            .font(.title) // Larger font size
                            .fontWeight(.bold) // Optional: Make font bold
                        Text("Yds")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        Text("Add Distance")
                            .font(.subheadline)
                            .foregroundStyle(.blue)
                    }
                }
            }
        }
    }
}



#Preview {
    let newItem = Club.createClub(brand: "Titleist", model: "Apex", name: "", type: ClubType.iron, number: "9", degree: "", distanceYards: 140, distanceMeters: nil, favorite: false)
    return ClubsListCellView(club: newItem)
}
