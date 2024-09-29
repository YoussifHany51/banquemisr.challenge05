//
//  NetworkManagerTests.swift
//  banquemisr.challenge05Tests
//
//  Created by Youssif Hany on 29/09/2024.
//

import Foundation
import XCTest
@testable import banquemisr_challenge05

class NetworkManagerTests: XCTestCase {
    
    var session: URLSession!
    
    override func setUp() {
        super.setUp()
        
        let config = URLSessionConfiguration.ephemeral
                config.protocolClasses = [MockURLProtocol.self]
                session = URLSession(configuration: config)
    }
    
    override func tearDown() {
        MockURLProtocol.requestHandler = nil
        session = nil
        super.tearDown()
    }
    
    func testFetchDataSuccess() {
        let jsonData = """
           {
               "results": [
                   {
            "id": 1,
            "title": "The Crow",
            "overview": "Movie Overview",
            "release_date": "2024-09-29",
            "poster_path":  "/58QT4cPJ2u2TqWZkterDq9q4yxQ.jpg",
            "genre_ids": [
            16,
            10751,
            35,
            28
            ],
            "original_language": "en",
            "vote_average": 5.403,
            "original_title": "The Crow",
            "adult": false,
            "vote_count": 423,
                   }
               ]
           }
           """.data(using: .utf8)!
        
        // Set the mock response handler
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, jsonData)
        }
        
        let expectation = self.expectation(description: "Success Response")
        
        // Inject the custom session in NetworkManager
        let networkManager = NetworkManager(session: session)
        networkManager.fetchData(movieType: .nowPlaying) { result in
            switch result {
            case .success(let movies):
                XCTAssertEqual(movies.first?.title, "The Crow")
                expectation.fulfill()
            case .failure:
                XCTFail("Expected success but got failure")
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchDataNetworkError() {
        let networkError = NSError(domain: "network", code: 500, userInfo: nil)
        
        MockURLProtocol.requestHandler = { request in
            throw networkError
        }
        
        let expectation = self.expectation(description: "Network Error Response")
        
        let networkManager = NetworkManager(session: session)
        networkManager.fetchData(movieType: .popular) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error.localizedDescription, networkError.localizedDescription)
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchDataDecodingError() {
        let invalidJsonData = """
           {
               "invalid_key": "invalid_value"
           }
           """.data(using: .utf8)!
        
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: nil)!
            return (response, invalidJsonData)
        }
        
        let expectation = self.expectation(description: "Decoding Error Response")
        
        let networkManager = NetworkManager(session: session)
        networkManager.fetchData(movieType: .upcoming) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure:
                expectation.fulfill() // Decoding error should occur
            }
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
}

