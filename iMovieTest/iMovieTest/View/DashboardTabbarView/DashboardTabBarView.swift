//
//  DashboardTabBarView.swift
//  iMovieTest
//
//  Created by A118830248 on 15/10/22.
//

import SwiftUI
enum MovieType: Int {
    case popular
    case topRated
}

struct DashboardTabBarView: View {
    @State private var tabSelection = MovieType.popular.rawValue
    
    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationView {
                
                MoviesView(viewModel: MovieListViewModel(type: .popular))
            }
            .tabItem {
                Label("Popular", systemImage: "hand.thumbsup")
            }
            .tag(MovieType.popular.rawValue)
            
            NavigationView {
                MoviesView(viewModel: MovieListViewModel(type: .topRated))
            }
            .tabItem {
                Label("Top Rated", systemImage: "star")
            }
            .tag(MovieType.topRated.rawValue)
        }
        .onAppear {
            if #available(iOS 15.0, *) {
                let appearance = UITabBarAppearance()
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}

struct DashboardTabBarView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardTabBarView()
    }
}
