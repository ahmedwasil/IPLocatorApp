//
//  IPViewModel.swift
//  IPLocatorApp
//
//  Created by Wasil Ahmed on 24/03/2025.
//

import Foundation
import Combine
import MapKit

///ViewModel responsible for fetching IP location and managing UI state.
class IPViewModel: ObservableObject {
    @Published var ipAddress: String = ""
    @Published var location: CLLocationCoordinate2D? = nil
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    
    //Combine pipeline and trigger
    private var cancellables = Set<AnyCancellable>()
    private let fetchSubject = PassthroughSubject<String?, Never>()
    private let ipService: IPServiceProtocol
    
    //Inject IP service
    init(ipService: IPServiceProtocol = NetworkService.shared) {
        self.ipService = ipService
        setupBindings()
    }
    
    //Setup Combine pipeline to fetch IP location whenever triggered
    private func setupBindings() {
        fetchSubject
            //Set loading to true before making API call
            .handleEvents(receiveOutput: {
                [weak self] _ in
                self?.isLoading = true
            })
            //Fetch location from service
            .flatMap { ip in
                self.ipService.fetchIPDetails(for: ip)
                    .catch { _ in Just(IPLocation(ip: "", latitude: nil, longitude: nil)) }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] ipData in
                self?.isLoading = false
                
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
        guard isValidIP(ip) else {
            errorMessage = "Please enter a valid IP address"
            return
        }
        fetchSubject.send(ip)
    }
    
    private func isValidIP(_ ip: String) -> Bool {
        let pattern = #"^(25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})(\.(25[0-5]|2[0-4][0-9]|1?[0-9]{1,2})){3}$"#
        return ip.range(of: pattern, options: .regularExpression) != nil
    }
}
