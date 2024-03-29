//
//  ClubCreateView.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 3/25/24.
//

import SwiftUI

struct ClubCreateView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        //        HStack {
        //            ForEach(types.indices, id: \.self) { index in
        //                VStack {
        //                    Image("golf-club")
        //                        .resizable()
        //                        .frame(width: 50, height: 50)
        //                        .overlay(
        //                            Rectangle()
        //                                .stroke(Color.blue, lineWidth: index == selectedType ? 2 : 0)
        //                        )
        //                        .onTapGesture {
        //                            selectedType = index
        //                        }
        //                    Text("\(index)")
        //                        .font(.caption)
        //                        .foregroundColor(index == selectedType ? .blue : .black)
        //                }
        //            }
        //        }
        //        HStack {
        //            Spacer()
        //            Text("Number")
        //            Picker(selection: $club.number, label: Text("Number")) {
        //                ForEach(1...10, id: \.self) { number in
        //                    Text("\(number)")
        //                }
        //            }
        //            .pickerStyle(MenuPickerStyle())
        //            .labelsHidden() // Hide the default label
        //            Spacer()
        //        }.padding()
    }
}

#Preview {
    ClubCreateView()
}
