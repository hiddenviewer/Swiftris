//
//  Swiftris.swift
//  Swiftris
//
//  Created by Sungbae Kim on 2015. 7. 3..
//  Copyright (c) 2015년 1minute2life. All rights reserved.
//

import UIKit


enum GameState:Int {
    case STOP = 0
    case PLAY
    case PAUSE
}

class Swiftris: NSObject {
    // Notification
    static var LineClearNotification                   = "LineClearNotification"
    static var NewBrickDidGenerateNotification         = "NewBrickDidGenerateNotification"
    static var GameStateChangeNotification             = "GameStateChangeNotification"
    
    // font
    static func GameFont(fontSize:CGFloat) -> UIFont! {
        return UIFont(name: "ChalkboardSE-Regular", size: fontSize)
    }
    
    var gameView:GameView!
    var gameTimer:GameTimer!
    var soundManager = SoundManager()
    
    var gameState = GameState.STOP
    
    required init(gameView:GameView) {
        super.init()
        self.gameView = gameView
        self.initializeGame()
    }
    
    func initializeGame() {
        self.gameTimer = GameTimer(target: self, selector: "gameLoop")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "gameStateChange:", name: Swiftris.GameStateChangeNotification, object: nil)
        
        let longpressGesture = UILongPressGestureRecognizer(target: self, action: "longPressed:")
        self.gameView.gameBoard.addGestureRecognizer(longpressGesture)
    }
    
    func gameStateChange(noti:NSNotification!) {
        if let userInfo = noti.userInfo as? [String:NSNumber] {
            if let rawValue = userInfo["gameState"], let toState = GameState(rawValue: rawValue.integerValue) {
                
                switch self.gameState {
                case .PLAY:
                    // pause
                    if toState == GameState.PAUSE {
                        self.pause()
                    }
                    // stop
                    if toState == GameState.STOP {
                        self.stop()
                    }
                case .PAUSE:
                    // resume game
                    if toState == GameState.PLAY {
                        self.play()
                    }
                    // stop
                    if toState == GameState.STOP {
                        self.stop()
                    }
                case .STOP:
                    // start game
                    if toState == GameState.PLAY {
                        self.gameView.prepare()
                        self.gameView.gameBoard.generateBrick()
                        self.play()
                    }
                }
            }
        }
    }
    

    func gameLoop() {
        self.update()
        self.gameView.setNeedsDisplay()
    }
    func update() {

        self.gameTimer.counter++
        
        if self.gameTimer.counter%10 == 9 {
            let game = self.gameView.gameBoard.update()
            if game.isGameOver {
                self.gameOver()
                return
            }
            if game.droppedBrick {
                self.soundManager.dropBrick()
            }
        }
    }
    
    func play() {
        self.gameState = GameState.PLAY
        self.gameTimer.start()
        self.soundManager.playBGM()
    }
    func pause() {
        self.gameState = GameState.PAUSE
        self.gameTimer.pause()
        self.soundManager.pauseBGM()
    }
    func stop() {
        self.gameState = GameState.STOP
        self.gameTimer.pause()
        self.soundManager.stopBGM()
        
        self.gameView.clear()
    }

    func gameOver() {
        self.gameState = GameState.STOP
        self.gameTimer.pause()
        self.soundManager.stopBGM()
        self.soundManager.gameOver()
        
        self.gameView.nextBrick.clear()
    }
    
    // game interaction
    func touch(touch:UITouch!) {
        guard self.gameState == GameState.PLAY else { return }
        guard let curretBrick = self.gameView.gameBoard.currentBrick else { return }
        
        let p = touch.locationInView(self.gameView.gameBoard)
        
        let half = self.gameView.gameBoard.centerX
        
        let top  = curretBrick.top()
        let topY = CGFloat( (Int(top.y) + curretBrick.ty) * GameBoard.brickSize )

        if p.y > topY  {
            if p.x > half {
                self.gameView.gameBoard.updateX(1)
            } else if p.x < half {
                self.gameView.gameBoard.updateX(-1)
            }
        } else   {
            self.gameView.gameBoard.rotateBrick()
        }
    }
    
    func longPressed(longpressGesture:UILongPressGestureRecognizer!) {
        if self.gameState == GameState.PLAY {

            if longpressGesture.state == UIGestureRecognizerState.Began {
                self.gameView.gameBoard.dropBrick()
            }
        }
    }
}
