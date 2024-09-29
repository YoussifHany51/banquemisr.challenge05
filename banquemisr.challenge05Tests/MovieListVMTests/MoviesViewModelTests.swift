//
//  MoviesViewModelTests.swift
//  banquemisr.challenge05Tests
//
//  Created by Youssif Hany on 29/09/2024.
//

import XCTest
@testable import banquemisr_challenge05

class MoviesViewModelTests: XCTestCase {
    
    var viewModel: MoviesViewModel!
    var mockInternetManager: MockInternetConnectionManager!
    var mockCoreDataManager: MockCoreDataManager!
    
    override func setUp() {
        super.setUp()
        viewModel = MoviesViewModel()
        mockInternetManager = MockInternetConnectionManager()
        mockCoreDataManager = MockCoreDataManager()
    }
    
    override func tearDown() {
        viewModel = nil
        mockInternetManager = nil
        mockCoreDataManager = nil
        super.tearDown()
    }
    
    func testFetchDataWithNoInternet() {
        mockInternetManager.isAvailable = false
        
        let expectation = self.expectation(description: "Fetch movies from Core Data")
    
        mockCoreDataManager.mockMovies = [
            Movie(id: 1, title: "Mock Movie", overview: "Overview", release_date: "2024-09-29", poster_path: "/path.jpg", genre_ids: [], original_language: "en", vote_average: 7.0, original_title: "Mock Movie", adult: false, vote_count: 100)
        ]
        
        viewModel.fetchData(movieType: .nowPlaying) {
            XCTAssertEqual(self.viewModel.movies.count, 20)
            XCTAssertEqual(self.viewModel.movies.first?.title, "The Crow")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testFetchDataWithInternetSuccess() {
        mockInternetManager.isAvailable = true
        
        let expectation = self.expectation(description: "Fetch movies from network")
        
        _ = [
            Movie(id: 1, title: "The Crow", overview: "Movie Overview", release_date: "2024-09-29", poster_path: "/path.jpg", genre_ids: [], original_language: "en", vote_average: 5.403, original_title: "The Crow", adult: false, vote_count: 423)
        ]
        
        viewModel.fetchData(movieType: .nowPlaying) {
            XCTAssertEqual(self.viewModel.movies.count, 20)
            XCTAssertEqual(self.viewModel.movies.first?.title, "The Crow")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSetUpNavigationTitle() {
        XCTAssertEqual(viewModel.setUpNavigationTitle(movieTypeRawValue: "now_playing"), "Now Playing")
        XCTAssertEqual(viewModel.setUpNavigationTitle(movieTypeRawValue: "popular"), "Popular")
        XCTAssertEqual(viewModel.setUpNavigationTitle(movieTypeRawValue: "upcoming"), "Upcoming")
        XCTAssertEqual(viewModel.setUpNavigationTitle(movieTypeRawValue: "unknown"), "Upcoming")
    }
}

