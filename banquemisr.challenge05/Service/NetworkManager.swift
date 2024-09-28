//
//  NetworkManager.swift
//  banquemisr.challenge05
//
//  Created by Youssif Hany on 26/09/2024.
//

import Foundation

struct NetworkManager{
    
    static let shared = NetworkManager()
    private let apiUrl = "https://api.themoviedb.org/3/movie"
    private let apiKey = "a8f38baa9f38daae2d931d8437984279"
    
    enum MovieType : String {
        case nowPlaying = "now_playing"
        case popular = "popular"
        case upcoming = "upcoming"
    }
    
    func fetchData(movieType:MovieType,completion: @escaping (Result<[Movie],Error>)->()){
        let urlString = "\(apiUrl)/\(movieType.rawValue)?api_key=\(apiKey)"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                print("No data received")
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,httpResponse.statusCode == 200 else {
                print("Invalid response")
                return
            }
            do{
                let movieResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                completion(.success(movieResponse.results))
            }catch let error{
                print("Decoding Error: \(error)")
                completion(.failure(error))
            }
        }
        .resume()
    }
}
