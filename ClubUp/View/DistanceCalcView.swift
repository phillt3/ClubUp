//
//  DistanceCalcView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 4/30/24.
//

import SwiftUI
import SwiftData

//TODO: User a viewmodel for performing the calculations?
//TODO: Either way, step one is just to put together the UI
struct DistanceCalcView: View {
    @State private var yardage: String = ""
    @State private var windSpeed: Double = 0
    @State private var selectedDirection: String = ""
    @State private var selectedDirectionIndex = 0
    @State private var selectedSlope = ""
    @State private var isRaining: Bool = false
    @Query private var userPrefs: [UserPrefs]
    let arrowImages = ["arrow.up", "arrow.up.right", "arrow.right", "arrow.down.right", "arrow.down", "arrow.down.left", "arrow.left", "arrow.up.left"]
    
    @State private var selected: String = ""
    
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
                            // Action to be performed when the info button is tapped
                            print("Info button tapped")
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .padding(.trailing, 8)
                        }
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
                            // Action to be performed when the info button is tapped
                            print("Info button tapped")
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.blue)
                                .padding(.trailing, 8)
                        }
                    }
                    TextField("150", text: $yardage)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 100)
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                    
                    Text("Wind Direction")
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
                        Picker("Lie", selection: $selected) {
                            ForEach(selectionOptions, id: \.self) {
                                Text($0)
                            }
                         }.pickerStyle(.wheel)
                    }

                    HStack {
                        Text("Slope")
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
                                Text("Temperature")
                                    .font(.headline)
                                Button(action: {
                                    // Action to be performed when the info button is tapped
                                    print("Info button tapped")
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.blue)
                                        .padding(.trailing, 8)
                                }
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
                                    // Action to be performed when the info button is tapped
                                    print("Info button tapped")
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.blue)
                                        .padding(.trailing, 8)
                                }
                            }
                            TextField("77", text: $yardage)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding()
                    
                    HStack(alignment:.center) {
                        VStack {
                            HStack {
                                Text("Humidity")
                                    .font(.headline)
                                Button(action: {
                                    // Action to be performed when the info button is tapped
                                    print("Info button tapped")
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.blue)
                                        .padding(.trailing, 8)
                                }
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
                                Text("Altitude")
                                    .font(.headline)
                                Button(action: {
                                    // Action to be performed when the info button is tapped
                                    print("Info button tapped")
                                }) {
                                    Image(systemName: "info.circle")
                                        .foregroundColor(.blue)
                                        .padding(.trailing, 8)
                                }
                            }
                            TextField("77", text: $yardage)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                        }
                    }
                    .padding()
                    
                    Text("Wind Speed")
                        .font(.headline)
                    
                    Slider(value: $windSpeed, in: 0...100, step: 1)
                        .padding(.horizontal)
                    
                    Text("\(Int(windSpeed)) mph")
                        .font(.headline)
                        .foregroundColor(.gray)
                    
                    Toggle("Raining", isOn: $isRaining)

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
                    Button("Calculate") {}
                      .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

private func temp() {
    
}

#Preview {
    DistanceCalcView()
}
