//
//  ContentView.swift
//  Weather App
//
//  Created by Jack Turner on 9/10/23.
//
import SwiftUI

struct ContentView: View {
    @State private var location = ""
    @State private var weatherDescription = ""
    @State private var temperature = 0.0

    var body: some View {
        VStack {
            Image(systemName: "cloud.sun.fill")
                .resizable()
                .frame(width: 200, height: 150)
                .foregroundColor(.blue)
                .padding(.bottom, 20)

            TextField("Enter location", text: $location)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)

            Button(action: {
                // Call a function to fetch weather data based on the location
                fetchWeather()
            }) {
                Text("Get Weather")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }.padding(.top, 250)

            if !weatherDescription.isEmpty {
                Text("Weather: \(weatherDescription)")
                    .padding()

                Text("Temperature: \(temperature)°C")
                    .padding()
            }

            Spacer()
        }
        .padding()
    }

    // Function to fetch weather data based on the location
    func fetchWeather() {
        let apiKey = "318551a066f8d29bfbc017c7b7313101"

        let apiUrl = "https://api.openweathermap.org/data/2.5/weather?q=\(location)&appid=\(apiKey)"
        
        if let url = URL(string: apiUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                        DispatchQueue.main.async {
                            weatherDescription = weatherData.weather.first?.description ?? "N/A"
                            temperature = weatherData.main.temp - 273.15 // Convert to Celsius
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct WeatherData: Codable {
    let weather: [Weather]
    let main: Main
}

struct Weather: Codable {
    let description: String
}

struct Main: Codable {
    let temp: Double
}


