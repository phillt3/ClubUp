//
//  ClubCreateView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/25/24.
//

import SwiftUI

struct ClubCreateView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @StateObject var viewModel = ClubCreateViewModel()
    
    var prefs: UserPrefs //TODO: would like to add this to the vm somehow
    var body: some View {
        List {
            VStack(alignment: .leading) {
                Text("Brand").font(.headline).bold()
                    .padding(.bottom, -10)
                TextField("Brand", text: $viewModel.brand)
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
                TextField("Model", text: $viewModel.model)
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
                        viewModel.type = ClubType.wood
                    }) {
                        VStack(alignment: .center) {
                            Text("Wood")
                                .bold()
                            Image("default-driver")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .buttonStyle(CustomButtonStyle(selected: viewModel.type == ClubType.wood))
                    
                    Button(action: {
                        viewModel.type = ClubType.hybrid
                    }) {
                        VStack(alignment: .center) {
                            Text("Hybrid")
                                .bold()
                            Image("default-hybrid")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .buttonStyle(CustomButtonStyle(selected: viewModel.type == ClubType.hybrid))
                }
                
                HStack {
                    Button(action: {
                        viewModel.type = ClubType.iron //TODO: should make these capitalized
                    }) {
                        VStack(alignment: .center) {
                            Text("Iron")
                                .bold()
                            Image("default-iron")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .buttonStyle(CustomButtonStyle(selected: viewModel.type == ClubType.iron))
                    
                    Button(action: {
                        viewModel.type = ClubType.wedge
                    }) {
                        VStack(alignment: .center) {
                            Text("Wedge")
                                .bold()
                            Image("default-wedge")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .buttonStyle(CustomButtonStyle(selected: viewModel.type == ClubType.wedge))
                }
            }
            .padding()
            .listRowSeparator(.hidden)
            
            if viewModel.type != nil {
                HStack {
                    Label("Select Club Number", systemImage: "number")
                        .font(.headline)
                        .foregroundColor(.blue)
                    
                    Picker(selection: $viewModel.selectedValue, label: Text("Select Club Number")) {
                        let themes = viewModel.getSelection(type: viewModel.type!)
                        ForEach(themes, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(WheelPickerStyle())
                }
                .frame(height: 100)
                
                HStack {
                    //TODO: Could move this logic to the viewModel
                    if (prefs.distanceUnit == Unit.Imperial) {
                        Text("Distance (Yards)")
                            .font(.title2)
                            .padding(.leading)
                            .bold()
                    } else if (prefs.distanceUnit == Unit.Metric){
                        Text("Distance (Meters)")
                            .font(.title2)
                            .padding(.leading)
                            .bold()
                    }
                    Spacer()
                    TextField("0", value: $viewModel.distance, format: .number)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.numberPad)
                        .frame(width: 75)
                        .font(.title2)
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.trailing)
                }
                .listRowSeparator(.hidden)
                
                if (prefs.favoritesOn) {
                    HStack {
                        Text("Favorite")
                            .font(.title2)
                            .padding(.leading)
                            .bold()
                        Spacer()
                        Image(systemName: viewModel.isFavorite ? "star.fill" : "star")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 40, height: 40)
                            .fontWeight(.thin)
                            .foregroundStyle(.yellow)
                            .padding(.trailing, 25)
                            .onTapGesture {
                                viewModel.isFavorite.toggle()
                            }
                    }
                }
                HStack(alignment: .center) {
                    Spacer()
                    Button(action: {
                        //TODO: Move below to VM
                        if (viewModel.selectedValue == "") {
                            switch viewModel.type! {
                            case .wood:
                                fallthrough
                            case .iron:
                                fallthrough
                            case .hybrid:
                                viewModel.selectedValue = "1"
                            case .wedge:
                                viewModel.selectedValue = "E"
                            }
                        }
                        if (prefs.distanceUnit == Unit.Imperial) { //TODO: This can be cleaned up
                            let newClub = Club.createClub(brand: viewModel.brand, model: viewModel.model, name: "", type: viewModel.type!, number: viewModel.selectedValue, degree: viewModel.selectedValue, distanceYards: viewModel.distance, distanceMeters: nil, favorite: viewModel.isFavorite)
                            modelContext.insert(newClub)
                        } else if (prefs.distanceUnit == Unit.Metric) {
                            let newClub = Club.createClub(brand: viewModel.brand, model: viewModel.model, name: "", type: viewModel.type!, number: viewModel.selectedValue, degree: viewModel.selectedValue, distanceYards: nil, distanceMeters: viewModel.distance, favorite: viewModel.isFavorite)
                            modelContext.insert(newClub)
                        }
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
    let prefs = UserPrefs()
    return ClubCreateView(prefs: prefs)
}
