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
    @Query private var items: [Club]
    
    @State private var recClubs = Club.recommendedClubs
    let layout = [
        GridItem(.adaptive(minimum: 80)),
        GridItem(.adaptive(minimum: 80)),
        GridItem(.adaptive(minimum: 80)),
    ]
    
    var body: some View {
        NavigationStack {
            VStack() {
                if(!recClubs.isEmpty) {
                    HStack{
                        Text("Add Recommended Clubs (\(items.count))")
                            .padding(.leading, 20)
                        Spacer()
                        Button(action: {
                            recClubs.forEach { addItem(club: $0) }
                            recClubs.removeAll()
                        }, label: {
                            Text("Add All")
                                .padding(.trailing, 20)
                        })
                    }
                    LazyVGrid(columns: layout) {
                        ForEach(recClubs) { recClub in
                            Button(action: {
                                addItem(club: recClub)
                                recClubs.remove(at: recClubs.firstIndex(of: recClub)!) //this may be more efficient with a dictionary
                            }, label: {
                                Image("golf-club")
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
                    .padding()
                } else {
                    HStack(alignment: .center){
                        Text("Your Complete Bag (\(items.count))")
                            .font(.title3)
                    }
                }
            }
            HStack(alignment: .center) {
                Button(action: addItem) {
                    Label("Add Club", systemImage: "plus")
                }
                .buttonStyle(.bordered)
            }
            List {
                ForEach(items) { item in
                    ClubsListCellView(club: item)
                }
                .onDelete(perform: deleteItems)
            }
            .listRowSpacing(9)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: {
                        
                    }, label: {
                        Image(systemName:"gearshape")
                            .foregroundStyle(.gray)
                    })
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Club.createClub(brand: "Callaway", model: "Apex", name: "", type: ClubType.iron, number: "9", degree: "", distanceYards: nil, distanceMeters: nil, favorite: false)
            let index = recClubs.firstIndex(where: { $0.name == newItem.name })
            if let removeIndex = index {
                recClubs.remove(at: removeIndex)
            }
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
                if(!recClubs.contains(where: { $0.name == items[index].name })) {
                    recClubs.append(Club.getRecClub(name: items[index].name))
                }
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ClubListView()
        .modelContainer(for: Club.self, inMemory: true)
}
