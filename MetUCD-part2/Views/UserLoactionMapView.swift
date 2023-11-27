//
//  UserLoactionMapView.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 27/11/2023.
//

import SwiftUI
import MapKit

struct UserLoactionMapView: View {

    @State var camera: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 53.309938529972854,
                longitude: -6.2215091104457905),
            span: MKCoordinateSpan(
                latitudeDelta: 0.006,
                longitudeDelta: 0.006)))
    
    var body: some View {
        Map(position: $camera) {
            Annotation("currentLocation", coordinate: CLLocationCoordinate2D(
                latitude: 53.309938529972854,
                longitude: -6.2215091104457905)) {
                ZStack {
                    Image(systemName: "location.viewfinder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                .frame(width: 80, height: 80)
            }
            .annotationTitles(.hidden)
        }
    }
}

#Preview {
    UserLoactionMapView()
}
