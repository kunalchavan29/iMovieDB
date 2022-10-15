//
//  MovieDetailsView.swift
//  iMovieTest
//
//  Created by A118830248 on 15/10/22.
//

import SwiftUI

struct MovieDetailsView: View {
    let movie: Movie
    let imageLoader = ImageLoader()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                MovieDetailImage(imageLoader: imageLoader, imageURL: self.movie.backdropURL)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                
                Text(movie.title ?? "")
                    .font(.title)
                
                Spacer().frame(height: 10)
                
                Text(movie.overview ?? "")
                
            }
            .padding()
        }
        .navigationBarTitle(movie.title ?? "")
    }
}

struct MovieDetailImage: View {
    
    @ObservedObject var imageLoader: ImageLoader
    let imageURL: URL
    
    var body: some View {
        ZStack {
            Rectangle().fill(Color.gray.opacity(0.3))
            if self.imageLoader.image != nil {
                Image(uiImage: self.imageLoader.image!)
                    .resizable()
            }
        }
        .aspectRatio(16/9, contentMode: .fit)
        .onAppear {
            self.imageLoader.loadImage(with: self.imageURL)
        }
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        MovieDetailsView(movie: Movie.stubbedMovie)
    }
}
