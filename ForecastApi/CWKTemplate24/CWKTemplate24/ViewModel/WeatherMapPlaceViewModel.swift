//
//  WeatherMapPlaceViewModel.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import CoreLocation
import Foundation
@preconcurrency import MapKit

class WeatherMapPlaceViewModel: ObservableObject {

    // MARK:   published variables section - add variables that you need here and not that default location must be London

    /* Add other published varaibles that you are required here, you have been given one main one
     */

    //models that hold info about weather and air
    @Published var weatherdatamodel: WeatherDataModel?
    @Published var airdatamodel: AirDataModel?
    //holds list of tourist attractions
    @Published var touristattractions: [PlaceAnnotationDataModel] = []
    //holds errors
    @Published var defineerror: String?
    @Published var newLocation = "London"

    // other attributes with suitable comments

    // MARK:  function to get coordinates safely for a place:
    //fetches coords for london or any aother city and gets the data too
    func fetchInitialData() async {
        do {
            try await getCoordinatesForCity()
        } catch {
            DispatchQueue.main.async {
                self.defineerror =
                    "Failed to fetch weather data: \(error.localizedDescription)"
            }
        }
    }

    func getCoordinatesForCity() async throws {
        // write code for this function with suitable comments
        //convert city name into geo coords
        let geocoder = CLGeocoder()

        do {
            //geoode the city name to get its coords
            let citymark = try await geocoder.geocodeAddressString(
                newLocation)

            //makes sure that the location is valid
            guard let cityloc = citymark.first?.location else {
                throw NSError(
                    domain: "error location", code: 404,
                    userInfo: [NSLocalizedDescriptionKey: "no location found."]
                )
            }

            //fetch weather and air data
            try await fetchWeatherData(
                lat: cityloc.coordinate.latitude,
                lon: cityloc.coordinate.longitude)

            //fetch attracractions and map annotations
            try await setAnnotations(
                lat: cityloc.coordinate.latitude,
                lon: cityloc.coordinate.longitude)

        } catch {
            //error if coords cant be grabbed
            DispatchQueue.main.async {
                self.defineerror =
                    "failed to grab coordinates for, \(self.newLocation): \(error.localizedDescription)"
            }
            throw error
        }

    }

    // MARK:  function to fetch weather data safely from openweather using location coordinates

    func fetchWeatherData(lat: Double, lon: Double) async throws {

        // write code for this function with suitable comments
        //api
        let apikey = "b70857aa1bb590c6955564c902372344"

        //puts apikey onto the url
        guard
            let weatherdataurl = URL(
                string:
                    "https://api.openweathermap.org/data/3.0/onecall?lat=\(lat)&lon=\(lon)&exclude=alerts&units=metric&appid=\(apikey)"
            ),
            let airdataurl = URL(
                string:
                    "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(lat)&lon=\(lon)&appid=\(apikey)"
            )
        else {
            throw NSError(
                domain: "URL error", code: 400,
                userInfo: [NSLocalizedDescriptionKey: "invalid url api"])
        }

        //fetch weather and air data
        do {
            let (weatherapidata, _) = try await URLSession.shared.data(
                from: weatherdataurl)
            let (airapidata, _) = try await URLSession.shared.data(
                from: airdataurl)

            //print out the raw json file that gets fetched
            if let weatherJSONString = String(
                data: weatherapidata, encoding: .utf8)
            {
                print("Weather JSON Data: \(weatherJSONString)")
            }
            if let airJSONString = String(data: airapidata, encoding: .utf8) {
                print("Air Quality JSON Data: \(airJSONString)")
            }

            //decode json into model
            let weatherdata = try JSONDecoder().decode(
                WeatherDataModel.self, from: weatherapidata)
            let airdata = try JSONDecoder().decode(
                AirDataModel.self, from: airapidata)

            //update published var with fetched data
            DispatchQueue.main.async {
                self.weatherdatamodel = weatherdata
                self.airdatamodel = airdata
            }

        } catch {
            print("error getting data, \(error.localizedDescription)")
            throw error
        }
    }

    // MARK:  function to get tourist places safely for a  map region and store for use in showing them on a map

    func setAnnotations(lat: Double, lon: Double) async throws {
        // write code for this function with suitable comments

        //gets nearby attractions with mklocalserach and updates the list
        //do a serach to find tourist attractions around the given coords
        let searchrequest = MKLocalSearch.Request()
        searchrequest.naturalLanguageQuery = "tourist attractions"
        searchrequest.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: lat, longitude: lon),
            //define the size of the search
            latitudinalMeters: 100000,
            longitudinalMeters: 100000
        )

        //make the search
        let search = MKLocalSearch(request: searchrequest)
        let response = try await search.start()

        //update the tourist attraction
        DispatchQueue.main.async {
            //adds results from search results to the model
            self.touristattractions = response.mapItems.compactMap { item in
                guard let cityname = item.name else { return nil }
                return PlaceAnnotationDataModel(
                    title: cityname,
                    latitude: item.placemark.coordinate.latitude,
                    longitude: item.placemark.coordinate.longitude
                )
            }
        }
    }

}
