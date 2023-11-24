//
//  ContentView.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 23/11/2023.
//

import SwiftUI

struct ContentView: View {
    var weatherManager = WeatherManager() // Initialize the WeatherManager
    @State var currentWeather: currentWeatherModel?
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
                    
                    Section(header: Text("GEO info")) {
                        IconText(logo: "location", value: "\(weatherData.coord.lon.toDMS()), \(weatherData.coord.lat.toDMS())")
                        HStack {
                            IconText(logo: "sunrise", value: "\(weatherData.sys.sunrise.toTimeStringInLondon())")
                            
                            Text("(\(weatherData.sys.sunrise.toLocalTimeString(timezoneOffset: weatherData.timezone)))")
                                .font(.system(size:13))
                                .foregroundColor(.secondary)

                            
                            IconText(logo: "sunset", value: "\(weatherData.sys.sunset.toTimeStringInLondon())")
                            Text("(\(weatherData.sys.sunset.toLocalTimeString(timezoneOffset: weatherData.timezone)))")
                                .font(.system(size:13))
                                .foregroundColor(.secondary)
                        }
                        IconText(logo: "clock.arrow.2.circlepath", value: "\(weatherData.timezone.formatTimeZone())")
                    }
                    
                    Section(header: Text("WEATHER: \(weatherData.weather[0].description)")) {
                        HStack() {
                            IconText(logo: "thermometer.medium", value: String(format: "%.0f°", weatherData.main.feels_like))
                            
                            Text("(L: \(String(format: "%.0f°", weatherData.main.temp_min)) H: \(String(format: "%.0f°", weatherData.main.temp_max)))")
                                .foregroundColor(.secondary)
                            
                            IconText(logo: "thermometer.variable.and.figure", value: "Feels \(String(format: "%.0f°", weatherData.main.feels_like))")
                        }
                        IconText(logo: "cloud", value: "\(String(format: "%.0f%%", weatherData.clouds.all)) \(weatherData.weather[0].main)")
                        IconText(logo: "wind", value: "\(String(format: "%.1f km/h, dir: %.0f°", weatherData.wind.speed, weatherData.wind.deg))")
                        HStack(spacing:10) {
                            IconText(logo: "humidity", value: String(format: "%.0f%%", weatherData.main.feels_like))
                            IconText(logo: "thermometer.sun.circle", value: "\(String(format: "%.0f hPa", weatherData.main.pressure))")
                        }
                    }
                }
                
                //
                if let airPollutionForcastData = forecastAirPollution {
                    Section(header: Text("air pollution index forcast")) {
                        Text("\(airPollutionForcastData.list[0].main.aqi)")
                    }
                }
                
                // Section for Air Quality -- using ForEach to loop through
                if let airPollutionData = currentAirPollution {
                    Section(header: Text("Air quality")) {
                        // Assume there is only one PollutionItem in your data
                        let components = airPollutionData.list[0].components.allComponents
                        // Group the components into pairs
                        let rows = components.chunked(into: 2)
                        ForEach(rows, id: \.self) { row in
                            HStack {
                                ForEach(row) { component in
                                    HStack {
                                        Text("\(component.name)")
                                            .foregroundColor(/*@START_MENU_TOKEN@*/.blue/*@END_MENU_TOKEN@*/)
                                        Text("\(component.value, specifier: "%.1f")")
                                    }
                                    Spacer()
                                }
                                
                            }
                        }
                        Text("(unit μg/m³)")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
                
                // Section for forecast weather data
                if let forecastData = forecastWeather {
                    Section(header: Text("Forecast Weather")) {
                        
                        if let weatherData = currentWeather {
                            HStack {
                                Text("Today")
                                    .foregroundColor(.blue)
                                Spacer()
                                IconText(logo: "thermometer.medium", value: "(L: \(String(format: "%.0f°", weatherData.main.temp_min)) H: \(String(format: "%.0f°", weatherData.main.temp_max)))")
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        let noonForecasts = forecastData.list.filter { $0.dt_txt.contains("12:00:00") }

                        ForEach(noonForecasts, id: \.dt_txt) { forecast in
                            // Assuming forecast.dt is a Unix timestamp
                            let dayOfWeek = forecast.dt.dayOfTheWeek()
                            HStack {
                                Text("\(dayOfWeek)")
                                    .foregroundColor(.blue)
                                Spacer()
                                IconText(logo: "thermometer.medium", value: "(L: \(String(format: "%.0f°", forecast.main.temp_min)) H: \(String(format: "%.0f°", forecast.main.temp_max)))")
                                    .foregroundColor(.secondary)
                            }
                        }
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
