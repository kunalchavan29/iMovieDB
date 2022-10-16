//
//  MoviesView.swift
//  iMovieTest
//
//  Created by A118830248 on 15/10/22.
//

import SwiftUI
import Combine

struct MoviesView: View {
    @StateObject var viewModel: MovieListViewModel    
    
    var body: some View {
        List {
            
            ForEach(viewModel.items) { item in

                NavigationLink(destination: MovieDetailsView(viewModel: MovieDetailsViewModel(movie: item, commentStorage: DatabaseManager.shared))) {
                    MoviesCellView(movie: item)
                }
                .padding()
                .onAppear {
                    viewModel.loadMoreContentIfNeeded(currentItem: item)
                }
            }

            if viewModel.isLoadingPage {
                HStack {
                    Spacer()
                    ProgressView()
                    Spacer()
                }
            }
        }
        .listStyle(.plain)
        
        .navigationBarTitle(viewModel.type == .popular ? "Popular" : "Top Rated")
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Alert"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("Ok"), action: {
            }))
        }
        .onAppear {
        }
    }
}

struct MoviesView_Previews: PreviewProvider {
    static var previews: some View {
        MoviesView(viewModel: MovieListViewModel(type: MovieType.topRated))
    }
}
