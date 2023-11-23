//
//  WeatherManager.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 23/11/2023.
//

import Foundation

// Define a custom error type for weather-related errors
enum WeatherError: Error {
    case badURL
    case serverError
    case decodingError
}

class WeatherManager {
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
            return decodedData
        } catch {
            throw WeatherError.decodingError
        }
    }
}
