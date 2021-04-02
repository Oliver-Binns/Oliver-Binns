//
//  YouTubePlayer.swift
//  Oliver Binns
//
//  Created by Laptop 3 on 02/04/2021.
//
import SwiftUI
import UIKit
import YouTubeiOSPlayerHelper

struct YouTubePlayer: UIViewRepresentable {
    let videoID: String

    func makeUIView(context: Context) -> YTPlayerView {
        let view = YTPlayerView()
        view.load(withVideoId: videoID)
        return view
    }

    func updateUIView(_ uiView: YTPlayerView, context: Context) { }
}
