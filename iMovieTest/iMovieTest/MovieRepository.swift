//
//  MovieService.swift
//  iMovieTest
//
//  Created by A118830248 on 14/10/22.
//

import Foundation

protocol MovieRepositoryProtocol {
    func getAndSaveMovies(page: Int, type: MovieType, completion: @escaping (Result<PaginationResponse<Movie>, Error>) -> Void)
}

class MovieRepository: MovieRepositoryProtocol {
    var service: MovieServiceProtocol
    var storage: StorageProtocol
    
    init(service: MovieServiceProtocol, storage: StorageProtocol) {
        self.service = service
        self.storage = storage
    }
    
    func getAndSaveMovies(page: Int, type: MovieType, completion: @escaping (Result<PaginationResponse<Movie>, Error>) -> Void) {
        if !Reachability.isConnectedToNetwork() {
            let localMovies = storage.getMovies(type: type.rawValue)
            let response = PaginationResponse<Movie>(page: 1, results: localMovies, totalResults: localMovies.count, totalPages: 1)
            completion(.success(response))
        } else {
            service.getMovies(page: page, type: type) { response in
                switch response {
                case .success(let response):
                    //save results locally
                    do {
                        try self.storage.saveOrUpdate(objects: response.results ?? [], type: type.rawValue)
                        //TODO: Remove commented
                        //let entities = DatabaseManager.shared.getMovieEntities()
                    } catch {
                        completion(.failure(error))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
                completion(response)
            }
        }
    }
}
