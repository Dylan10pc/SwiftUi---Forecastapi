//
//  DailyWeatherView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI

struct DailyWeatherView: View {
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    //function the hour into a proper format
    func formatDate(from timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let formatdate = DateFormatter()
        formatdate.dateFormat = "EEEE dd"
        return formatdate.string(from: date)
    }

    var body: some View {
        //check if daily weather data is there
        if let dailyweatherdata = weatherMapPlaceViewModel.weatherdatamodel?
            .daily,
            !dailyweatherdata.isEmpty
        {
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    //loop through first 8 days
                    ForEach(dailyweatherdata.prefix(8), id: \.dt) { day in
                        HStack {
                            //adds a placeholder image
                            Image(systemName: "cloud.sun.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .padding()
                            //adds the date
                            VStack(alignment: .center) {
                                Text(formatDate(from: day.dt))
                                    .font(.caption)

                                //adds weather
                                Text(
                                    day.weather.first?.description
                                        ?? "Unknown Weather"
                                )
                                .font(.caption)
                            }
                            .padding()
                            //adds day temp
                            HStack {
                                VStack {
                                    Text("Day")
                                        .font(.caption)
                                    Text("\(Int(day.temp.max))°C")
                                        .font(.caption)
                                        .padding(.top, 2)
                                }

                                //adds night temp
                                VStack {
                                    Text("Night")
                                        .font(.caption)
                                    Text("\(Int(day.temp.min))°C")
                                        .font(.caption)
                                        .padding(.top, 2)
                                }
                            }
                            .padding()
                        }
                        //fixed values for
                        .background(Color.gray.opacity(0.3))
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .frame(height: 300)
        }
    }
}

#Preview {
    DailyWeatherView()
        .environmentObject(WeatherMapPlaceViewModel())
}
