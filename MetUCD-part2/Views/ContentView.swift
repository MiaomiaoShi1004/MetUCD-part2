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

    let ucd = CLLocationCoordinate2D(
        latitude: 53.309938529972854,
        longitude: -6.2215091104457905
    )

    let rom = CLLocationCoordinate2D(
        latitude: 43.66785712547134,
        longitude: -79.39465908518817
    )
    
    @State var camera: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 53.309938529972854,
                longitude: -6.2215091104457905),
            span: MKCoordinateSpan(
                latitudeDelta: 0.0045,
                longitudeDelta: 0.0045)))


    var body: some View {
        Map(position: $camera) {
//        Map {
//            Marker("CN Tower", systemImage: "building", coordinate: tower)
//                .tint(.blue)
            
            // How to customize the icon in the map
            Annotation("ucd",coordinate: ucd) {
                ZStack {
                    Image(systemName: "location.viewfinder")
                        .foregroundStyle(.black)
                }
                .frame(width: 80, height: 80)

            }
            .annotationTitles(.hidden)
//            Annotation(coordinate: ucd, content: <#T##() -> View#>, label: <#T##() -> View#>)

//            Marker("location.viewfinder", coordinate: rom)
//                .tint(.orange)
        }
        .mapControls(){
            MapUserLocationButton()
        }
        .safeAreaInset(edge: .top) {
            HStack {

                Button {
//                    camera = .region(
//                        MKCoordinateRegion(
//                            center: ucd,
//                            latitudinalMeters: 200,
//                            longitudinalMeters: 200))
                } label: {
                    BlurredIcon(logo: "location.circle")
                }


                Spacer()
                Button {
//                    // Center on ROM
//                    camera = .region(
//                        MKCoordinateRegion(
//                            center: rom,
//                            latitudinalMeters: 2000,
//                            longitudinalMeters: 2000))
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

