//
//  DistanceCalcView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 4/30/24.
//

import SwiftUI
import SwiftData

//TODO: Use a viewmodel for performing the calculations and abstracting all properties, this page should ONLY be UI or properties that deal with UI
//TODO: Research whether or not the view model is necessary and makes sense in the context of swiftui
//TODO: Either way, step one is just to put together the UI

struct DistanceCalcView: View {
    @Environment(\.modelContext) var modelContext
    @Query public var userPrefs: [UserPrefs]
    @Query public var clubs: [Club]
    
    @StateObject var viewModel = DistanceCalcViewModel()
        
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    HStack {
                        Text("Distance (Yards)")
                            .font(.headline)
                        Button(action: {
                            viewModel.alertType = .distance
                            viewModel.showingAlert.toggle()

                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .padding(.trailing, 8)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    TextField("150", text: $viewModel.yardage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Text("Adjusted Distance (Yards)")
                            .font(.headline)
                        Button(action: {
                            viewModel.alertType = .adjustedDistance
                            viewModel.showingAlert.toggle()
                            
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .padding(.trailing, 8)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    TextField("150", text: $viewModel.adjYardage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Text("Wind Direction")
                            .font(.headline)
                        Button(action: {
                            viewModel.alertType = .windDirection
                            viewModel.showingAlert.toggle()
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .padding(.trailing, 8)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    Picker(selection: $viewModel.windDirection, label: Text("Wind Direction")) {
                        ForEach(viewModel.arrowImages, id: \.self) {
                            Image(systemName: $0)
                                .foregroundColor(.blue)
                                .padding(.trailing, 8)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal)
                    
                    HStack {
                        Text("Lie")
                            .font(.headline)
                        Button(action: {
                            viewModel.alertType = .lie
                            viewModel.showingAlert.toggle()
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .padding(.trailing, 8)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Picker("Lie", selection: $viewModel.lie) {
                            ForEach(viewModel.selectionOptions, id: \.self) {
                                Text($0)
                            }
                         }
                        .pickerStyle(.wheel)
                        .frame(height: 100)
                    }
                    HStack {
                        Text("Slope")
                            .font(.headline)
                        Button(action: {
                            viewModel.alertType = .slope
                            viewModel.showingAlert.toggle()
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .padding(.trailing, 8)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Picker("Slope", selection: $viewModel.slope) {
                            ForEach(viewModel.slopes, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(height: 100)
                    }
                    
                    Button(action: temp) {
                        Label("Fill In", systemImage: "square.and.pencil")
                    }
                    .buttonStyle(.bordered)
                    
                    HStack(alignment:.center) {
                        VStack {
                            HStack {
                                Text("Temp")
                                    .font(.headline)
                                Button(action: {
                                    viewModel.alertType = .temperature
                                    viewModel.showingAlert.toggle()
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.blue)
                                        .padding(.trailing, 8)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            TextField("77", text: $viewModel.yardage)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                            HStack {
                                Text("Humidity")
                                    .font(.headline)
                                Button(action: {
                                    viewModel.alertType = .humidity
                                    viewModel.showingAlert.toggle()
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.blue)
                                        .padding(.trailing, 8)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            TextField("77", text: $viewModel.yardage)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                        }
                        Spacer()
                        VStack {
                            HStack {
                                Text("Air Pressure")
                                    .font(.headline)
                                Button(action: {
                                    viewModel.alertType = .airPressure
                                    viewModel.showingAlert.toggle()
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.blue)
                                        .padding(.trailing, 8)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            TextField("77", text: $viewModel.yardage)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                            HStack {
                                Text("Altitude")
                                    .font(.headline)
                                Button(action: {
                                    viewModel.alertType = .altitude
                                    viewModel.showingAlert.toggle()
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.blue)
                                        .padding(.trailing, 8)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            TextField("77", text: $viewModel.yardage)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding()
                    HStack {
                        Text("Wind Speed")
                            .font(.headline)
                        Button(action: {
                            viewModel.alertType = .windSpeed
                            viewModel.showingAlert.toggle()
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .padding(.trailing, 8)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    Slider(value: $viewModel.windSpeed, in: 0...100, step: 1)
                        .padding(.horizontal)
                    
                    Text("\(Int(viewModel.windSpeed)) mph")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Toggle(isOn: $viewModel.isRaining) {
                        HStack {
                            Text("Raining")
                                .font(.headline)
                            Button(action: {
                                viewModel.alertType = .rain
                                viewModel.showingAlert.toggle()
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.blue)
                                    .padding(.trailing, 8)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }

                }
                .alert(isPresented: $viewModel.showingAlert) {
                    Alert(title: Text(viewModel.alertType.title), message: Text("Wear sunscreen"), dismissButton: .default(Text("Got it!")))
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink(destination: SettingsView(userPrefs: userPrefs.first ?? UserPrefs(), isFirst: userPrefs.isEmpty)) {
                        Image(systemName:"gearshape")
                            .foregroundStyle(.gray)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: ClubListView()) {
                        HStack {
                            Text("Your Clubs")
                                .font(.headline)
                            Image(systemName: "arrowshape.right")
                        }
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Button("Calculate") {
                        viewModel.showingResult.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
            .sheet(isPresented: $viewModel.showingResult, content: {
            NavigationStack {
                let result = viewModel.calculateTrueDistance()
                DistanceResultView(distance: result)
            }
            .presentationDetents([.medium])
        })
    }
}

private func temp() {
    
}

#Preview {
    DistanceCalcView()
}

