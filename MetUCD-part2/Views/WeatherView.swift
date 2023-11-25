//
//  ContentView.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 23/11/2023.
//

import SwiftUI
import Charts

struct WeatherView: View {
    var weatherManager = WeatherManager() // Initialize the WeatherManager
    @State var currentWeather: currentWeatherModel?
    @State var forecastWeather: ForecastWeatherModel?
    
    @State var currentAirPollution: AirPollutionModel?
    @State var forecastAirPollution: AirPollutionModel?
    
    @State private var inputLocation: String = ""
    @State private var errorMessage: String = ""
    
    // For the chart define an empty array first
    @State private var airPollutionIndexes: [AirQualityDataPoint] = [
    ]
    
    
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
                
                
                // Air pollution Index Forcast
                if let airPollutionForcastData = forecastAirPollution {
                    Section(header: Text("Air Pollution Index Forecast")) {
                    }
                    .onAppear {
                        for item in airPollutionForcastData.list {
                              let dateString = convertTimestampToString(item.dt)
                              let aqi = item.main.aqi
                              addIndexData(dt: dateString, aqi: aqi)
                          }
                    }
                    VStack {
                        Chart {
                            ForEach(airPollutionIndexes, id: \.dt) { dataPoint in
                                LineMark(
                                    x: .value("section", dataPoint.dt),
                                    y: .value("Air Quality Index", dataPoint.aqiLevel)
                                )
                                .foregroundStyle(by: .value("AQI Level", "AQI Level"))
                                .interpolationMethod(.catmullRom)
                            }
                        }
                        .chartForegroundStyleScale(["AQI Level": Color.blue])
                        .chartXScale(range: .plotDimension(padding: 20.0))
                        .chartXAxis(.hidden)
                        .chartYAxis {
                            AxisMarks(position: .trailing)
                        }
                        .chartPlotStyle { plotArea in
                            plotArea.frame(maxWidth: .infinity, minHeight: 250.0, maxHeight: 250.0)
                        }
                        .chartLegend(.hidden)
                    }
                    .padding()
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



private extension WeatherView {
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
    
    // popping the weather index array ( but in a unique way)
    func addIndexData(dt: String, aqi: Int) {
        // Check if `dt` already exists in `airPollutionIndexes`
        if !airPollutionIndexes.contains(where: { $0.dt == dt }) {
            let newData = AirQualityDataPoint(dt: dt, aqi: aqi)
            airPollutionIndexes.append(newData)
        } else {
            // Optionally, handle the case where `dt` is not unique, such as updating the existing record's `aqi`
            if let index = airPollutionIndexes.firstIndex(where: { $0.dt == dt }) {
                airPollutionIndexes[index].aqi = aqi
            }
        }
    }

    
    // helper method for converting the timestamp to a string
    func convertTimestampToString(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Adjust the format as needed
        return dateFormatter.string(from: date)
    }
}


#Preview {
    WeatherView()
//    ContentView(currentWeather: previewWeather,
//                forecastWeather: preForecastWeather,
//                currentAirPollution: preCurrentAirPollution,
//                forecastAirPollution: preForecastAirPollution)
}
