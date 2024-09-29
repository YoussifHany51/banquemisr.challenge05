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
        NetworkManager.shared.fetchData(movieType: movieType) {[weak self] result in
            switch result {
            case .success(let success):
                self?.movies = success
                completion()
            case .failure(let failure):
                print(failure.localizedDescription)
            }
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
}
