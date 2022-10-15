//
//  MovieListViewModel.swift
//  iMovieTest
//
//  Created by A118830248 on 15/10/22.
//

import Foundation
import Combine

class MovieListViewModel: ObservableObject {
    @Published var items = [Movie]()
    @Published var isLoadingPage = false
    private var currentPage = 1
    private var canLoadMorePages = true
    var type: MovieType = .popular
    
    init(type: MovieType) {
        self.type = type
        loadMoreContent(completion: {})
    }
    
    func loadMoreContentIfNeeded(currentItem item: Movie?) {
        guard let item = item else {
            loadMoreContent(completion: {})
            return
        }
        
        let thresholdIndex = items.index(items.endIndex, offsetBy: -5)
        if items.firstIndex(where: { $0.id == item.id }) == thresholdIndex {
            loadMoreContent(completion: {})
        }
    }
    
    func loadMoreContent(completion: () -> Void) {
        guard !isLoadingPage && canLoadMorePages else {
            return
        }
        
        isLoadingPage = true
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        let typeString = type == .popular ? "popular" : "top_rated"
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(typeString)?api_key=\(NetworkConstants.apiKey)&language=en-US&page=\(currentPage)")!
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PaginationResponse<Movie>.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { response in
                print(response)
                self.canLoadMorePages = response.totalPages ?? 0 >= self.currentPage
                self.isLoadingPage = false
                self.currentPage += 1
            })
            .map({ response in
                return self.items + (response.results ?? [])
            })
            .catch({ _ in Just(self.items) })
                    .assign(to: &$items)
    }
    
}
