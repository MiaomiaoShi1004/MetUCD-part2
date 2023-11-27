//
//  ShowTextFieldActionView.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 27/11/2023.
//

import SwiftUI

struct ShowTextFieldActionView: View {
    @State private var isEditing = false
    @State private var searchText = ""
    @State private var showMessage = false

    var body: some View {
        VStack {
            if !isEditing {
                Button(action: {
                    isEditing = true
                }) {
                    Text("Search")
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
            } else {
                TextField("Enter a location", text: $searchText, onCommit: {
                    isEditing = false
                    showMessage = true
                })
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            }

            if showMessage {
                Text("Search for \(searchText)")
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            showMessage = false
                        }
                    }
            }
        }
        .padding()
    }
}

#Preview {
    ShowTextFieldActionView()
}
