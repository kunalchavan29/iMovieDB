//
//  PlayerView.swift
//  iMovieTest
//
//  Created by A118830248 on 16/10/22.
//

import SwiftUI
import AVKit

struct PlayerContentView: View {
    let toPresent = UIHostingController(rootView: AnyView(EmptyView()))
    @State var vURL = URL(string: "https://bit.ly/swswift")
    
    var body: some View {
        AVPlayerView(videoURL: self.$vURL).transition(.move(edge: .bottom)).edgesIgnoringSafeArea(.all)
    }
}

struct PlayerContentView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerContentView()
    }
}

struct AVPlayerView: UIViewControllerRepresentable {

    @Binding var videoURL: URL?

    private var player: AVPlayer {
        return AVPlayer(url: videoURL!)
    }

    func updateUIViewController(_ playerController: AVPlayerViewController, context: Context) {
        playerController.modalPresentationStyle = .fullScreen
        playerController.player = player
        playerController.player?.play()
    }

    func makeUIViewController(context: Context) -> AVPlayerViewController {
        return AVPlayerViewController()
    }
}
