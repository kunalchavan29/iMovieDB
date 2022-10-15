//
//  MovieService.swift
//  iMovieTest
//
//  Created by A118830248 on 14/10/22.
//

import Foundation
protocol MovieServiceProtocol {
    func getMovies(page: Int, type: MovieType, completion: @escaping (Result<PaginationResponse<Movie>, Error>) -> Void)
}

class MovieService: MovieServiceProtocol {
    func getMovies(page: Int, type: MovieType, completion: @escaping (Result<PaginationResponse<Movie>, Error>) -> Void) {
        let typeString = type == .popular ? "popular" : "top_rated"
        let urlString = "https://api.themoviedb.org/3/movie/\(typeString)?api_key=\(NetworkConstants.apiKey)&language=en-US&page=\(page)"
        guard let url = URL(string: urlString) else { return }
        let session = URLSession.shared
        let urlReq = URLRequest(url: url)
        let task = session.dataTask(with: urlReq) { data, response, error in
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                let error = error ?? URLError(.badServerResponse)
                print("error on download \(error)")
                completion(.failure(error))
                return
            }
            guard 200 ..< 300 ~= response.statusCode else {
                print("statusCode != 2xx; \(response.statusCode)")
                completion(.failure(CustomError.invalidStatus))
                return
            }
            print(String(data: data, encoding: .utf8) ?? "")
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let decoded = try decoder.decode(PaginationResponse<Movie>.self, from: data)
                completion(.success(decoded))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}

public enum CustomError: Error {
    case noData
    case invalidStatus
}
