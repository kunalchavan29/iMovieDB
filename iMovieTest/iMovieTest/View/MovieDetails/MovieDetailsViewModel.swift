//
//  MovieDetailsViewModel.swift
//  iMovieTest
//
//  Created by A118830248 on 16/10/22.
//

import Combine

class MovieDetailsViewModel: ObservableObject {    
    @Published var movie = Movie.stubbedMovie
    @Published var comment = ""
    let imageLoader = ImageLoader()
    var commentStorage: CommentStorageProtocol
    
    init(movie: Movie, commentStorage: CommentStorageProtocol) {
        self.movie = movie
        self.commentStorage = commentStorage
        fetchCommentForMovie(id: movie.id ?? 0)
    }
    
    func fetchCommentForMovie(id: Int) {
        do {
            comment = try commentStorage.fetchCommentForMovie(id: id) ?? ""
        } catch {
            print(error)
        }
    }
    
    func saveComment() {
        do {
            try commentStorage.saveCommentForMovieId(id: movie.id ?? 0, comment: comment)
        } catch {
            print(error)
        }
    }
}
