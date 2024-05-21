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
    @State private var viewModel: DistanceCalcViewModel
    @FocusState private var focusItem: Bool
    
    init(modelContext: ModelContext) {
        let viewModel = DistanceCalcViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    HStack {
                        Text("Distance" + (UserPrefs.getCurrentPrefs(prefs: userPrefs).distanceUnit == Unit.Imperial ? " (Yards)" : " (Meters)"))
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
                    .padding(.top)
                    TextField("150", text: $viewModel.yardage) //TODO: I know we had issues in other areas with a number formatter, maybe just forcing a number pad will be good enough, otherwise do research
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .onSubmit { focusItem = false }
                        .focused($focusItem)
                    
                    
                    HStack {
                        Text("Adjusted Distance" + (UserPrefs.getCurrentPrefs(prefs: userPrefs).distanceUnit == Unit.Imperial ? " (Yards)" : " (Meters)"))
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
                    TextField("158", text: $viewModel.adjYardage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .onSubmit { focusItem = false }
                        .focused($focusItem)
                    
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
                    
                    Divider()
                        .padding(.vertical)
                    
                    Button(action: temp) {
                        Label(" Auto Fill", systemImage: "square.and.pencil")
                    }
                    .buttonStyle(.bordered)
                    
                    Spacer()
                    
                    VStack {
                        HStack {
                            Text("Temperature" + (UserPrefs.getCurrentPrefs(prefs: userPrefs).tempUnit == TempUnit.Fahrenheit ? " (°F)" : " (°C)"))
                                .font(.headline)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
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
                        TextField((UserPrefs.getCurrentPrefs(prefs: userPrefs).tempUnit == TempUnit.Fahrenheit ? "82" : "28"), text: $viewModel.temperature)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .onSubmit { focusItem = false }
                            .focused($focusItem)
                    }
                    .padding(.horizontal)
                    Spacer()
                    VStack {
                        HStack {
                            Text("Altitude" + (UserPrefs.getCurrentPrefs(prefs: userPrefs).distanceUnit == Unit.Imperial ? " (Feet)" : " (Meters)"))
                                .font(.headline)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
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
                        TextField(UserPrefs.getCurrentPrefs(prefs: userPrefs).distanceUnit == Unit.Imperial ? "1803" : "550", text: $viewModel.altitude)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .frame(width: 100)
                            .keyboardType(.numberPad)
                            .multilineTextAlignment(.center)
                            .onSubmit { focusItem = false }
                            .focused($focusItem)
                    }
                    .padding(.horizontal)
                    .padding(.vertical)
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
                    Slider(value: $viewModel.windSpeed, in: 0...50, step: 1)
                        .padding(.horizontal)
                    
                    Text("\(Int(viewModel.windSpeed))" + (UserPrefs.getCurrentPrefs(prefs: userPrefs).speedUnit == .Imperial ? " (mph)" : " (km/h)"))
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
                    .padding(.horizontal)
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
            .onTapGesture{
                focusItem = false
            }
            .onAppear {
                viewModel.fetchData()
            }
        }
        .sheet(isPresented: $viewModel.showingResult, content: {
            NavigationStack {
                let result = viewModel.calculateTrueDistance()
                let recClub = viewModel.getRecommendedClub(distance: result)
                DistanceResultView(distanceCalcVM: viewModel, distance: result, club: recClub)
            }
            .presentationDetents([.medium])
        })
    }
    
}

private func temp() {
    
}

#Preview {
    @Environment(\.modelContext) var modelContext
    return DistanceCalcView(modelContext: modelContext)
}

