//
//  MockManager.swift
//  banquemisr.challenge05Tests
//
//  Created by Youssif Hany on 29/09/2024.
//

import Foundation
@testable import banquemisr_challenge05

class MockNetworkManager: NetworkManager {
    var mockMovies: [Movie]
    
    init(mockMovies: [Movie]) {
        self.mockMovies = mockMovies
        super.init() // Call to the parent initializer if needed
    }
    
    override func fetchData(movieType: MovieType, completion: @escaping (Result<[Movie], Error>) -> Void) {
        completion(.success(mockMovies))
    }
}

class MockCoreDataManager {
    var mockMovies: [Movie] = []
    
    func fetchCachedMovies() -> [Movie] {
        return mockMovies
    }
}

class MockInternetConnectionManager {
    var isAvailable: Bool = true
    
    func isNetworkAvailable() -> Bool {
        return isAvailable
    }

}
