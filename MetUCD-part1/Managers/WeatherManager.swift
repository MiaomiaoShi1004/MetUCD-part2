//
//  WeatherManager.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 23/11/2023.
//

import Foundation


enum WeatherError: Error {
    case badURL
    case serverError
    case decodingError
}

class WeatherManager {
    
    // public read only roperties to store longitude and latitude to parse into the air pollution func, initially set as nil(will generate error if directly pass into airpollution func
    private(set) var currentLongitude: Double?
    private(set) var currentLatitude: Double?
    
    // CurrentWeatherAPI
    // Function to fetch current weather data from the OpenWeather API
    func getCurrentWeather(location inputLocation: String) async throws -> ResponseBody {
        // Constructing the URL string
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(inputLocation)&appid=8b75a684ffe1eab191d21598865bb79d&units=metric"

        // Ensure the URL is valid, throw a badURL error if not
        guard let url = URL(string: urlString) else {
            throw WeatherError.badURL
        }
        
        // Attempt to fetch data from the server
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))

        // Check for a successful response (status code 200), throw a serverError otherwise
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw WeatherError.serverError
        }
        
        do {
            // Attempt to decode the JSON response into the ResponseBody structure
            let decodedData = try JSONDecoder().decode(ResponseBody.self, from: data)
            currentLongitude = floor(decodedData.coord.lon)
            currentLatitude = floor(decodedData.coord.lat)
            return decodedData
        } catch {
            throw WeatherError.decodingError
        }
    }
    
    // ForecastWeatherAPI call
    func getForecastWeather(location inputLocation: String) async throws -> ForecastWeatherModel {
        
        // Constructing the URL string
        let urlString = "https://api.openweathermap.org/data/2.5/forecast?q=\(inputLocation)&appid=8b75a684ffe1eab191d21598865bb79d&units=metric"

        // Ensure the URL is valid, throw a badURL error if not
        guard let url = URL(string: urlString) else {
            throw WeatherError.badURL
        }
        
        // Attempt to fetch data from the server
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))

        // Check for a successful response (status code 200), throw a serverError otherwise
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw WeatherError.serverError
        }
        
        do {
            // Attempt to decode the JSON response into the ResponseBody structure
            let decodedForecastData = try JSONDecoder().decode(ForecastWeatherModel.self, from: data)
            return decodedForecastData
        } catch {
            throw WeatherError.decodingError
        }
    }
    
    // For air pollution
    func getCurrentAirPollution(latitude: Double, longitude: Double) async throws -> AirPollutionModel {
        // Constructing the URL string
        let urlString = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(latitude)&lon=\(longitude)&appid=8b75a684ffe1eab191d21598865bb79d&units=metric"

        // Ensure the URL is valid, throw a badURL error if not
        guard let url = URL(string: urlString) else {
            throw WeatherError.badURL
        }
        
        // Attempt to fetch data from the server
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))

        // Check for a successful response (status code 200), throw a serverError otherwise
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw WeatherError.serverError
        }
        
        do {
            // Attempt to decode the JSON response into the AirPollutionModel structure
            let decodedAirPollutionData = try JSONDecoder().decode(AirPollutionModel.self, from: data)
            return decodedAirPollutionData
        } catch {
            throw WeatherError.decodingError
        }
    }


    func getForecastAirPollution(latitude: Double, longitude: Double) async throws -> AirPollutionModel {
        // Constructing the URL string
        let urlString = "https://api.openweathermap.org/data/2.5/air_pollution/forecast?lat=\(latitude)&lon=\(longitude)&appid=8b75a684ffe1eab191d21598865bb79d&units=metric"

        // Ensure the URL is valid, throw a badURL error if not
        guard let url = URL(string: urlString) else {
            throw WeatherError.badURL
        }
        
        // Attempt to fetch data from the server
        let (data, response) = try await URLSession.shared.data(for: URLRequest(url: url))

        // Check for a successful response (status code 200), throw a serverError otherwise
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw WeatherError.serverError
        }
        
        do {
            // Attempt to decode the JSON response into the AirPollutionModel structure
            let decodedAirPollutionData = try JSONDecoder().decode(AirPollutionModel.self, from: data)
            return decodedAirPollutionData
        } catch {
            throw WeatherError.decodingError
        }
    }
    
}
