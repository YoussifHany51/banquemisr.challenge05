//
//  NowPlayingViewModel.swift
//  banquemisr.challenge05
//
//  Created by Youssif Hany on 26/09/2024.
//

import Foundation

class MoviesViewModel{
    var movies :[Movie] = []
    
    func fetchData(movieType : NetworkManager.MovieType,completion : @escaping () -> ()){
        if !InternetConnectionManager.shared.isNetworkAvailable(){
            
            fetchMoviesFromCoreData()
            completion()
            print("fetch Movies From CoreData.")
        }else{
            NetworkManager.shared.fetchData(movieType: movieType) {[weak self] result in
                switch result {
                case .success(let success):
                    self?.movies = success
                    CoreDataManager.shared.saveMovies(movies: success)
                    completion()
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
    
    private func fetchMoviesFromCoreData() {
        let cachedMovies = CoreDataManager.shared.fetchCachedMovies()
        if cachedMovies.isEmpty {
            print("No cached movies available.")
        } else {
            self.movies = cachedMovies
            print("Fetched \(cachedMovies.count) movies from Core Data.")
        }
    }
    
    func loadImageData(from url: URL, completion: @escaping (Data?) -> Void) {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        completion(data)
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
    func setUpNavigationTitle(movieTypeRawValue:String) -> String{
        switch movieTypeRawValue {
        case "now_playing":
            return "Now Playing"
        case "popular":
            return "Popular"
        default:
            return "Upcoming"
        }
    }
}
