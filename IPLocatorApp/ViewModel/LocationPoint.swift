//
//  LocationPoint.swift
//  IPLocatorApp
//
//  Created by Wasil Ahmed on 24/03/2025.
//
import Foundation
import MapKit

struct LocationPoint: Identifiable {
    let id = UUID()  // Required for Identifiable
    let coordinate: CLLocationCoordinate2D
}
