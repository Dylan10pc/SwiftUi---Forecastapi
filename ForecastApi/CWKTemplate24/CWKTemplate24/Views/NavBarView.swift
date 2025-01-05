//
//  NavBarView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftData
import SwiftUI

struct NavBarView: View {

    // MARK:  Varaible section - set up variable to use WeatherMapPlaceViewModel and SwiftData

    /*
     set up the @EnvironmentObject for WeatherMapPlaceViewModel
     Set up the @Environment(\.modelContext) for SwiftData's Model Context
     Use @Query to fetch data from SwiftData models

     State variables to manage locations and alertmessages
     */

    @EnvironmentObject var weathermapplaceviewmodel: WeatherMapPlaceViewModel
    @Environment(\.modelContext) private var modelContext
    @Query var locationstorage: [LocationModel]

    //manage the citylocation
    @State private var citylocation: String = ""
    //manage alert messages
    @State private var definealert: String = ""
    //lets alerts pop up if true
    @State private var showalert: Bool = false

    // MARK:  Configure the look of tab bar

    init() {
        // Customize TabView appearance
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        UITabBar.appearance().standardAppearance = appearance
    }

    var body: some View {
        VStack {
            ZStack {
                Image("BG")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()

                VStack {
                    //text next to search bar
                    HStack {
                        Text("Change Location")
                            .font(.headline)
                            .bold()
                            .padding()

                        TextField("Enter Location", text: $citylocation)
                            //makes input field
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                            .onSubmit {
                                //when submit changes the location
                                Task {
                                    weathermapplaceviewmodel.newLocation =
                                        citylocation
                                    do {
                                        //checks if location exists in the storage
                                        if let locationexists =
                                            locationstorage.first(where: {
                                                $0.name.lowercased()
                                                    == citylocation.lowercased()
                                            })
                                        {
                                            definealert =
                                                "\(citylocation) is already stored. Using stored coordinates."

                                            //if location is stored already use that coord
                                            showalert = true
                                            try await weathermapplaceviewmodel
                                                .fetchWeatherData(
                                                    lat: locationexists
                                                        .latitude,
                                                    lon: locationexists
                                                        .longitude)
                                            //if not then fetch from the viewmodel function
                                        } else {
                                            try await weathermapplaceviewmodel
                                                .getCoordinatesForCity()

                                            //if the weather is fetched properly
                                            //store the new location
                                            if let weatherdata =
                                                weathermapplaceviewmodel
                                                .weatherdatamodel
                                            {
                                                let newcitylocation =
                                                    LocationModel(
                                                        name: citylocation,
                                                        latitude: weatherdata
                                                            .lat,
                                                        longitude: weatherdata
                                                            .lon
                                                    )
                                                //save new location
                                                modelContext.insert(
                                                    newcitylocation)
                                                try await modelContext.save()
                                            }

                                            //lets users know location has been updated
                                            definealert =
                                                "Location updated to \(citylocation) and saved."
                                            showalert = true
                                        }
                                        //lets users know location couldnt update
                                    } catch {
                                        definealert =
                                            "Failed to update location: \(error.localizedDescription)"
                                        showalert = true
                                    }
                                }
                            }
                    }
                    .padding()
                }
            }
            .frame(maxHeight: 30)

            // TabView
            TabView {
                CurrentWeatherView()
                    .tabItem {
                        Label("Now", systemImage: "sun.max.fill")
                    }

                ForecastWeatherView()
                    .tabItem {
                        Label("5-Day Weather", systemImage: "calendar")
                    }
                MapView()
                    .tabItem {
                        Label("Place Map", systemImage: "map")
                    }
                VisitedPlacesView()
                    .tabItem {
                        Label("Stored Places", systemImage: "globe")
                    }
            }
            //fetch the default location when view appears
            .onAppear {
                Task {
                    await weathermapplaceviewmodel.fetchInitialData()
                }
            }
        }
        //how the alert will look like
        .alert(isPresented: $showalert) {
            Alert(
                title: Text("Alert"), message: Text(definealert),
                dismissButton: .default(Text("OK")))
        }
        .frame(maxHeight: .infinity)
    }
}

#Preview {
    NavBarView()
        .environmentObject(WeatherMapPlaceViewModel())
}
