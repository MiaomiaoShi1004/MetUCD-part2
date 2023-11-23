//
//  WeatherView.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 23/11/2023.
//

import SwiftUI

struct WeatherView: View {
    // initiate weather manager
    var weatherManager = WeatherManager()
    @State var weather: ResponseBody?
    
    @State private var inputLocation: String = ""
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                
            }
        }
    }
}

#Preview {
//    WeatherView()
    WeatherView(weather: previewWeather)
}
