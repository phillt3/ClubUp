//
//  DistanceCalcView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 4/30/24.
//
//  Description:
//  This file contains the implementation of the main calculator page where a user
//  can enter all pertinent information as well as make weather data requests in order to
//  accurately calculate their yardage to the target.

import SwiftUI
import SwiftData

struct DistanceCalcView: View {
    @Environment(\.modelContext) var modelContext
    @Query public var userPrefs: [UserPrefs]
    @State private var viewModel: DistanceCalcViewModel
    @FocusState private var focusItem: Bool /// this value assists with clicking off any input keyboards
    
    /// initialize the viewmodel
    init(modelContext: ModelContext) {
        let viewModel = DistanceCalcViewModel(modelContext: modelContext)
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        ZStack {
            NavigationStack {
                ZStack {
                    Image("golf-background")
                        .resizable()
                    List {
                        /// Initial user input values
                        VStack {
                            HStack {
                                let distanceStringKey = UserPrefs.getCurrentPrefs(prefs: userPrefs).distanceUnit == Unit.Imperial ? "distance_yards" : "distance_meters"
                                Text(String(format: NSLocalizedString(distanceStringKey, comment: "")))
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
                            TextField(UserPrefs.getCurrentPrefs(prefs: userPrefs).distanceUnit == Unit.Imperial ? "150" : "137", text: $viewModel.calcData.yardage)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .onSubmit { focusItem = false }
                                .focused($focusItem)
                                .limitInputLength(value: $viewModel.calcData.yardage, length: 3)
                            
                            HStack {
                                let adjDistanceStringKey = UserPrefs.getCurrentPrefs(prefs: userPrefs).distanceUnit == Unit.Imperial ? "adjusted_distance_yards" : "adjusted_distance_meters"
                                Text(String(format: NSLocalizedString(adjDistanceStringKey, comment: "")))
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
                            TextField(UserPrefs.getCurrentPrefs(prefs: userPrefs).distanceUnit == Unit.Imperial ? "158" : "144", text: $viewModel.calcData.adjYardage)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .onSubmit { focusItem = false }
                                .focused($focusItem)
                                .limitInputLength(value: $viewModel.calcData.adjYardage, length: 3)
                            
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
                            Picker(selection: $viewModel.calcData.windDirection, label: Text("Wind Direction")) {
                                ForEach(viewModel.calcData.arrowImages, id: \.self) {
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
                                Picker("Lie", selection: $viewModel.calcData.lie) {
                                    ForEach(viewModel.calcData.selectionOptions, id: \.self) {
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
                                Picker("Slope", selection: $viewModel.calcData.slope) {
                                    ForEach(viewModel.calcData.slopes, id: \.self) {
                                        Text($0)
                                    }
                                }
                                .pickerStyle(.wheel)
                                .frame(height: 100)
                            }
                            
                            Divider()
                                .padding(.vertical)
                            
                            /// Input that can be filled in manually or using an auto fill
                            Button {
                                viewModel.calcData.isLoading = true
                                viewModel.calcData.fillInData()
                            } label: {
                                Label(" Auto Fill", systemImage: "square.and.pencil")
                            }
                            .buttonStyle(.bordered)
                            
                            Spacer()
                            
                            VStack {
                                HStack {
                                    let tempString = UserPrefs.getCurrentPrefs(prefs: userPrefs).tempUnit == TempUnit.Fahrenheit ? "temperature_f" : "temperature_c"
                                    Text(String(format: NSLocalizedString(tempString, comment: "")))
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
                                TextField((UserPrefs.getCurrentPrefs(prefs: userPrefs).tempUnit == TempUnit.Fahrenheit ? "82" : "28"), text: $viewModel.calcData.temperature)
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
                                    let altString = UserPrefs.getCurrentPrefs(prefs: userPrefs).distanceUnit == Unit.Imperial ? "altitude_f" : "altitude_m"
                                    Text(String(format: NSLocalizedString(altString, comment: "")))
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
                                TextField(UserPrefs.getCurrentPrefs(prefs: userPrefs).distanceUnit == Unit.Imperial ? "1803" : "550", text: $viewModel.calcData.altitude)
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
                            Slider(value: $viewModel.calcData.windSpeed, in: 0...50, step: 1)
                                .padding(.horizontal)
                            
                            Text("\(Int(viewModel.calcData.windSpeed))" + (UserPrefs.getCurrentPrefs(prefs: userPrefs).speedUnit == .Imperial ? " (mph)" : " (km/h)"))
                                .font(.headline)
                                .foregroundColor(.gray)
                            Toggle(isOn: $viewModel.calcData.isRaining) {
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
                            .padding(.bottom)
                        }
                        .alert(isPresented: $viewModel.showingAlert) {
                            Alert(title: Text(viewModel.alertType.title), message: Text(viewModel.alertType.message), dismissButton: .default(Text("Got it!")))
                        }
                    }
                    .scrollContentBackground(.hidden)
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        /// navigate to settings
                        NavigationLink(destination: SettingsView(userPrefs: userPrefs.first ?? UserPrefs(), isFirst: userPrefs.isEmpty)) {
                            Image(systemName:"gearshape")
                                .foregroundStyle(.gray)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        /// navigate to clubs list
                        NavigationLink(destination: ClubListView()) {
                            HStack {
                                Text("Your Clubs")
                                    .font(.headline)
                                Image(systemName: "arrowshape.right")
                            }
                            .foregroundStyle(.gray)
                        }
                    }
                    ToolbarItem(placement: .bottomBar) {
                        HStack{
                            Spacer()
                            /// initiate calculate and show result view
                            Button("Calculate") {
                                viewModel.showingResult.toggle()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(Color("Dark_Green"))
                            /// reset calculation page
                            Button("Clear") {
                                viewModel.calcData.reset()
                            }
                            .buttonStyle(.borderedProminent)
                            .tint(Color("Primary_Green"))
                            Spacer()
                        }
                    }
                }
                .onTapGesture{
                    focusItem = false
                }
                .onAppear {
                    viewModel.prepareViewModelForView()
                }
            }
            .sheet(isPresented: $viewModel.showingResult, content: {
                NavigationStack {
                    let result = viewModel.calculateTrueDistance() /// calculate the distance
                    let recClub = viewModel.getRecommendedClub(distance: result) /// find the club to recommend
                    DistanceResultView(distanceCalcVM: viewModel, distance: result, club: recClub) /// pass both values to the result view
                }
                .presentationDetents([.medium])
            })
            /// present a loading view while fetching data
            if viewModel.calcData.isLoading {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
                
                VStack {
                    ProgressView("Fetching...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .padding()
                }
                .background(BlurView(style: .systemMaterial))
                .cornerRadius(15)
                .shadow(radius: 10)
            }
        }
    }
}

/// help to stylize the loading view
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

#Preview {
    @Environment(\.modelContext) var modelContext
    return DistanceCalcView(modelContext: modelContext)
}

