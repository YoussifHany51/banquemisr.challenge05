//
//  CoreDataManager.swift
//  banquemisr.challenge05
//
//  Created by Youssif Hany on 29/09/2024.
//

import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "MovieModel")
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        return container
    }()

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context: \(error)")
            }
        }
    }

    // Core Data Operations
    func saveMovies(movies: [Movie]) {
//        clearMovies() // Clear old data

        for movie in movies {
            let movieEntity = MovieModel(context: context)
            movieEntity.id = Int64(movie.id)
            movieEntity.title = movie.title
            movieEntity.release_date = movie.release_date
            movieEntity.poster_path = movie.poster_path
            movieEntity.adult = movie.adult
            movieEntity.overview = movie.overview
            movieEntity.original_title = movie.original_title
            movieEntity.original_language = movie.original_language
            movieEntity.vote_average = movie.vote_average
            if let posterURL = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path)") {
                URLSession.shared.dataTask(with: posterURL) { [weak self] data, response, error in
                    if let error = error {
                        print("Error loading image for movie: \(movie.title), error: \(error)")
                    } else if let data = data {
                        DispatchQueue.main.async {
                            movieEntity.posterImage = data // Save image data
                            self?.saveContext() // Save Core Data after downloading image
                        }
                    }
                }.resume()
            }
        }
    }

    func fetchCachedMovies() -> [Movie] {
        let fetchRequest: NSFetchRequest<MovieModel> = MovieModel.fetchRequest()
        do {
            let movieEntities = try context.fetch(fetchRequest)
            return movieEntities.map {
                Movie(id: Int($0.id), title: $0.title!, overview: $0.overview!, release_date: $0.release_date!, poster_path: $0.poster_path!, genre_ids: [], original_language: $0.original_language!, vote_average: $0.vote_average, original_title: $0.original_title!, adult: $0.adult, vote_count: Int($0.vote_count))
            }
        } catch {
            print("Failed to fetch cached movies: \(error)")
            return []
        }
    }
    
    func fetchCachedMovie(by movieID: Int) -> MovieModel? {
        let fetchRequest: NSFetchRequest<MovieModel> = MovieModel.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", movieID)
        
        do {
            let results = try context.fetch(fetchRequest)
            return results.first // Return the first movie found
        } catch {
            print("Failed to fetch movie: \(error)")
            return nil
        }
    }

    func clearMovies() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = MovieModel.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Failed to delete old movies: \(error)")
        }
    }
    
}
