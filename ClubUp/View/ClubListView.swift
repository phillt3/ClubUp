//
//  ContentView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/16/24.
//
//  Description:
//  This file contains the implementation of the main view to display the current list of clubs
//  and provide the user with options to quickly add recommended clubs or custom clubs.

import SwiftUI
import SwiftData

struct ClubListView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query(sort: \Club.rank) private var userClubs: [Club]
    @Query private var userPrefs: [UserPrefs]
    
    @State private var sheetIsPresented = false
    @State private var showSettingsView = false
    
    let layout = [
        GridItem(.adaptive(minimum: 80)),
        GridItem(.adaptive(minimum: 80)),
        GridItem(.adaptive(minimum: 80)),
    ]
    
    var body: some View {
        ZStack {
            Image("golf-background")
                .resizable()
            NavigationStack {
                VStack {
                    /// If there are available recommended clubs and the preference for quick add is turned on, display the relevant clubs to quick add. Otherwise, display header label with # of clubs
                    if(Club.isMissingRecommendedClubs(clubs: userClubs) && UserPrefs.getCurrentPrefs(prefs: userPrefs).quickAddClubsOn) {
                        HStack {
                            Text("Add Recommended Clubs (\(userClubs.count))")
                                .padding(.leading, 20)
                                .foregroundStyle(Color.white)
                                .bold()
                                .padding(.top)

                            Spacer()

                            Button(action: {
                                let userClubNames = Set(userClubs.map { $0.name })
                                let newClubs = Club.recommendedClubs.filter { !userClubNames.contains($0.value.name) }
                                newClubs.forEach { addItem(club: $0.value) }
                            }, label: {
                                Text("Add All")
                            })
                            .buttonStyle(.borderedProminent)
                            .tint(Color("Primary_Green"))
                            .padding(.trailing, 20)
                            .padding(.top)
                        }

                        LazyVGrid(columns: layout) {
                            /// present clubs to recommend for quick add if they are not already in the user's club list
                            let userClubNames = Set(userClubs.map { $0.name })

                            ForEach(Club.recommendedClubs.values.filter { !userClubNames.contains($0.name) }.sorted(by: { $0.rank < $1.rank }), id: \.self) { recClub in
                                Button(action: {
                                    addItem(club: recClub)
                                }, label: {
                                    Image(recClub.imageName)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    Text("\(recClub.name)")
                                        .bold()
                                        .frame(maxWidth: .infinity)
                                })
                                .buttonStyle(.borderedProminent)
                                .tint(Color("Sky_Blue"))
                                .buttonBorderShape(.capsule)
                            }
                        }
                        .padding()
                    } else {
                        HStack(alignment: .center){
                            Text("Your Bag (\(userClubs.count))")
                                .font(.title3)
                                .bold()
                                .foregroundStyle(Color.white)
                                .padding()
                        }
                    }
                }
                HStack(alignment: .center) {
                    /// toggle view to add custom club
                    Button {
                        sheetIsPresented.toggle()
                    } label: {
                        Label("Add Custom Club", systemImage: "plus")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("Dark_Green"))
                }
                ZStack {
//                    Image("golf-background")
//                        .resizable()
                    Color("Primary_Green")
                    List {
                        /// present list of user clubs
                        ForEach(userClubs) { item in
                            ClubsListCellView(club: item, prefs: userPrefs.first ?? UserPrefs())
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .listRowSpacing(9)
                    .scrollContentBackground(.hidden)
                }
                .navigationBarBackButtonHidden()
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        /// navigate back to the calculation page
                        Button(action: {
                            dismiss()
                        }, label: {
                            Image(systemName:"scope")
                                .foregroundStyle(.gray)
                        })
                    }
                    ToolbarItem(placement: .navigationBarTrailing) {
                        /// navigate to the preferences page
                        NavigationLink(destination: SettingsView(userPrefs: userPrefs.first ?? UserPrefs(), isFirst: userPrefs.isEmpty)) {
                            Image(systemName:"gearshape")
                                .foregroundStyle(.gray)
                        }
                    }
                }
            }
            .sheet(isPresented: $sheetIsPresented, content: {
                NavigationStack {
                    ClubCreateView(viewModel: ClubCreateView.ClubCreateViewModel(modelContext: modelContext))//new value
                    
                }
            })
        }
        .scrollContentBackground(.hidden)

    }
    
    /// Add club to swiftdata strcuture
    private func addItem(club: Club) {
        withAnimation {
            modelContext.insert(club)
        }
    }
    
    /// Delete club from swiftdata structure
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(userClubs[index])
            }
        }
    }
}

#Preview {
    ClubListView()
        .modelContainer(for: Club.self, inMemory: true)
}
