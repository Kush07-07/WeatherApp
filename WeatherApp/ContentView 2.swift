//
//  ContentView 2.swift
//  WeatherApp
//
//  Created by Kushagra Verma on 14/02/2025.
//


import SwiftUI

struct ContentView: View {
    @State private var city: String = "London"
    @State private var weather: WeatherResponse?
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            TextField("Enter city", text: $city)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button(action: {
                fetchWeather()
            }) {
                Text("Get Weather")
                    .padding().actionSheet(isPresented: /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Is Presented@*/.constant(false)/*@END_MENU_TOKEN@*/) {
                        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/ActionSheet(title: Text("Action Sheet"))/*@END_MENU_TOKEN@*/
                    }
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }

            if let weather = weather {
                Text("Temperature: \(weather.main.temp)°C")
                Text("Condition: \(weather.weather.first?.description ?? "")")
            } else if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .padding()
    }

    func fetchWeather() {
        let apiKey = "YOUR_API_KEY" // Replace with your OpenWeatherMap API key
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = error.localizedDescription
                }
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                self.weather = try decoder.decode(WeatherResponse.self, from: data)
                DispatchQueue.main.async {
                    self.errorMessage = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode JSON"
                }
            }
        }.resume()
    }
}

struct WeatherResponse: Codable {
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
}
