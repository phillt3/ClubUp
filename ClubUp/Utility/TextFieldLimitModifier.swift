//
//  TextFieldLimitModifier.swift
//  ClubUp
//
//  Created by Phillip  Tracy on 6/9/24.
//  Original Author: Martin Albrecht
//
//  Description:
//  This file contains the implementation of a TextField Modifer to limit the number of
//  characters that can be entered by the user.
//
// Source:
// https://sanzaru84.medium.com/swiftui-an-updated-approach-to-limit-the-amount-of-characters-in-a-textfield-view-984c942a156#:~:text=First%20thing%20to%20do%20is,iOS%20versions)%20methods%20this%20time.


import SwiftUI


/// Automatically set the input value to be a prefix of specific size to limit the number of characters used
struct TextFieldLimitModifer: ViewModifier {
    @Binding var value: String
    var length: Int

    func body(content: Content) -> some View {
        content
            .onReceive(value.publisher.collect()) {
                value = String($0.prefix(length))
            }
    }
}

extension View {
    func limitInputLength(value: Binding<String>, length: Int) -> some View {
        self.modifier(TextFieldLimitModifer(value: value, length: length))
    }
}
