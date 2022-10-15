//
//  MoviesView.swift
//  iMovieTest
//
//  Created by A118830248 on 15/10/22.
//

import SwiftUI
import Combine
import Refreshable

struct MoviesView: View {
    @StateObject var viewModel: MovieListViewModel
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.items) { item in

                        NavigationLink(destination: MovieDetailsView(movie: item)) {
                            MoviesCellView(movie: item)
                        }
                        .padding()
                        .onAppear {
                            viewModel.loadMoreContentIfNeeded(currentItem: item)
                        }
                }

                if viewModel.isLoadingPage {
                    ProgressView()
                }
            }
        }
        .navigationBarTitle(viewModel.type == .popular ? "Popular" : "Top Rated")
        .onAppear {
//            viewModel.getMovies(page: 1)
        }
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView(viewModel: MovieListViewModel(type: MovieType.topRated))
    }
}
