//
//  LaunchMapView.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 25/11/2023.
//

import MapKit
import SwiftUI

struct LaunchMapView: View {
    
    
    let spire = CLLocationCoordinate2D(latitude: 53.34992665027995, longitude:-6.260263231572287)
    let temp = 12
    
    @State var camera: MapCameraPosition = .automatic
    
    var body: some View {
        Map(position: $camera) {
//            Marker("Spire",monogram: Text("\(temp)"), coordinate: spire)
//                .tint(.green)
            
            UserAnnotation()
                .tint(.red)
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                Spacer()
                Button {
                    // center on the spire
                    camera = .region(MKCoordinateRegion(
                        center: spire,
                    latitudinalMeters: 200,
                    longitudinalMeters: 200))
                                     
                } label: {
                    Text("Spire")
                }
                Spacer()
            }
        }
        .padding(.top)
        .background(.thinMaterial)
        .mapControls() {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
    }
}

#Preview {
    LaunchMapView()
}
