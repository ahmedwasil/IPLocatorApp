//
//  IPViewModel.swift
//  IPLocatorApp
//
//  Created by Wasil Ahmed on 24/03/2025.
//

import Foundation
import Combine
import MapKit

class IPViewModel: ObservableObject {
    @Published var ipAddress: String = ""
    @Published var location: CLLocationCoordinate2D? = nil
    @Published var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    private let fetchSubject = PassthroughSubject<String?, Never>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        fetchSubject
            .flatMap { ip in
                NetworkService.shared.fetchIPDetails(for: ip)
                    .catch { _ in Just(IPLocation(ip: "", latitude: nil, longitude: nil)) }
                    .eraseToAnyPublisher()
            }
            .sink { [weak self] ipData in
                if let lat = ipData.latitude, let lon = ipData.longitude {
                    self?.location = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    self?.ipAddress = ipData.ip
                    self?.errorMessage = nil
                } else {
                    self?.errorMessage = "Location not found"
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchCurrentIP() {
        fetchSubject.send(nil)
    }

    func fetchLocation(for ip: String) {
        fetchSubject.send(ip)
    }
}
