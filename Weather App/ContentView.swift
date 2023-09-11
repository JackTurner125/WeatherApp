//
//  ContentView.swift
//  Weather App
//
//  Created by Jack Turner on 9/10/23.
//
import SwiftUI
import FirebaseCore
import FirebaseFirestore


struct ContentView: View {
    @State private var location = ""
    @State private var weatherDescription = ""
    @State private var temperature = ""
    let db = Firestore.firestore()

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

                Text("Temperature: \(temperature)°F")
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
        
        var tempLiteral = 0.0
        
        if let url = URL(string: apiUrl) {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let weatherData = try JSONDecoder().decode(WeatherData.self, from: data)
                        DispatchQueue.main.async {
                            weatherDescription = weatherData.weather.first?.description ?? "N/A"
                            tempLiteral = ((weatherData.main.temp - 273.15) * 1.8 + 32).rounded()// Convert to Farenheit
                            temperature = truncateTemp(tempLiteral)
                            storeWeather(weatherData)
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                }
            }.resume()
        }
    }
    
    func truncateTemp(_ temp: Double) -> String {
        let tempVar = String(format: "%g", temp)
        return tempVar
    }
    
    func storeWeather(_ weather: WeatherData) {
        let data: [String: Any] = [
            "desciption": weather.weather.description,
            "temperature": truncateTemp(((weather.main.temp - 273.15) * 1.8 + 32).rounded())
        ]
        db.collection("Weather").addDocument(data: data)
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


