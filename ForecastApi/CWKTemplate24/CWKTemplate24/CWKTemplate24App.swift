//
//  CWKTemplate24App.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftUI

@main
struct CWKTemplate24App: App {
    // MARK:  create a StateObject - weatherMapPlaceViewModel and inject it as an environmentObject.
    @StateObject private var weatherMapPlaceViewModel =
        WeatherMapPlaceViewModel()

    var body: some Scene {
        WindowGroup {
            //main entry point of the app
            NavBarView()
                //inject weatherplaceviewmodel which is shared to all views
                .environmentObject(weatherMapPlaceViewModel)

            // MARK:  Create a database to store locations using SwiftData

        }
        //model container for the location model
        .modelContainer(for: [LocationModel.self])
    }
}
