//
//  PlaceAnnotationDataModel.swift
//  CWKTemplate24
//
//  Created by girish lukka on 23/10/2024.
//

import Foundation
import MapKit

/* Code  to manage tourist place map pins */

struct PlaceAnnotationDataModel: Identifiable {
    //attributes needed for the tourist attractiosn
    
    // MARK:  list of attributes to map pins
    let id = UUID()
    let title: String
    let latitude: Double
    let longitude: Double

    //convert lat and lon
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(title: String, latitude: Double, longitude: Double) {
        self.title = title
        self.latitude = latitude
        self.longitude = longitude
    }

}
