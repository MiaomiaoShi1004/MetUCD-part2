//
//  ContentView.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 25/11/2023.
//

import SwiftUI
import MapKit

struct ContentView: View {

    let tower = CLLocationCoordinate2D(
        latitude: 43.6427145122822,
        longitude: -79.38712117539345
    )

    let ago = CLLocationCoordinate2D(
        latitude: 43.653823848647725,
        longitude: -79.3925230435043
    )

    let rom = CLLocationCoordinate2D(
        latitude: 43.66785712547134,
        longitude: -79.39465908518817
    )
    
    @State var camera: MapCameraPosition = .automatic

    var body: some View {
        Map(position: $camera) {
            Marker("CN Tower", systemImage: "building", coordinate: tower)
                .tint(.blue)
            
            // How to customize the icon in the map
            Annotation("Art Gallery", coordinate: ago) {
                Image(systemName: "person.crop.artframe")
                    .foregroundStyle(.white)
                    .padding()
                    .background(.red)
            }

            Marker("Museum", coordinate: rom)
                .tint(.orange)
        }
        .safeAreaInset(edge: .top) {
            HStack {

                Button {
                    camera = .region(
                        MKCoordinateRegion(
                            center: tower,
                            latitudinalMeters: 200,
                            longitudinalMeters: 200))
                } label: {
                    BlurredIcon(logo: "location.circle")
                }


                Spacer()
                Button {
                    // Center on ROM
                    camera = .region(
                        MKCoordinateRegion(
                            center: rom,
                            latitudinalMeters: 2000,
                            longitudinalMeters: 2000))
                } label: {
                    BlurredIcon(logo: "magnifyingglass.circle")
                }

            }
            .padding([.leading,.trailing,.bottom])
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
            
            
        }
    }
}

#Preview {
    ContentView()
}

