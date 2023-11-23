//
//  ForcastWeatherModel.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 24/11/2023.
//

import Foundation

struct ForecastWeatherModel: Decodable {
    var list: [ForecastItems]
    
    struct ForecastItems: Decodable {
        var dt_txt: String
        var main: MainResponse
        
        struct MainResponse: Decodable {
            var temp_min: Double
            var temp_max: Double
        }
    }
}
