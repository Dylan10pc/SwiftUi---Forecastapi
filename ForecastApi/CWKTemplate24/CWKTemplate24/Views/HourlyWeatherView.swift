//
//  HourlyWeatherView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI

struct HourlyWeatherView: View {

    // MARK:  set up the @EnvironmentObject for WeatherMapPlaceViewModel
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    //function the hour into a proper format
    func formatHour(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatdate = DateFormatter()
        formatdate.dateFormat = "ha E"
        return formatdate.string(from: date)
    }

    var body: some View {
        //checks if we have weather data
        if let hourlyweatherdata = weatherMapPlaceViewModel.weatherdatamodel?
            .hourly,
            !hourlyweatherdata.isEmpty
        {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {

                    //loop through the 48hours
                    ForEach(hourlyweatherdata.prefix(48), id: \.dt) { hour in
                        VStack {
                            //display the time
                            Text(formatHour(from: hour.dt))
                                .font(.caption)
                                .padding()

                            //display the temp
                            Text("\(Int(hour.temp))°C")
                                .font(.body)

                            //display the weather
                            Text(
                                hour.weather.first?.description
                                    ?? "Unknown Weather"
                            )
                            .font(.caption)
                            .padding()
                        }
                        //set fix size
                        .frame(width: 120, height: 120)
                        .background(Color.cyan)
                    }
                }
                .padding()
            }
            .frame(height: 200)
        }
    }
}

#Preview {
    HourlyWeatherView()
        .environmentObject(WeatherMapPlaceViewModel())
}
