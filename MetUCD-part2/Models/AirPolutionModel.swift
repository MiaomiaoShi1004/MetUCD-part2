//
//  AirPolutionModel.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 24/11/2023.
//

import Foundation
import SwiftUI

struct AirPollutionModel: Decodable {
    var coord: Coord
    var list: [PollutionItem]

    struct Coord: Decodable {
        var lon: Double
        var lat: Double
    }

    struct PollutionItem: Decodable {
        var main: Main
        var components: Components
        var dt: Int

        struct Main: Decodable {
            var aqi: Int
        }

        struct Components: Decodable {
            var co: Double
            var no: Double
            var no2: Double
            var o3: Double
            var so2: Double
            var pm2_5: Double
            var pm10: Double
            var nh3: Double
        }
    }
}

// Define a simple struct to hold each component's name and value
struct ComponentValue: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let value: Double
}

// Extend your AirPollutionModel.PollutionItem.Components to return an array of ComponentValue
extension AirPollutionModel.PollutionItem.Components {
    var allComponents: [ComponentValue] {
        [
            ComponentValue(name: "CO", value: co),
            ComponentValue(name: "NO", value: no),
            ComponentValue(name: "NO2", value: no2),
            ComponentValue(name: "O3", value: o3),
            ComponentValue(name: "SO2", value: so2),
            ComponentValue(name: "PM2.5", value: pm2_5),
            ComponentValue(name: "PM10", value: pm10),
            ComponentValue(name: "NH3", value: nh3)
        ]
    }
}

//Define a struct to represent each data point in the chart:
struct AirQualityDataPoint {
    var dt: String
    var aqi: Int
    
    var aqiLevel: String {
        switch aqi {
        case 1:
            return "Good"
        case 2:
            return "Fair"
        case 3:
            return "Moderate"
        case 4:
            return "Poor"
        case 5:
            return "VeryPoor"
        default:
            return "Unknown"
        }
    }
}
