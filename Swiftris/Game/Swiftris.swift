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
        self.initGame()
    }
    
    deinit {
        debugPrint("deinit Swiftris")
    }
    
    private func initGame() {
        self.gameTimer = GameTimer(target: self, selector: #selector(Swiftris.gameLoop))
        
        self.addLongPressAction(#selector(Swiftris.longPressed(_:)), toView:self.gameView.gameBoard)
        
        self.addGameStateChangeNotificationAction(#selector(Swiftris.gameStateChange(_:)))
    }
    
    func deinitGame() {
        self.stop()
        self.soundManager.clear()
        self.removeGameStateChangeNotificationAction()
        
        self.gameTimer = nil
        self.gameView = nil
    }
    
    func gameStateChange(noti:NSNotification) {
        guard let userInfo = noti.userInfo as? [String:NSNumber] else { return }
        guard let rawValue = userInfo["gameState"] else { return }
        guard let toState = GameState(rawValue: rawValue.integerValue) else { return }
        
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
                self.prepare()
                self.play()
            }
        }
    }
    
    
    func longPressed(longpressGesture:UILongPressGestureRecognizer) {
        if self.gameState == GameState.PLAY {
            if longpressGesture.state == UIGestureRecognizerState.Began {
                self.gameView.gameBoard.dropBrick()
            }
        }
    }

    func gameLoop() {
        self.update()
        self.gameView.setNeedsDisplay()
    }
    private func update() {

        self.gameTimer.counter += 1
        
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
    
    private func prepare() {
        self.gameView.prepare()
        self.gameView.gameBoard.generateBrick()
    }
    private func play() {
        self.gameState = GameState.PLAY
        self.gameTimer.start()
        self.soundManager.playBGM()
    }
    private func pause() {
        self.gameState = GameState.PAUSE
        self.gameTimer.pause()
        self.soundManager.pauseBGM()
    }
    private func stop() {
        self.gameState = GameState.STOP
        self.gameTimer.pause()
        self.soundManager.stopBGM()
        
        self.gameView.clear()
    }

    private func gameOver() {
        self.gameState = GameState.STOP
        self.gameTimer.pause()
        self.soundManager.stopBGM()
        self.soundManager.gameOver()
        
        self.gameView.nextBrick.clear()
    }
    
    // game interaction
    func touch(touch:UITouch) {
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
    
    private func addLongPressAction(action:Selector, toView view:UIView) {
        let longpressGesture = UILongPressGestureRecognizer(target: self, action: action)
        view.addGestureRecognizer(longpressGesture)
    }
    
    private func addGameStateChangeNotificationAction(action:Selector) {
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: action,
                                                         name: Swiftris.GameStateChangeNotification,
                                                         object: nil)
    }
    private func removeGameStateChangeNotificationAction() {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
}
