//
//  GameView.swift
//  Swiftris
//
//  Created by Sungbae Kim on 2015. 7. 4..
//  Copyright (c) 2015년 1minute2life. All rights reserved.
//

import UIKit

class GameView: UIView {

    var gameScore = GameScore(frame:CGRectZero)
    var gameBoard = GameBoard(frame:CGRectZero)
    var nextBrick = NextBrick(frame:CGRectZero)
    
    init(_ superView:UIView) {
        super.init(frame: superView.frame)
        superView.backgroundColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
        superView.addSubview(self)
        
        // background color
        self.backgroundColor = UIColor(red:0.27, green:0.27, blue:0.27, alpha:1.0)
        
        self.gameBoard.translatesAutoresizingMaskIntoConstraints = false
        self.gameScore.translatesAutoresizingMaskIntoConstraints = false
        self.nextBrick.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(self.gameBoard)
        self.addSubview(self.gameScore)
        self.addSubview(self.nextBrick)
        
        // layout gameboard
        let metrics = ["width":GameBoard.width,"height":GameBoard.height]
        let views   = ["gameBoard":self.gameBoard, "nextBrick":self.nextBrick, "gameScore":self.gameScore]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[gameBoard(width)]", options: [], metrics:metrics , views:views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[gameBoard(height)]-|", options: [], metrics:metrics , views:views))
        
        // layout score
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[gameScore]-|", options: [], metrics:nil , views:views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[gameScore]-[gameBoard]", options: [], metrics:nil , views:views))

        // layout next brick
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[gameBoard]-[nextBrick]-|", options: NSLayoutFormatOptions.AlignAllTop, metrics:nil , views:views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[nextBrick]-|", options: [], metrics:nil , views:views))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clear() {
        self.gameScore.clear()
        self.gameBoard.clear()
        self.nextBrick.clear()
    }
    func prepare() {
        self.gameScore.clear()
        self.gameBoard.clear()
        self.nextBrick.prepare()
    }
}
