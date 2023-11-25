//
//  BlurredIcon.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 26/11/2023.
//

import SwiftUI

struct BlurredIcon: View {
    var logo: String
    
    var body: some View {
        Image(systemName: "\(logo)")
            .font(.system(size: 45))
            .foregroundColor(.gray)
            .background(.regularMaterial)
            .frame(width: 44, height: 44)
            .clipShape(Circle())
    }
}

#Preview {
    BlurredIcon(logo: "location.circle")
}
