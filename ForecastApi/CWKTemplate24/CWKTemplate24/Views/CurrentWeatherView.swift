//
//  CurrentWeatherView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI

struct CurrentWeatherView: View {

    // MARK:  set up the @EnvironmentObject for WeatherMapPlaceViewModel
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    // MARK:  set up local @State variable to support this view

    //format unix timne stamps into readable date strings
    func formattedDate(from timestamp: TimeInterval) -> String {
        return DateFormatterUtils.formattedDateTime(from: timestamp)
    }

    var body: some View {
        VStack {
            ZStack {
                Image("sky")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    //will get the new location name
                    Text(weatherMapPlaceViewModel.newLocation)
                        .font(.title2)
                        .padding()

                    //gets date
                    Text(
                        formattedDate(
                            from: TimeInterval(
                                weatherMapPlaceViewModel.weatherdatamodel?
                                    .current.dt
                                    ?? Int(Date().timeIntervalSince1970)))
                    )
                    .font(.title)
                    .padding()
                    .bold()

                    HStack {
                        //gets weather data to appear
                        let weather =
                            weatherMapPlaceViewModel.weatherdatamodel?.current
                            .weather.first?.main.rawValue.capitalized
                            ?? "Loading..."
                        //gets feels like to appear
                        let feelslike = Int(
                            weatherMapPlaceViewModel.weatherdatamodel?.current
                                .feelsLike ?? 0)
                        Text("\(weather) \nFeels like: \(feelslike)°C")
                    }
                    .padding()

                    HStack {
                        Image("temperature")
                            .resizable()
                            .frame(width: 32, height: 32)
                        //gets maxtemp to appear
                        let maxtemp = Int(
                            weatherMapPlaceViewModel.weatherdatamodel?.daily
                                .first?.temp.max ?? 0)
                        //gets mintemp to appear
                        let mintemp = Int(
                            weatherMapPlaceViewModel.weatherdatamodel?.daily
                                .first?.temp.min ?? 0)
                        Text("H: \(maxtemp)°C")
                        Text("L: \(mintemp)°C")
                    }
                    .padding()

                    HStack {
                        Image("windSpeed")
                            .resizable()
                            .frame(width: 32, height: 32)
                        //gets windspeed to appear
                        let windspeed =
                            weatherMapPlaceViewModel.weatherdatamodel?.current
                            .windSpeed ?? 0
                        Text("Wind: \(windspeed) m/s")
                    }
                    .padding()
                    //gets humidity to appear
                    HStack {
                        Image("humidity")
                            .resizable()
                            .frame(width: 32, height: 32)
                        let humidity =
                            weatherMapPlaceViewModel.weatherdatamodel?.current
                            .humidity ?? 0
                        Text("Humidity: \(humidity)%")
                    }
                    .padding()
                    HStack {
                        Image("pressure")
                            .resizable()
                            .frame(width: 32, height: 32)
                        //gets pressure to appear
                        let pressure =
                            weatherMapPlaceViewModel.weatherdatamodel?.current
                            .pressure ?? 0
                        Text("Pressure: \(pressure) hPa")
                    }

                    //divide the air quality from weather data
                    Divider()
                        .padding()

                    //title for air quality
                    Text(
                        "Current Air Quality in \(weatherMapPlaceViewModel.newLocation)"
                    )
                    .font(.headline)

                    VStack {
                        HStack {
                            VStack {
                                Image("so2")
                                Text("SO2")
                                //gets so2 to appear
                                let so2 =
                                    weatherMapPlaceViewModel.airdatamodel?.list
                                    .first?.components.so2 ?? 0
                                Text("\(String(format: "%.2f", so2)) µg/m³")
                            }
                            Spacer()
                            VStack {
                                Image("no")
                                Text("NO2")
                                //gets no2 to appear
                                let no2 =
                                    weatherMapPlaceViewModel.airdatamodel?.list
                                    .first?.components.no2 ?? 0
                                Text("\(String(format: "%.2f", no2)) µg/m³")
                            }
                            Spacer()
                            VStack {
                                Image("voc")
                                Text("VOC")
                                //gets voc to appear
                                let voc =
                                    weatherMapPlaceViewModel.airdatamodel?.list
                                    .first?.components.o3 ?? 0
                                Text("\(String(format: "%.2f", voc)) µg/m³")
                            }
                            Spacer()
                            VStack {
                                Image("pm")
                                Text("PM")
                                //gets pm to appear
                                let pm =
                                    weatherMapPlaceViewModel.airdatamodel?.list
                                    .first?.components.pm2_5 ?? 0
                                Text("\(String(format: "%.2f", pm)) µg/m³")
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear {
            Task {
                //fetch inital data when view appear so london
                await weatherMapPlaceViewModel.fetchInitialData()
            }
        }
    }
}

#Preview {
    CurrentWeatherView()
        .environmentObject(WeatherMapPlaceViewModel())
}
