//
//  NextBrick.swift
//  Swiftris
//
//  Created by Sungbae Kim on 2015. 7. 4..
//  Copyright (c) 2015년 1minute2life. All rights reserved.
//

import UIKit

class NextBrick: UIView {

    fileprivate var gameButton = GameButton(title: "Play", frame: CGRect.zero)
    fileprivate var stopButton = GameButton(title: "Stop", frame: CGRect.zero)
    
    override init(frame: CGRect) {
        super.init(frame: CGRect.zero)
        self.backgroundColor = UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.0)
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(NextBrick.newBrickGenerated),
                                                         name: NSNotification.Name(rawValue: Swiftris.NewBrickDidGenerateNotification),
                                                         object: nil)
        
        self.makeGameButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func newBrickGenerated() {
        self.setNeedsDisplay()
    }
    
     override func draw(_ rect: CGRect) {
        let gap = 4 * CGFloat(GameBoard.smallBrickSize)
        var top = 2 * CGFloat(GameBoard.smallBrickSize)
    
        for brick in Brick.nextBricks {
            let brickWidth = (brick.right().x+1) * CGFloat(GameBoard.smallBrickSize)
            let brickHeight = brick.bottom().y * CGFloat(GameBoard.smallBrickSize)
            let left = (rect.size.width - brickWidth)/2
            for p in brick.points {
                let r = Int(p.y)
                let c = Int(p.x)
                self.drawAt(top: top, left:left, row:r, col: c, color:brick.color)
            }
            top += brickHeight
            top += gap
        }
    }
    
    func drawAt(top:CGFloat, left:CGFloat, row:Int, col:Int, color:UIColor) {
        let context = UIGraphicsGetCurrentContext()!
        let block = CGRect(
            x: left + CGFloat(col*GameBoard.gap + col*GameBoard.smallBrickSize),
            y: top + CGFloat(row*GameBoard.gap + row*GameBoard.smallBrickSize),
            width: CGFloat(GameBoard.smallBrickSize),
            height: CGFloat(GameBoard.smallBrickSize)
        )
        
        if color == GameBoard.EmptyColor {
            GameBoard.strokeColor.set()
            context.fill(block)
        } else {
            color.set()
            UIBezierPath(roundedRect: block, cornerRadius: 1).fill()
        }
    }
    
    func makeGameButton() {
        // play and pause button
        self.gameButton.translatesAutoresizingMaskIntoConstraints = false
        self.gameButton.addTarget(self, action: #selector(NextBrick.changeGameState(_:)), for: UIControlEvents.touchUpInside)
        self.addSubview(self.gameButton)
        
        self.stopButton.translatesAutoresizingMaskIntoConstraints = false
        self.stopButton.addTarget(self, action: #selector(NextBrick.gameStop(_:)), for: UIControlEvents.touchUpInside)
        self.addSubview(self.stopButton)
        
        let views = [
            "gameButton":gameButton,
            "selfView":self,
            "stopButton":stopButton
        ] as [String : Any]
        
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:[gameButton(60)]",
                options: [],
                metrics: nil,
                views: views)
        )
        
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "V:[gameButton(60)]-20-|",
                options: [],
                metrics: nil,
                views: views)
        )
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[selfView]-(<=0)-[gameButton]",
            options: NSLayoutFormatOptions.alignAllCenterX,
            metrics: nil ,
            views: views)
        )
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:[stopButton(60)]",
            options: [],
            metrics: nil,
            views: views)
        )
        
        self.addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:[stopButton(60)]-10-[gameButton]",
            options: NSLayoutFormatOptions.alignAllLeft,
            metrics: nil, views: views)
        )
    }
    
    @objc func gameStop(_ sender:UIButton) {
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: Swiftris.GameStateChangeNotification),
            object: nil,
            userInfo: ["gameState":NSNumber(value: GameState.stop.rawValue as Int)]
        )
    }
    
    @objc func changeGameState(_ sender:UIButton) {
        sender.isSelected = !sender.isSelected
        let gameState = self.update(sender.isSelected)
        
        NotificationCenter.default.post(
            name: Notification.Name(rawValue: Swiftris.GameStateChangeNotification),
            object: nil,
            userInfo: ["gameState":NSNumber(value: gameState.rawValue as Int)]
        )
    }
    
    @discardableResult
    func update(_ selected:Bool) -> GameState {
        var gameState = GameState.play
        if selected {
            gameState = GameState.play
            self.gameButton.setTitle("Pause", for: UIControlState())
        } else {
            gameState = GameState.pause
            self.gameButton.setTitle("Play", for: UIControlState())
        }
        return gameState
    }
    
    func prepare() {
        self.clearButtons()
        self.clearNextBricks()
    }
    
    func clearButtons() {
        self.gameButton.isSelected = false
        self.update(self.gameButton.isSelected)
    }
    
    func clearNextBricks() {
        Brick.nextBricks = [Brick]()
        self.setNeedsDisplay()
    }
}
