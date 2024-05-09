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
    
    @State var viewModel: ClubCreateViewModel

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
                    
                    Text("Distance" + (viewModel.prefs.distanceUnit == Unit.Imperial ? " (Yards)" : " (Meters)"))
                        .font(.title2)
                        .padding(.leading)
                        .bold()
                    
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
                
                if (viewModel.prefs.favoritesOn) {
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
                        modelContext.insert(viewModel.createClub())
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
    let viewModel = ClubCreateView.ClubCreateViewModel(prefs: prefs)
    return ClubCreateView(viewModel: viewModel)
}
