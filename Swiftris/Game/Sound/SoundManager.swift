//
//  SoundManager.swift
//  Swiftris
//
//  Created by Sungbae Kim on 2015. 7. 3..
//  Copyright (c) 2015년 1minute2life. All rights reserved.
//

import UIKit
import AVFoundation

class SoundManager: NSObject {
   
    var bgmPlayer:AVAudioPlayer?
    var effectPlayer:AVAudioPlayer?
    var gameOverPlayer:AVAudioPlayer?
    
    override init() {
        super.init()
        self.bgmPlayer = self.makePlayer("tetris_original", ofType: "mp3")!
        self.bgmPlayer?.numberOfLoops = Int.max
        self.bgmPlayer?.volume = 0.1
        
        self.effectPlayer = self.makePlayer("fall", ofType: "mp3")!
        self.effectPlayer?.volume = 1
 
        self.gameOverPlayer = self.makePlayer("gameover", ofType: "mp3")!
        self.gameOverPlayer?.volume = 1
        
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategorySoloAmbient)
        } catch _ {
        }
        
    }
    
    func makePlayer(name:String, ofType:String) -> AVAudioPlayer? {
        if let path = NSBundle.mainBundle().pathForResource(name, ofType: ofType) {
            let url = NSURL(fileURLWithPath: path)
            do {
                return try AVAudioPlayer(contentsOfURL: url)
            } catch _ {
                return nil
            }
        }
        return nil
    }
    
    
    func playBGM() {
        guard let player = self.bgmPlayer else { return }
        player.play()
    }
    func pauseBGM() {
        guard let player = self.bgmPlayer else { return }
        player.pause()
    }
    func stopBGM() {
        guard let player = self.bgmPlayer else { return }
        player.stop()
        player.currentTime = 0
    }
    
    func dropBrick() {
        guard let player = self.effectPlayer else { return }
        player.prepareToPlay()
        player.play()
    }
    
    func gameOver() {
        guard let player = self.gameOverPlayer else { return }
        player.prepareToPlay()
        player.play()
    }
    
}
