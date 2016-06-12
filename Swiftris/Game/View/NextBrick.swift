//
//  NextBrick.swift
//  Swiftris
//
//  Created by Sungbae Kim on 2015. 7. 4..
//  Copyright (c) 2015년 1minute2life. All rights reserved.
//

import UIKit

class NextBrick: UIView {

    private var gameButton = GameButton(title: "Play", frame: CGRectZero)
    private var stopButton = GameButton(title: "Stop", frame: CGRectZero)
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.0)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(NextBrick.newBrickGenerated),
                                                         name: Swiftris.NewBrickDidGenerateNotification,
                                                         object: nil)
        
        self.makeGameButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func newBrickGenerated() {
        self.setNeedsDisplay()
    }
    
     override func drawRect(rect: CGRect) {
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
    
    func drawAt(top top:CGFloat, left:CGFloat, row:Int, col:Int, color:UIColor) {
        let context = UIGraphicsGetCurrentContext()
        let block = CGRectMake(
            left + CGFloat(col*GameBoard.gap + col*GameBoard.smallBrickSize),
            top + CGFloat(row*GameBoard.gap + row*GameBoard.smallBrickSize),
            CGFloat(GameBoard.smallBrickSize),
            CGFloat(GameBoard.smallBrickSize)
        )
        
        if color == GameBoard.EmptyColor {
            GameBoard.strokeColor.set()
            CGContextFillRect(context, block)
        } else {
            color.set()
            UIBezierPath(roundedRect: block, cornerRadius: 1).fill()
        }
    }
    
    func makeGameButton() {
        // play and pause button
        self.gameButton.translatesAutoresizingMaskIntoConstraints = false
        self.gameButton.addTarget(self, action: #selector(NextBrick.changeGameState(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.gameButton)
        
        self.stopButton.translatesAutoresizingMaskIntoConstraints = false
        self.stopButton.addTarget(self, action: #selector(NextBrick.gameStop(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(self.stopButton)
        
        let views = [
            "gameButton":gameButton,
            "selfView":self,
            "stopButton":stopButton
        ]
        
        self.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:[gameButton(60)]",
                options: [],
                metrics: nil,
                views: views)
        )
        
        self.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "V:[gameButton(60)]-20-|",
                options: [],
                metrics: nil,
                views: views)
        )
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[selfView]-(<=0)-[gameButton]",
            options: NSLayoutFormatOptions.AlignAllCenterX,
            metrics: nil ,
            views: views)
        )
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:[stopButton(60)]",
            options: [],
            metrics: nil,
            views: views)
        )
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:[stopButton(60)]-10-[gameButton]",
            options: NSLayoutFormatOptions.AlignAllLeft,
            metrics: nil, views: views)
        )
    }
    
    func gameStop(sender:UIButton) {
        NSNotificationCenter.defaultCenter().postNotificationName(
            Swiftris.GameStateChangeNotification,
            object: nil,
            userInfo: ["gameState":NSNumber(integer: GameState.STOP.rawValue)]
        )
    }
    
    func changeGameState(sender:UIButton) {
        sender.selected = !sender.selected
        let gameState = self.update(sender.selected)
        
        NSNotificationCenter.defaultCenter().postNotificationName(
            Swiftris.GameStateChangeNotification,
            object: nil,
            userInfo: ["gameState":NSNumber(integer: gameState.rawValue)]
        )
    }
    
    func update(selected:Bool) -> GameState {
        var gameState = GameState.PLAY
        if selected {
            gameState = GameState.PLAY
            self.gameButton.setTitle("Pause", forState: UIControlState.Normal)
        } else {
            gameState = GameState.PAUSE
            self.gameButton.setTitle("Play", forState: UIControlState.Normal)
        }
        return gameState
    }
    
    func prepare() {
        self.clearButtons()
        self.clearNextBricks()
    }
    
    func clearButtons() {
        self.gameButton.selected = false
        self.update(self.gameButton.selected)
    }
    
    func clearNextBricks() {
        Brick.nextBricks = [Brick]()
        self.setNeedsDisplay()
    }
}
