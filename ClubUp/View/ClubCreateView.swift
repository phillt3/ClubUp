//
//  ClubCreateView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/25/24.
//

import SwiftUI

let woodValues = (1...10).map { String($0) }
let hybridValues = (1...10).map { String($0) }
let ironValues = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "P"]
let wedgeValues = ["E", "A", "D", "F", "G", "M", "MB", "S", "L"] + (46...72).map { String($0) }

struct ClubCreateView: View {
    @State var club: Club
    @Environment(\.modelContext) var modelContext
    @State private var selectedButton: ClubType?
    @State private var selectedValue: String?
    var body: some View {
        List {
            HStack(alignment: .center) {
                Spacer()
                Button(action: temp) {
                    Label("Search Club", systemImage: "magnifyingglass")
                }
                .buttonStyle(.bordered)
                Spacer()
            }
            .listRowSeparator(.hidden)
            VStack(alignment: .leading) {
                Text("Brand").font(.headline).bold()
                    .padding(.bottom, -10)
                TextField("Brand", text: $club.brand)
                    .font(.title)
                    .textFieldStyle(.roundedBorder)
                    .listRowSeparator(.hidden)
            }
            .padding(.horizontal)
            .padding(.bottom)
            .listRowSeparator(.hidden)
            VStack(alignment: .leading) {
                Text("Model").font(.headline).bold()
                    .padding(.bottom, -10)
                TextField("Model", text: $club.model)
                    .font(.title)
                    .textFieldStyle(.roundedBorder)
                    .listRowSeparator(.hidden)
            }
            .padding(.horizontal)
            .listRowSeparator(.hidden)
            
            VStack {
                Text("Club Type").font(.headline).bold()
                HStack {
                    Button(action: {
                        self.selectedButton = ClubType.wood
                    }) {
                        VStack(alignment: .center) {
                            Text("Wood")
                                .bold()
                            Image("default-driver")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .buttonStyle(CustomButtonStyle(selected: selectedButton == ClubType.wood))
                    
                    Button(action: {
                        self.selectedButton = ClubType.hybrid
                    }) {
                        VStack(alignment: .center) {
                            Text("Hybrid")
                                .bold()
                            Image("default-hybrid")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .buttonStyle(CustomButtonStyle(selected: selectedButton == ClubType.hybrid))
                }
                
                HStack {
                    Button(action: {
                        self.selectedButton = ClubType.iron //TODO: should make these capitalized
                    }) {
                        VStack(alignment: .center) {
                            Text("Iron")
                                .bold()
                            Image("default-iron")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .buttonStyle(CustomButtonStyle(selected: selectedButton == ClubType.iron))
                    
                    Button(action: {
                        self.selectedButton = ClubType.wedge
                    }) {
                        VStack(alignment: .center) {
                            Text("Wedge")
                                .bold()
                            Image("default-wedge")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .buttonStyle(CustomButtonStyle(selected: selectedButton == ClubType.wedge))
                }
            }
            .padding()
            .listRowSeparator(.hidden)
            
            if selectedButton != nil {
                HStack {
                    Label("Select Club Number", systemImage: "number")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    Picker(selection: $selectedValue, label: Text("Appearance")) {
                        let themes = getSelection(type: selectedButton!)
                        ForEach(themes, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                .frame(height: 100)
                
                HStack {
                    Text("Distance (Yds)")
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
                }
                .listRowSeparator(.hidden)
                
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
            }
        }
    }
}

func getSelection(type: ClubType) -> [String] {
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

private func temp() {
    
}


struct CustomButtonStyle: ButtonStyle {
    let selected: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(selected ? Color.blue : Color.gray, lineWidth: selected ? 2 : 1) // Thin blue border
            )
            .foregroundColor(selected ? Color.blue : Color.gray)
    }
}

#Preview {
    let newItem = Club.createClub(brand: "Callaway", model: "Apex", name: "", type: ClubType.hybrid, number: "9", degree: "", distanceYards: nil, distanceMeters: nil, favorite: false)
    return ClubCreateView(club: newItem)
}
