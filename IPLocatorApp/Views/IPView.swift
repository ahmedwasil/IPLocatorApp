//
//  IPView.swift
//  IPLocatorApp
//
//  Created by Wasil Ahmed on 24/03/2025.
//

import SwiftUI
import MapKit

struct IPView:View {
    @StateObject private var viewModel = IPViewModel()
    @State private var cameraPosition: MapCameraPosition = .automatic
    
    var body: some View {
        VStack(spacing: 20) {
            TextField("Enter IP Address", text: $viewModel.ipAddress)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            HStack {
                Button("Get My IP") {
                    viewModel.fetchCurrentIP()
                }
                .buttonStyle(.bordered)
                
                Button("Locate IP") {
                    viewModel.fetchLocation(for: viewModel.ipAddress)
                }
                .buttonStyle(.borderedProminent)
            }
            
            if let location = viewModel.location {
                Map(position: $cameraPosition) {
                    Marker("IP Location", coordinate: location)
                }
                .onReceive(viewModel.$location) { location in
                    // Update camera when location changes
                    cameraPosition = .region(
                        MKCoordinateRegion(center: location!,
                            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                        )
                }
                .frame(height: 300)
                .cornerRadius(10)
                
                
            }
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
    }
}
