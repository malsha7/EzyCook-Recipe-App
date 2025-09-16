//
//  AVManager.swift
//  EzyCook Recipe App
//
//  Created by Malsha Bopage on 2025-09-16.
//

import Foundation
import SwiftUI
import AVKit
import AVFoundation
import Combine

class AVManager: ObservableObject {
    
    @Published var player: AVPlayer?
    private var playerObserver: AnyCancellable?
    
    //setup video url to play with avplayer
    func setupPlayer(with url: URL, onFinish: @escaping () -> Void) {
        
        
        let item = AVPlayerItem(url: url)
        
        
        item.preferredForwardBufferDuration = 40
        
       
        player = AVPlayer(playerItem: item)
        
        
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemDidPlayToEndTime,
            object: item,
            queue: .main
        ) { _ in
            onFinish()
        }
        
       
        NotificationCenter.default.addObserver(
            forName: .AVPlayerItemPlaybackStalled,
            object: item,
            queue: .main
        ) { _ in
            print("Playback stalled, attempting to resume...")
            self.player?.play()
        }
        
       
        playerObserver = player?.publisher(for: \.timeControlStatus)
            .sink { status in
                switch status {
                case .waitingToPlayAtSpecifiedRate:
                    print("Playback stalled... buffering?")
                case .playing:
                    print("Video is playing")
                case .paused:
                    print("Video paused")
                @unknown default:
                    break
                }
            }
    }
    
  
    func play() {
        player?.play()
    }
    
   
    func pause() {
        player?.pause()
    }
    
   
    deinit {
        NotificationCenter.default.removeObserver(self)
        playerObserver?.cancel()
    }
    
    
    
}
