//
//  TestingLayoutView.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 24/11/2023.
//

import SwiftUI

struct User: Identifiable {
    var id = UUID()
    var name: String
    var age: Int
}

struct TestingLayoutView: View {
    // Sample data for the list
    let users = [
        [User(name: "Alice", age: 24), User(name: "Bob", age: 30)],
        [User(name: "Charlie", age: 28)]
    ]

    var body: some View {
        List {
            ForEach(0..<users.count, id: \.self) { sectionIndex in
                Section(header: Text("Section \(sectionIndex + 1)")) {
                    ForEach(users[sectionIndex]) { user in
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Name: \(user.name)")
                                    .font(.headline)
                                Text("Age: \(user.age)")
                                    .font(.subheadline)
                            }
                            Spacer()
                            // Additional UI elements can be added here
                        }
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TestingLayoutView()
    }
}
