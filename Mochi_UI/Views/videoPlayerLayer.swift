//
//  VideoPlayerLayer.swift
//  Mochi_UI
//
//  Created by Sam Weekes on 5/19/20.
//  Copyright © 2020 Sam Weekes. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class VideoPlayerLayer : AVPlayerLayer {
    var videoPlayer : AVPlayer?
    var isPlaying : Bool = false
    func Pause() {
        self.isPlaying = false
        self.videoPlayer?.pause()
    }
    
    func togglePlay() {
        self.isPlaying ? self.Pause() : self.Play()
    }
    
    func Play() {
        self.isPlaying = true
        self.videoPlayer?.play()
    }
    
    func PlayFromBeginning() {
        self.isPlaying = true
        self.videoPlayer?.seek(to: .zero)
        self.videoPlayer?.play()
    }
    
    init(videoURL : URL, size : CGSize) {
        super.init()
        
        self.videoPlayer = AVPlayer(url: videoURL)
        self.videoPlayer?.actionAtItemEnd = .none
        
        self.player = self.videoPlayer
        self.frame = CGRect(origin: .zero, size: size)
        self.videoGravity = .resizeAspectFill
        
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object:
            self.videoPlayer?.currentItem, queue: .main) { _ in
                self.PlayFromBeginning()
        }
        
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { (_) in
            self.Play()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
