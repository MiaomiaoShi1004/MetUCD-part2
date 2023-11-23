//
//  IconText.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 23/11/2023.
//

import SwiftUI

struct IconText: View {
    var logo: String
    var value: String
    
    var body: some View {
        HStack (spacing: 10) {
            Image(systemName: logo)
                .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)

            Text(value)
                .lineLimit(1)
        }
    }
}

#Preview {
    IconText(logo: "sunrise", value: "14:53")
}
