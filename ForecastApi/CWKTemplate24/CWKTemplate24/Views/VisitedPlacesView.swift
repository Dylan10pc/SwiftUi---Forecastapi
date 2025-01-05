//
//  VisitedPlacesView.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import SwiftData
import SwiftUI

struct VisitedPlacesView: View {
    /*
    Set up the @Environment(\.modelContext) for SwiftData's Model Context
    Use @Query to fetch data from SwiftData models
*/

    @EnvironmentObject var weatherMapPlaceViewModel: WeatherMapPlaceViewModel
    @Environment(\.modelContext) private var modelContext
    //fetch saved locations from the database
    @Query var locationstorage: [LocationModel]

    //message for alert and also if alert should show or not
    @State private var definealert: String = ""
    @State private var showalert: Bool = false

    var body: some View {
        ZStack {
            Image("sky")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()

            VStack {
                //title section
                Text("Weather Locations In Database")
                    .font(.title2)
                    .bold()
                    .padding(.top, 100)

                //if location is empty then get this to appear
                if locationstorage.isEmpty {
                    Text("No locations saved yet.")
                        .font(.headline)
                        .padding()
                    //list all saved locations
                } else {
                    List {
                        //for each location get its name and coords
                        ForEach(locationstorage) { city in
                            VStack {
                                Text(
                                    "\(city.name) (\(city.latitude),\(city.longitude))"
                                )
                                .font(.subheadline)
                            }

                            //to delete location if not needed
                            .swipeActions {
                                Button(role: .destructive) {
                                    deleteLocation(city)
                                } label: {
                                    Label("Delete", systemImage: "trash.fill")
                                }
                            }
                        }
                    }
                    //hide the background of list for a clean look
                    .scrollContentBackground(.hidden)

                }
            }
            .padding(.top, 60)
        }
        .frame(maxHeight: .infinity)
        //how alerts will be displayed
        .alert(isPresented: $showalert) {
            Alert(
                title: Text("Alert"), message: Text(definealert),
                dismissButton: .default(Text("OK")))
        }
    }

    private func deleteLocation(_ location: LocationModel) {
        Task {
            do {
                //delete locations from the modelcontext and save it
                modelContext.delete(location)
                try await modelContext.save()
                definealert = "\(location.name) has been deleted."
                showalert = true
            } catch {
                //if location cant be deleted this alert will show up
                definealert =
                    "Failed to delete location: \(error.localizedDescription)"
                showalert = true
            }
        }
    }
}

#Preview {
    VisitedPlacesView()
        .environmentObject(WeatherMapPlaceViewModel())
}
