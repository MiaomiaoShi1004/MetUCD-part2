//  This is a Model, will change the name in the future
//  currentWeatherModel.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 23/11/2023.
//

import Foundation

struct currentWeatherModel: Decodable {
    var coord: CoordResponse
    var weather: [WeatherResponse]
    var base: String
    var main: MainResponse
    var visibility: Int
    var wind: WindResponse
    var clouds: CloudsResponse
    var dt: Int
    var sys: SysResponse
    var timezone: Int
    var id: Int
    var name: String
    var cod: Int

    struct CoordResponse: Decodable {
        var lon: Double
        var lat: Double
    }

    struct WeatherResponse: Decodable {
        var id: Int
        var main: String
        var description: String
        var icon: String
    }

    struct MainResponse: Decodable {
        var temp: Double
        var feels_like: Double
        var temp_min: Double
        var temp_max: Double
        var pressure: Int
        var humidity: Int
    }

    struct WindResponse: Decodable {
        var speed: Double
        var deg: Int
        var gust: Double?
    }

    struct CloudsResponse: Decodable {
        var all: Int
    }

    struct SysResponse: Decodable {
        var type: Int
        var id: Int
        var country: String
        var sunrise: Int
        var sunset: Int
    }
}
