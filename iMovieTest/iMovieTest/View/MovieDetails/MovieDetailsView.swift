//
//  MovieDetailsView.swift
//  iMovieTest
//
//  Created by A118830248 on 15/10/22.
//

import SwiftUI

struct MovieDetailsView: View {
    @StateObject var viewModel: MovieDetailsViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                
                MovieDetailImage(imageLoader: viewModel.imageLoader, imageURL: viewModel.movie.backdropURL)
                    .cornerRadius(8)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                
                Text(viewModel.movie.title ?? "")
                    .font(.title)
                
                Spacer().frame(height: 10)
                
                Text(viewModel.movie.overview ?? "")
                
                CommentView(comment: $viewModel.comment, onSave: {
                    viewModel.saveComment()
                })
            }
            .padding()
        }
        .navigationBarTitle(viewModel.movie.title ?? "")
    }
}

struct CommentView: View {
    @Binding var comment: String
    var onSave: (() -> Void)?
    var isEmpty: Bool {
        return comment.isEmpty
    }
    
    var body: some View {
        VStack(spacing: 16) {
            ZStack {
                TextEditor(text: $comment)
                Text(comment).opacity(0).padding(8)
                    .frame(minHeight: 40)
                    .lineLimit(8)
            }
            .cornerRadius(8)
            .shadow(radius: 1)
            
            Button {
                onSave?()
            } label: {
                Text("Save")
                    .frame(height: 40)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.orange)
                    .cornerRadius(8)
            }
            .disabled(isEmpty)
        }
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
        MovieDetailsView(viewModel: MovieDetailsViewModel(movie: Movie.stubbedMovie, commentStorage: DatabaseManager.shared))
    }
}
