//
//  Network.swift
//  IPLocatorApp
//
//  Created by Wasil Ahmed on 24/03/2025.
//

import Foundation
import Combine

class NetworkService {
    static let shared = NetworkService()
    
    private init() {}
    
    private let baseURL = "https://ipapi.co"
    
    func fetchIPDetails(for ip: String?) -> AnyPublisher<IPLocation, Error> {
        let endpoint = ip.map { "\(baseURL)/\($0)/json/" } ?? "\(baseURL)/json/"
        
        guard let url = URL(string: endpoint) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: IPLocation.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
