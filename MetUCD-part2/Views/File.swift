//
//  File.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 27/11/2023.
//

import SwiftUI
import MapKit

struct Maps_Snippet: View {
    private let location = CLLocationCoordinate2D(
        latitude: CLLocationDegrees(floatLiteral: 37.3353),
        longitude: CLLocationDegrees(floatLiteral: -122.0097))

    var body: some View {
        Map {
            Marker("Pond", coordinate: location)
            UserAnnotation()
        }
        .mapControls {
            MapUserLocationButton()
            MapCompass()
        }
    }
}

#Preview {
    Maps_Snippet()
}
