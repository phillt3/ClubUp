//
//  ContentView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/16/24.
//  My first commit!

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Club]
    
    @State private var recClubs = ["Dr", "3w", "5w","3i","4i","5i","6i","7i","8i","9i","Pw", "W-52", "W-56", "W-60"]
    var body: some View {
        NavigationStack {
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Club.createClub(brand: "Callaway", model: "Apex", name: "", type: ClubType.iron, number: "9", degree: "", distanceYards: nil, distanceMeters: nil, favorite: false)
            modelContext.insert(newItem)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Club.self, inMemory: true)
}
