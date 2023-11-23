//
//  ContentView.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 23/11/2023.
//

import SwiftUI

struct ContentView: View {
    var weatherManager = WeatherManager() // Initialize the WeatherManager
    @State var weather: ResponseBody?
    
    // Adding an initializer to accept weather data
    init(weather: ResponseBody? = nil) {
        self._weather = State(initialValue: weather)
    }
    
    @State private var inputLocation: String = "" // State for user input
    @State private var errorMessage: String = "" // State for error messages
    @State private var showError: Bool = false // Flag to show error messages
    @State private var showWeather: Bool = false // Flag to show weather data

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
                // Conditional view rendering based on API call result
                if let weatherData = weather {
                    
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

#Preview {
    ContentView(weather: previewWeather)
}

private extension ContentView {
    // Function to fetch weather data
    private func fetchWeather() {
        Task {
            do {
                // Attempt to fetch weather data
                let fetchedWeather = try await weatherManager.getCurrentWeather(location: inputLocation)
                self.weather = fetchedWeather // Store the fetched data
                self.showWeather = true // Set flag to show weather data
                self.showError = false // Reset error flag
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
                self.showError = true // Set flag to show error message
                self.showWeather = false // Reset weather data flag
            } catch {
                // Handle other errors
                self.errorMessage = "An unknown error occurred."
                self.showError = true
                self.showWeather = false
            }
        }
        UIApplication.shared.endEditing() // Dismiss the keyboard
    }
}
