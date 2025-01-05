//
//  ForecastWeatherView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI

struct ForecastWeatherView: View {

    // MARK:  set up the @EnvironmentObject for WeatherMapPlaceViewModel
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    var body: some View {
        ZStack {
            Image(
                "sky"
            )
            .resizable()
            .scaledToFill()
            .ignoresSafeArea()

            //gets title forecast location
            VStack(spacing: 10) {
                Text(
                    "Hourly Forecast Weather for \(weatherMapPlaceViewModel.newLocation)"
                )
                .font(.headline)
                .padding()

                //hourly weather called and will be displayed
                HourlyWeatherView()
                    .environmentObject(weatherMapPlaceViewModel)

                //daily weather called and will be diaplyed
                DailyWeatherView()
                    .environmentObject(weatherMapPlaceViewModel)
            }
        }
    }
}

#Preview {
    ForecastWeatherView()
        .environmentObject(WeatherMapPlaceViewModel())
}
