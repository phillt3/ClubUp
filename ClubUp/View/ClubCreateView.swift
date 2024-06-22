//
//  ClubCreateView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/25/24.
//
//  Description:
//  This file contains the implementation of a create view where the user
//  can input information to create a custom, virtual representations of a club that they own.

import SwiftUI

struct ClubCreateView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusItem: Bool
    
    @State var viewModel: ClubCreateViewModel

    var body: some View {
        List {
            /// display input fields
            VStack(alignment: .leading) {
                Text("Brand").font(.headline).bold()
                    .padding(.bottom, -10)
                TextField("Brand", text: $viewModel.brand)
                    .font(.title)
                    .textFieldStyle(.roundedBorder)
                    .listRowSeparator(.hidden)
                    .onSubmit { focusItem = false }
                    .focused($focusItem)
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
                    .onSubmit { focusItem = false }
                    .focused($focusItem)
            }
            .padding(.horizontal)
            .listRowSeparator(.hidden)
            
            /// display grid of buttons to represent different club types
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
                        viewModel.type = ClubType.iron
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
            
            /// once the club type has been selected, present additional data inputs
            if viewModel.type != nil {
                /// picker for defining club number, will use specific value list depending on type
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
                    /// display input field for distance
                    let distanceStringKey = viewModel.prefs.distanceUnit == Unit.Imperial ? "distance_yards" : "distance_meters"
                    Text(String(format: NSLocalizedString(distanceStringKey, comment: "")))
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
                        .onSubmit { focusItem = false }
                        .focused($focusItem)
                }
                .listRowSeparator(.hidden)
                
                /// favorite toggle
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
                            .foregroundStyle(Color("Favorite"))
                            .padding(.trailing, 25)
                            .onTapGesture {
                                viewModel.isFavorite.toggle()
                            }
                    }
                }
                HStack(alignment: .center) {
                    Spacer()
                    Button(action: {
                        /// add club to swiftdata club structure
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
        .onAppear {
            viewModel.fetchData() /// will need to fetch preference data for the vm on the view's appearance
        }
        .onTapGesture{
            focusItem = false
        }
    }
}

/// A stylized button style to act as a 4 way toggle for club types
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

//#Preview {
//    let prefs = UserPrefs()
//    let viewModel = ClubCreateView.ClubCreateViewModel(modelContext: modelContext)
//    return ClubCreateView(viewModel: viewModel)
//}
