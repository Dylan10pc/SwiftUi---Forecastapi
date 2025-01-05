//
//  MapView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import MapKit
import SwiftUI

struct MapView: View {

    // MARK:  set up the @EnvironmentObject for WeatherMapPlaceViewModel
    //manage all model data
    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel

    //region displayed on the map
    //the default is london
    @State private var citylocation = MKCoordinateRegion(
        //default london coords
        center: CLLocationCoordinate2D(
            latitude: 51.5074,
            longitude: -0.1278
        ),
        //how zoomed in map is
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )

    var body: some View {
        ZStack {
            Image("sky")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {

                ZStack {
                    //map shows tourist attractions
                    Map(
                        //this binds to the var so when location changes so does this
                        coordinateRegion: $citylocation,
                        //cap to 5 attractions
                        annotationItems: Array(
                            weatherMapPlaceViewModel.touristattractions.prefix(
                                5)
                        )
                    ) { attractions in
                        //place the pin where the attraction is plus the title of the attraction
                        MapAnnotation(coordinate: attractions.coordinate) {
                            VStack {
                                Text("📍")
                                    .font(.title)
                                    .padding(5)
                                Text(attractions.title)
                                    .font(.caption)
                                    .padding(5)
                                    .background(Color.white)
                            }
                        }
                    }
                    //adjust the map
                    .frame(maxWidth: .infinity)
                    .padding(.top, 100)
                }
                //title with its edits
                Text(
                    "Top 5 Tourist Attractions in \(weatherMapPlaceViewModel.newLocation)"
                )
                .font(.title3)
                .fontWeight(.bold)
                .padding(10)
                .background(Color.black.opacity(0.4))

                //scrollview for top5 attractions
                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        //gets 5 attractions and caps it to 5
                        ForEach(
                            weatherMapPlaceViewModel.touristattractions.prefix(
                                5)
                        ) { attractions in
                            //puts an emoji nefore the title
                            HStack {
                                Image(
                                    systemName: "mappin.circle.fill"
                                )
                                .foregroundColor(.red)
                                .font(.title2)
                                Text(attractions.title)
                                    .font(.headline)
                                    .padding(.leading, 8)
                            }
                            .padding()
                            Divider()
                        }
                    }
                    .padding()
                }
                //to change the bottom half
                .frame(height: 400)
                .padding(.bottom, 80)
            }
        }
        .onAppear {
            Task {
                //makes the map be centred on the first attraction
                await weatherMapPlaceViewModel.fetchInitialData()
                if let firstattraction = weatherMapPlaceViewModel
                    .touristattractions.first
                {
                    citylocation.center = firstattraction.coordinate
                }
            }
        }
    }
}
#Preview {
    MapView()
        .environmentObject(WeatherMapPlaceViewModel())
}
