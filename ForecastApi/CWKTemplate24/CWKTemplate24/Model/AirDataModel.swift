//
//  AirDataModel.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import Foundation

/* Code for AirDataModel Struct */
//model for the air quality json structure
struct AirDataModel: Codable {

    // MARK:  AirDataModel
    let coord: Coord
    let list: [AirData]
}
// MARK: - coords
struct Coord: Codable {
    let lon: Double
    let lat: Double
}

// MARK: - airdata
struct AirData: Codable, Identifiable {
    let id = UUID()
    let dt: Int
    let main: AirQuality
    let components: Components

    enum CodingKeys: String, CodingKey {
        case dt, main, components
    }
}

// MARK: - airquality
struct AirQuality: Codable {
    let aqi: Int
}

// MARK: - comp
struct Components: Codable {
    let co: Double
    let no: Double
    let no2: Double
    let o3: Double
    let so2: Double
    let pm2_5: Double
    let pm10: Double
    let nh3: Double

    enum CodingKeys: String, CodingKey {
        case co, no, no2, o3, so2
        case pm2_5 = "pm2_5"
        case pm10 = "pm10"
        case nh3
    }
}
