//
//  Movie.swift
//  iMovieTest
//
//  Created by A118830248 on 15/10/22.
//

import Foundation

// MARK: - Welcome
struct PaginationResponse<T: Codable>: Codable {
    var page: Int?
    var results: [T]?
    var totalResults, totalPages: Int?

}

// MARK: - Result
struct Movie {
    var posterPath: String?
    var adult: Bool?
    var overview, releaseDate: String?
    var genreIds: [Int]?
    var id: Int?
    var originalTitle: String?
    var originalLanguage: String?
    var title, backdropPath: String?
    var popularity: Double?
    var voteCount: Int?
    var video: Bool?
    var voteAverage: Double?
    var comment: String?
}

extension Movie {
    var backdropURL: URL {
        return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")!
    }
    
    var displayDate: String {
        guard let releaseDate = self.releaseDate, let date = Utils.dateFormatter.date(from: releaseDate) else {
            return "n/a"
        }
        return Utils.displayDateFormatter.string(from: date)
    }
    
}

extension Movie: Codable {
}
extension Movie: Identifiable {
}

extension Movie: Comparable {
    static func < (lhs: Movie, rhs: Movie) -> Bool {
        return (lhs.id ?? 0) < (rhs.id ?? 0)
    }
}

extension Movie {
    func mapToMO(movieEntity: MovieEntity) -> MovieEntity {
        movieEntity.id = Int32(self.id ?? 0)
        movieEntity.backdropPath = self.backdropPath
        movieEntity.overview = self.overview
        movieEntity.posterPath = self.posterPath
        movieEntity.releaseDate = self.releaseDate ?? ""
        movieEntity.title = self.title
        movieEntity.video = self.video ?? false
        
        return movieEntity
    }
    
    mutating func mapFromEntity(movieEntity: MovieEntity) -> Movie {
        self.id = Int(movieEntity.id )
        self.backdropPath = movieEntity.backdropPath
        self.overview = movieEntity.overview
        self.posterPath = movieEntity.posterPath
        self.releaseDate = movieEntity.releaseDate as String?
        self.title = movieEntity.title
        self.video = movieEntity.video
        
        return self
    }
}

extension Movie {
    
    static var stubbedMovies: [Movie] {
        let response: PaginationResponse<Movie>? = try? Bundle.main.loadAndDecodeJSON(filename: "movieList")
        return response?.results ?? []
    }
    
    static var stubbedMovie: Movie {
        stubbedMovies[0]
    }
}

extension Bundle {
    
    func loadAndDecodeJSON<D: Decodable>(filename: String) throws -> D? {
        guard let url = self.url(forResource: filename, withExtension: "json") else {
            return nil
        }
        let data = try Data(contentsOf: url)
        let jsonDecoder = Utils.jsonDecoder
        let decodedModel = try jsonDecoder.decode(D.self, from: data)
        return decodedModel
    }
}
