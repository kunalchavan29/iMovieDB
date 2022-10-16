//
//  MovieListViewModel.swift
//  iMovieTest
//
//  Created by A118830248 on 15/10/22.
//

import Foundation
import Combine
import UIKit

class MovieListViewModel: ObservableObject {
    @Published var items = [Movie]()
    @Published var isLoadingPage = false
    @Published var showAlert = false
    @Published var errorMessage: String = "" {
        didSet {
            showAlert = true
        }
    }
    
    var currentPage = 1
    private var totalPages: Int?
    private var canLoadMorePages = true
    var type: MovieType = .popular
    
    var repository: MovieRepositoryProtocol
    
    init(type: MovieType) {
        self.type = type
        self.repository = MovieRepository(service: MovieService(), storage: DatabaseManager.shared)
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
    
    func onPullToRefresh() {
        currentPage = 1
        totalPages = nil
        canLoadMorePages = true
        loadMoreContent(completion: {})
    }
    
    func loadMoreContent(completion: @escaping () -> Void) {
        guard !isLoadingPage && canLoadMorePages else {
            completion()
            return
        }
        if let totalPages = totalPages, totalPages < currentPage {
            self.errorMessage = "Reached at end of the list"
            completion()
            return
        }
        
        isLoadingPage = true
        
        repository.getAndSaveMovies(page: currentPage, type: type) {[weak self] response in
            DispatchQueue.main.async {
                switch response {
                case .success(let response):
                    let movies = response.results ?? []
                    
                    if self?.currentPage != 1, (response.totalPages ?? 0 > response.page ?? 0) {
                        self?.items += movies
                    } else {
                        self?.items = movies
                    }
                    self?.canLoadMorePages = (response.totalPages ?? 0) > response.page ?? 0
                    self?.isLoadingPage = false
                    self?.currentPage += 1
                    self?.totalPages = response.totalPages
                    
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                }
                completion()
            }
        }
    }
    
}
