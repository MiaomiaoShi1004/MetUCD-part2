//
//  ContentView.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 23/11/2023.
//

import SwiftUI

struct ContentView: View {
    var weatherManager = WeatherManager() // Initialize the WeatherManager
    @State var currentWeather: ResponseBody?
    @State var forecastWeather: ForecastWeatherModel?
    
    @State var currentAirPollution: AirPollutionModel?
    @State var forecastAirPollution: AirPollutionModel?
    
    @State private var inputLocation: String = ""
    @State private var errorMessage: String = ""
    

    var body: some View {
        NavigationView {
            Form {
                // Search Section
                Section(header: Text("Search")) {
                    TextField("Enter location e.g. Dublin, IE", text: $inputLocation, onCommit: fetchWeather)
                }
                
                if !errorMessage.isEmpty {
                    Text(errorMessage).foregroundColor(.red)
                }
                
                // This line checks if weather is not nil
                // Conditional view rendering based on API call result
                if let weatherData = currentWeather {
                    
                    Section(header: Text("Current Weather")) {
                        IconText(logo: "sunrise", value: "\(weatherData.coord.lon)")

                        Text("Longitude: \(weatherData.coord.lon)")
                        Text("Large")
                    }
                    
                    Section(header: Text("Current Weather B")) {
                        Text("Latitude: \(weatherData.coord.lat)")
                        Text("Large")
                    }
                }
                
                // Section for forecast weather data
                if let forecastData = forecastWeather {
                    Section(header: Text("Forecast Weather")) {
                        Text(forecastData.list[0].dt_txt)
                    }
                }
                
                // Section for current air pollution
                if let airPollutionData = currentAirPollution {
                    Section(header: Text("Air Pollution")) {
                        Text("\(airPollutionData.coord.lon)")
                    }
                }
                
                if let airPollutionForcastData = forecastAirPollution {
                    Section(header: Text("Forcast Pollution")) {
                        Text("\(airPollutionForcastData.list[0].main.aqi)")
                    }
                }
                
                
            }
            // .navigationBarTitle("Weather Info")
        }
    }
}

// Extend UIApplication for keyboard dismissal
extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}



private extension ContentView {
    // Function to fetch weather data
    private func fetchWeather() {
        // Reset the states for new search
        self.currentWeather = nil
        self.forecastWeather = nil
        self.errorMessage = ""
        
        Task {
            do {
                // Fetch current weather data
                let fetchedWeather = try await weatherManager.getCurrentWeather(location: inputLocation)
                self.currentWeather = fetchedWeather

                // Fetch forcast weather data
                let fetchedForcastWeather = try await weatherManager.getForecastWeather(location: inputLocation)
                self.forecastWeather = fetchedForcastWeather
                
                
                // Air Pollution
                let fetchedAirPollution = try await weatherManager.getCurrentAirPollution(latitude: weatherManager.currentLatitude!, longitude: weatherManager.currentLongitude!)
                self.currentAirPollution = fetchedAirPollution
                
                let fetchedForcastAirPollution = try await weatherManager.getForecastAirPollution(latitude: weatherManager.currentLatitude!, longitude: weatherManager.currentLongitude!)
                self.forecastAirPollution = fetchedForcastAirPollution
                
                
            } catch let error as WeatherError {
                // Handle specific WeatherError
                switch error {
                case .badURL:
                    self.errorMessage = "Invalid URL."
                case .serverError:
                    self.errorMessage = "Server error."
                case .decodingError:
                    self.errorMessage = "Decoding error."
                }
            } catch {
                // Print the error for debugging purposes
                print("Error: \(error.localizedDescription)")
                self.errorMessage = "An unknown error occurred:\(error.localizedDescription)"
                    
            }
        }
        UIApplication.shared.endEditing() // Dismiss the keyboard
    }
}


#Preview {
//    ContentView()
    ContentView(currentWeather: previewWeather,
                forecastWeather: preForecastWeather,
                currentAirPollution: preCurrentAirPollution,
                forecastAirPollution: preForecastAirPollution)
}
