//
//  Extensions.swift
//  iMovieTest
//
//  Created by A118830248 on 16/10/22.
//

import SwiftUI


extension View {
    @ViewBuilder
    func modify<Content: View>(@ViewBuilder _ transform: (Self) -> Content?) -> some View {
        if let view = transform(self), !(view is EmptyView) {
            view
        } else {
            self
        }
    }
}
