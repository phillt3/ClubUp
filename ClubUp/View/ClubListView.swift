//
//  ContentView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/16/24.
//  My first commit!

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
        NavigationStack {
            VStack() {
                if(Club.isMissingRecommendedClubs(clubs: userClubs)) { //TODO: will need to optimize this method and below
                    HStack{
                        Text("Add Recommended Clubs (\(userClubs.count))")
                            .padding(.leading, 20)
                        Spacer()
                        Button(action: {
                            Club.recommendedClubs.forEach { key, recClub in
                                if !userClubs.contains(where: { $0.name == recClub.name }) {
                                    addItem(club: recClub) //TODO: Hopefully this can be optimized as well
                                }
                            }
                        }, label: {
                            Text("Add All")
                                .padding(.trailing, 20)
                        })
                    }
                    LazyVGrid(columns: layout) {
                        ForEach(Club.recommendedClubs.values.sorted { return $0.rank < $1.rank }, id: \.self) { recClub in //TODO: looping through this dictionary and then checking the list feels unoptimized and can be improved. But it is important that we are no longer relying on a state static dictionary from the model
                            if !userClubs.contains(where: { $0.name == recClub.name }) {
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
                                .buttonBorderShape(.capsule)
                            }
                        }
                    }
                    .padding()
                } else {
                    HStack(alignment: .center){
                        Text("Your Complete Bag (\(userClubs.count))")
                            .font(.title3)
                    }
                }
            }
            HStack(alignment: .center) {
                Button {
                    sheetIsPresented.toggle()
                } label: {
                    Label("Add Custom Club", systemImage: "plus")
                }
                .buttonStyle(.bordered)
            }
            List {
                ForEach(userClubs) { item in
                    ClubsListCellView(club: item, prefs: userPrefs.first ?? UserPrefs())
                }
                .onDelete(perform: deleteItems)
            }
            .listRowSpacing(9)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        dismiss()
                    }, label: {
                        Image(systemName:"scope")
                            .foregroundStyle(.gray)
                    })
                }
//                ToolbarItem(placement: .topBarTrailing) {
//                    Button(action: {
//                        
//                    }, label: {
//                        Image(systemName:"scope")
//                            .foregroundStyle(.gray)
//                    })
//                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView(userPrefs: userPrefs.first ?? UserPrefs(), isFirst: userPrefs.isEmpty)) {
                        Image(systemName:"gearshape")
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
        .sheet(isPresented: $sheetIsPresented, content: {
            NavigationStack {
                ClubCreateView(prefs: userPrefs.first ?? UserPrefs())//new value
            }
        })
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Club.createClub(brand: "Callaway", model: "Apex", name: "", type: ClubType.hybrid, number: "9", degree: "", distanceYards: nil, distanceMeters: nil, favorite: false)
            modelContext.insert(newItem)
        }
    }
    
    private func addItem(club: Club) {
        withAnimation {
            modelContext.insert(club)
        }
    }
    
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
