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
    @Environment(\.modelContext) var modelContext
    @State private var brand: String = ""
    @State private var model: String = ""
    @State private var distance: Int = 0
    @State private var isFavorite: Bool = false
    @State private var type: ClubType?
    @State private var selectedValue: String = ""
    @Environment(\.dismiss) private var dismiss
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
                TextField("Brand", text: $brand)
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
                TextField("Model", text: $model)
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
                        type = ClubType.wood
                    }) {
                        VStack(alignment: .center) {
                            Text("Wood")
                                .bold()
                            Image("default-driver")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .buttonStyle(CustomButtonStyle(selected: type == ClubType.wood))
                    
                    Button(action: {
                        type = ClubType.hybrid
                    }) {
                        VStack(alignment: .center) {
                            Text("Hybrid")
                                .bold()
                            Image("default-hybrid")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .buttonStyle(CustomButtonStyle(selected: type == ClubType.hybrid))
                }
                
                HStack {
                    Button(action: {
                        type = ClubType.iron //TODO: should make these capitalized
                    }) {
                        VStack(alignment: .center) {
                            Text("Iron")
                                .bold()
                            Image("default-iron")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .buttonStyle(CustomButtonStyle(selected: type == ClubType.iron))
                    
                    Button(action: {
                        type = ClubType.wedge
                    }) {
                        VStack(alignment: .center) {
                            Text("Wedge")
                                .bold()
                            Image("default-wedge")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .buttonStyle(CustomButtonStyle(selected: type == ClubType.wedge))
                }
            }
            .padding()
            .listRowSeparator(.hidden)
            
            if type != nil {
                HStack {
                    Label("Select Club Number", systemImage: "number")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    Picker(selection: $selectedValue, label: Text("Select Club Number")) {
                        let themes = getSelection(type: type!)
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
                    TextField("0", value: $distance, format: .number)
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
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 40, height: 40)
                        .fontWeight(.thin)
                        .foregroundStyle(.yellow)
                        .padding(.trailing, 25)
                        .onTapGesture {
                            isFavorite.toggle()
                        }
                }
                HStack(alignment: .center) {
                    Spacer()
                    Button(action: {
                        
                        if (selectedValue == "") {
                            switch type! {
                            case .wood:
                                fallthrough
                            case .iron:
                                fallthrough
                            case .hybrid:
                                selectedValue = "1"
                            case .wedge:
                                selectedValue = "E"
                            }
                        }
                        
                        let newClub = Club.createClub(brand: brand, model: model, name: "", type: type!, number: selectedValue, degree: selectedValue, distanceYards: distance, distanceMeters: distance, favorite: isFavorite)
                        modelContext.insert(newClub)  //TODO: This needs to be improved, seems like a waste to use a half baked model to create a full model, model should just be ready to ship out
                        dismiss()
                    }) {
                        Label("Add Club", systemImage: "plus")
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
                .listRowSeparator(.hidden)
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
    return ClubCreateView()
}
