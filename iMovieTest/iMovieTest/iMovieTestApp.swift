//
//  iMovieTestApp.swift
//  iMovieTest
//
//  Created by A118830248 on 15/10/22.
//

import SwiftUI

@main
struct iMovieTestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            DashboardTabBarView()
                .animation(.default, value: 1.0)
//            ContentView()
//                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
