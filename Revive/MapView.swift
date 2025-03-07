//
//  MapView.swift
//  Revive
//
//  Created by Melanie Laveriano on 3/7/25.
//


import Foundation
import SwiftUI
import MapKit

struct MapLocation: Identifiable {
    let id = UUID()
    let name: String
    let coordinate: CLLocationCoordinate2D
}


struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 40.7542719, longitude: -74.2520170),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    let locations = [
        MapLocation(name: "STEM Innovation Academy of the Oranges", coordinate: CLLocationCoordinate2D(latitude: 40.7542719, longitude: -74.2520170)),
        MapLocation(name: "Orange High School", coordinate: CLLocationCoordinate2D(latitude: 40.7657458, longitude: -74.2398618)),
        MapLocation(name: "Movie Theater", coordinate: CLLocationCoordinate2D(latitude: 40.7458412, longitude: -74.2612025))
    ]
    
    var body: some View {
        NavigationStack {
            
            Map(coordinateRegion: $region, annotationItems: locations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    VStack {
                        Image(systemName: "mappin.circle.fill")
                            .font(.title3)
                            .foregroundColor(.red)
                        
                        Text(location.name)
                            .font(.caption)
                            .padding(5)
                            .background(Color(.systemBackground))
                            .cornerRadius(5)
                    }
                }
            }
            
            .navigationTitle("Map")
            .ignoresSafeArea()
            .aspectRatio(contentMode: .fit)
            .frame(width: 600)
        }
    }
}
