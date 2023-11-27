//
//  MapView.swift
//  MetUCD-part1
//
//  Created by Miaomiao Shi on 26/11/2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    
    @EnvironmentObject var locationManager: LocationManager
    

    //  update the MapView's camera state whenever the LocationManager updates the currentLocation.
    @State var camera: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 53.309938529972854,
                longitude: -6.2215091104457905),
            span: MKCoordinateSpan(
                latitudeDelta: 0.006,
                longitudeDelta: 0.006)))


    var body: some View {
//        var cL = locationManager.currentLocation
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
        .safeAreaInset(edge: .top) {
            HStack {
                Button {
                    locationManager.requestLocation()
                    // Call LoactionManger -> get user currentLocation,
                    // camera = .region(MKCoordinateRegion(center: currentLocation,latitudinalMeters: 0.006,longitudinalMeters: 0.006))
                    
                } label: {
                    BlurredIcon(logo: "location.circle")
                }
                Spacer()
                Button {
                    // onclick -> Button disapper -> show textfield
                    // input City,State,Country
                    // call Geo location API (verify, if input valid?) -> get lon,lat
                    // parse into currentLocation variable
                    
                    
                } label: {
                    BlurredIcon(logo: "magnifyingglass.circle")
                }

            }
            .padding([.leading,.trailing,.bottom])     
        }
    }
}

#Preview {
    MapView()
}
