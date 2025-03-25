//
//  MockIPService.swift
//  IPLocatorApp
//
//  Created by Wasil Ahmed on 25/03/2025.
//
import Foundation
import Combine
@testable import IPLocatorApp


class MockIPService: IPServiceProtocol {
    var mockResult: IPLocation
    
    init(mockResult: IPLocation) {
        self.mockResult = mockResult
    }
    
    func fetchIPDetails(for ip: String?) -> AnyPublisher<IPLocation, Error> {
        return Just(mockResult)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
