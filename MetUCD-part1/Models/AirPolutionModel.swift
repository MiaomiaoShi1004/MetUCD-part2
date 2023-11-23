//
//  AirPolutionModel.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 24/11/2023.
//

import Foundation

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
