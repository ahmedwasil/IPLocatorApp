//
//  IPLocatorAppTests.swift
//  IPLocatorAppTests
//
//  Created by Wasil Ahmed on 24/03/2025.
//

import XCTest
import Combine
@testable import IPLocatorApp

class IPViewModelTests: XCTestCase {
    var viewModel: IPViewModel!
    var cancellables = Set<AnyCancellable>()

    func testInvalidIP() {
        // Simulate an invalid location response (no lat/lon)
        let mockResult = IPLocation(ip: "invalid_ip", latitude: nil, longitude: nil)
        let mockService = MockIPService(mockResult: mockResult)
        viewModel = IPViewModel(ipService: mockService)

        let expectation = XCTestExpectation(description: "Invalid IP should return error")

        viewModel.fetchLocation(for: "invalid_ip")

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.errorMessage, "Location not found")
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 2)
    }
    
    func testFetchCurrentIP() {
        //Simulate valid location response
        let mockResult = IPLocation(ip: "1.2.3.4", latitude: 51.5, longitude: -0.13)
        let mockService = MockIPService(mockResult: mockResult)
        viewModel = IPViewModel(ipService: mockService)
        
        let expectation = XCTestExpectation(description: "Valid IP should update location")
        
        viewModel.fetchCurrentIP()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertEqual(self.viewModel.ipAddress, "1.2.3.4")
            XCTAssertNotNil(self.viewModel.location)
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2)
    }
}

