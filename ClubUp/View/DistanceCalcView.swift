//
//  DistanceCalcView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 4/30/24.
//

import SwiftUI
import SwiftData

//TODO: Use a viewmodel for performing the calculations?
//TODO: Either way, step one is just to put together the UI
struct DistanceCalcView: View {
    @Query private var userPrefs: [UserPrefs]
    @State private var yardage: String = ""
    @State private var windSpeed: Double = 0
    @State private var selectedDirection: String = "multiply.circle"
    @State private var selectedDirectionIndex = 0
    @State private var selectedSlope = ""
    @State private var isRaining: Bool = false
    @State private var selected: String = ""
    @State private var sheetIsPresented = false
    @State private var showingAlert = false
    @State private var alertType: AlertType = .distance
    
    let arrowImages = ["multiply.circle","arrow.up", "arrow.up.right", "arrow.right", "arrow.down.right", "arrow.down", "arrow.down.left", "arrow.left", "arrow.up.left"]
    let selectionOptions = ["Tee", "Fairway","Rough","Bunker", "Deep Rough"]
    let slopes = ["Flat","Down","Up"]
    
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    HStack {
                        Text("Distance (Yards)")
                            .font(.headline)
                        Button(action: {
                            alertType = .distance
                            showingAlert.toggle()
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .padding(.trailing, 8)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    TextField("150", text: $yardage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Text("Adjusted Distance (Yards)")
                            .font(.headline)
                        Button(action: {
                            alertType = .adjustedDistance
                            showingAlert.toggle()
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .padding(.trailing, 8)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    TextField("150", text: $yardage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                    
                    HStack {
                        Text("Wind Direction")
                            .font(.headline)
                        Button(action: {
                            alertType = .windDirection
                            showingAlert.toggle()
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .padding(.trailing, 8)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    Picker(selection: $selectedDirection, label: Text("Wind Direction")) {
                        ForEach(arrowImages, id: \.self) {
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
                            alertType = .lie
                            showingAlert.toggle()
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .padding(.trailing, 8)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Picker("Lie", selection: $selected) {
                            ForEach(selectionOptions, id: \.self) {
                                Text($0)
                            }
                         }.pickerStyle(.wheel)
                    }

                    HStack {
                        Text("Slope")
                            .font(.headline)
                        Button(action: {
                            alertType = .slope
                            showingAlert.toggle()
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .padding(.trailing, 8)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        Picker("Slope", selection: $selectedSlope) {
                            ForEach(slopes, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.wheel)
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
                                    alertType = .temperature
                                    showingAlert.toggle()
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.blue)
                                        .padding(.trailing, 8)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            TextField("77", text: $yardage)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                            HStack {
                                Text("Humidity")
                                    .font(.headline)
                                Button(action: {
                                    alertType = .humidity
                                    showingAlert.toggle()
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.blue)
                                        .padding(.trailing, 8)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            TextField("77", text: $yardage)
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
                                    alertType = .airPressure
                                    showingAlert.toggle()
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.blue)
                                        .padding(.trailing, 8)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            TextField("77", text: $yardage)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                            HStack {
                                Text("Altitude")
                                    .font(.headline)
                                Button(action: {
                                    alertType = .altitude
                                    showingAlert.toggle()
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.blue)
                                        .padding(.trailing, 8)
                                }
                                .buttonStyle(BorderlessButtonStyle())
                            }
                            TextField("77", text: $yardage)
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
                            alertType = .windSpeed
                            showingAlert.toggle()
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .padding(.trailing, 8)
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    Slider(value: $windSpeed, in: 0...100, step: 1)
                        .padding(.horizontal)
                    
                    Text("\(Int(windSpeed)) mph")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Toggle(isOn: $isRaining) {
                        HStack {
                            Text("Raining")
                                .font(.headline)
                            Button(action: {
                                alertType = .rain
                                showingAlert.toggle()
                            }) {
                                Image(systemName: "info.circle")
                                    .foregroundColor(.blue)
                                    .padding(.trailing, 8)
                            }
                            .buttonStyle(BorderlessButtonStyle())
                        }
                    }

                }
                .alert(isPresented: $showingAlert) {
                    Alert(title: Text(alertType.title), message: Text("Wear sunscreen"), dismissButton: .default(Text("Got it!")))
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
                        sheetIsPresented.toggle()
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .sheet(isPresented: $sheetIsPresented, content: {
            NavigationStack {
                DistanceFoundView()
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

