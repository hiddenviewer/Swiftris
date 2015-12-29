//
//  NextBrick.swift
//  Swiftris
//
//  Created by Sungbae Kim on 2015. 7. 4..
//  Copyright (c) 2015년 1minute2life. All rights reserved.
//

import UIKit

class NextBrick: UIView {

    var gameButton:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: CGRectZero)
        self.backgroundColor = UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.0)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "newBrickGenerated", name: Swiftris.NewBrickDidGenerateNotification, object: nil)
        
        self.makeGameButton()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func newBrickGenerated() {
        self.setNeedsDisplay()
    }
    
     override func drawRect(rect: CGRect) {
        let widthSize = Int(rect.size.width)/GameBoard.smallBrickSize
        let gap  = 4
        var top  = 2
    
        for brick in Brick.nextBricks {
            let left = (widthSize - Int(brick.right().x))/2
            for p in brick.points {
                let r = Int(p.y) + top
                let c = Int(p.x) + left
                self.drawAtRow(r, c: c, color:brick.color)
            }
            top += Int(brick.bottom().y)
            top += gap
        }
    }
    
    func drawAtRow(r:Int, c:Int, color:UIColor!) {
        let context = UIGraphicsGetCurrentContext()
        let block = CGRectMake(CGFloat((c+1)*GameBoard.gap + c*GameBoard.smallBrickSize),
            CGFloat((r+1)*GameBoard.gap + r*GameBoard.smallBrickSize),
            CGFloat(GameBoard.smallBrickSize),
            CGFloat(GameBoard.smallBrickSize))
        
        if color == GameBoard.EmptyColor {
            GameBoard.strokeColor.set()
            CGContextFillRect(context, block)
        } else {
            color.set()
            let path = UIBezierPath(roundedRect: block, cornerRadius: 1)
            path.fill()
        }
    }
    
    func makeGameButton() {
        // play and pause button
        let gameButton = UIButton(frame: CGRectZero)
        gameButton.translatesAutoresizingMaskIntoConstraints = false
        gameButton.layer.borderColor = UIColor.whiteColor().CGColor
        gameButton.layer.borderWidth = 2
        gameButton.layer.cornerRadius = 5
        gameButton.titleLabel?.font = Swiftris.GameFont(18)
        gameButton.setTitle("Play", forState: UIControlState.Normal)
        gameButton.addTarget(self, action: "changeGameState:", forControlEvents: UIControlEvents.TouchUpInside)
        self.addSubview(gameButton)
        self.gameButton = gameButton
        
        let stopButton = UIButton(frame: CGRectZero)
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.layer.borderColor = UIColor.whiteColor().CGColor
        stopButton.layer.borderWidth = 2
        stopButton.addTarget(self, action: "gameStop:", forControlEvents: UIControlEvents.TouchUpInside)
        stopButton.layer.cornerRadius = 5
        stopButton.titleLabel?.font = Swiftris.GameFont(18)
        stopButton.setTitle("Stop", forState: UIControlState.Normal)
        self.addSubview(stopButton)
        
        let views = ["gameButton":gameButton, "superView":self, "stopButton":stopButton]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[gameButton(60)]", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[gameButton(60)]-20-|", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[superView]-(<=0)-[gameButton]", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil , views: views))
        
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[stopButton(60)]", options: [], metrics: nil, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[stopButton(60)]-10-[gameButton]", options: NSLayoutFormatOptions.AlignAllLeft, metrics: nil, views: views))
    }
    func gameStop(sender:UIButton!) {
        NSNotificationCenter.defaultCenter().postNotificationName(Swiftris.GameStateChangeNotification, object: nil, userInfo: ["gameState":NSNumber(integer: GameState.STOP.rawValue)])
    }
    
    func changeGameState(sender:UIButton!) {
        sender.selected = !sender.selected
        let gameState = self.update(sender.selected)
        NSNotificationCenter.defaultCenter().postNotificationName(Swiftris.GameStateChangeNotification, object: nil, userInfo: ["gameState":NSNumber(integer: gameState.rawValue)])
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
        self.update(self.gameButton.selected)
        Brick.nextBricks = [Brick]()
        self.setNeedsDisplay()
    }
    
    func clear() {
        self.gameButton.selected = false
        self.prepare()
    }
}
