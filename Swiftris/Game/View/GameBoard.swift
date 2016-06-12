//
//  GameBoard.swift
//  Swiftris
//
//  Created by Sungbae Kim on 2015. 7. 3..
//  Copyright (c) 2015년 1minute2life. All rights reserved.
//

import UIKit

class GameBoard: UIView {
    
    static let rows = 22
    static let cols = 10
    static let gap = 1
    static let brickSize = Int(UIScreen.mainScreen().bounds.size.width*(24/375.0))
    static let smallBrickSize = Int(UIScreen.mainScreen().bounds.size.width*(18/375.0))
    static let width  = GameBoard.brickSize * GameBoard.cols + GameBoard.gap * (GameBoard.cols+1)
    static let height = GameBoard.brickSize * GameBoard.rows + GameBoard.gap * (GameBoard.rows+1)
    static let EmptyColor = UIColor.blackColor()
    static let strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    
    var board = [[UIColor]]()
    var currentBrick:Brick?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.0)
        self.clear()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func generateRow() -> [UIColor]! {
        var row = [UIColor]()
        for _ in 0..<GameBoard.cols {
            row.append(GameBoard.EmptyColor)
        }
        return row
    }

    func generateBrick() {
        self.currentBrick = Brick.generate()
        
        NSNotificationCenter.defaultCenter().postNotificationName(
            Swiftris.NewBrickDidGenerateNotification,
            object: nil
        )
    }
    
    
    func dropBrick() {
        guard let currentBrick = self.currentBrick else { return }
        
        while self.canMoveDown(currentBrick) {
            currentBrick.moveDown()
            self.setNeedsDisplay()
        }
    }
    
    func rotateBrick() {
        guard let currentBrick = self.currentBrick else { return }
        
        let rotatedPoints = currentBrick.rotatedPoints()
        if self.canRotate(currentBrick, rotatedPoints: rotatedPoints) {
            currentBrick.points = rotatedPoints
            self.setNeedsDisplay()
        }
    }
    
    func canRotate(brick:Brick, rotatedPoints:[CGPoint]) -> Bool {

        for p in rotatedPoints {
            let r = Int(p.y) + brick.ty
            let c = Int(p.x) + brick.tx
            if r < 0 || r >= GameBoard.rows {
                return false
            }
            if c < 0 || c >= GameBoard.cols {
                return false
            }
            if self.board[r][c] != GameBoard.EmptyColor {
                return false
            }
        }
        return true
    }
    
    
    func canMoveDown(brick:Brick) -> Bool {
        for p in brick.points {
            let r = Int(p.y) + brick.ty + 1
            
            // not visible brick points
            if r < 0 {
                continue
            }
            // reach to bottom
            if r >= GameBoard.rows {
                return false
            }
            let c = Int(p.x) + brick.tx
            if self.board[r][c] !=  GameBoard.EmptyColor {
                return false
            }
        }
        return true
    }
    
    func update() -> (isGameOver:Bool, droppedBrick:Bool) {

        guard let currentBrick = self.currentBrick else { return (false, false)  }
        
        var droppedBrick = false
        
        if self.canMoveDown(currentBrick) {
            currentBrick.moveDown()
        } else {
            
            droppedBrick = true
            
            for p in currentBrick.points {
                let r = Int(p.y) + currentBrick.ty
                let c = Int(p.x) + currentBrick.tx
                
                // check game over
                // can't move down and brick is out of top bound.
                if r < 0 {
                    self.setNeedsDisplay()
                    return (true, false)
                }
                self.board[r][c] = currentBrick.color
            }
            // clear lines
            self.lineClear()
            
            self.generateBrick()
        }
        self.setNeedsDisplay()
        
        return (false, droppedBrick)
    }

    
    func lineClear() {
        var lineCount = 0
        var linesToRemove = [Int]()
        
        for i in 0..<self.board.count {
            let row = self.board[i]
            let rows = row.filter { c -> Bool in
                return c != GameBoard.EmptyColor
            }
            if rows.count == GameBoard.cols {
                linesToRemove.append(i)
                lineCount += 1
            }
        }
        for line in linesToRemove {
            self.board.removeAtIndex(line)
            self.board.insert(self.generateRow(), atIndex: 0)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(
            Swiftris.LineClearNotification,
            object: nil,
            userInfo: ["lineCount":NSNumber(integer: lineCount)]
        )
    }
    
    func updateX(x:Int) {
        
        guard let currentBrick = self.currentBrick else { return }
        
        if x > 0 {
            var canMoveRight = Int(currentBrick.right().x) + currentBrick.tx + 1 <= GameBoard.cols-1
            if canMoveRight {
                for p in currentBrick.points {
                    // not visible brick points
                    if currentBrick.ty < 0 {
                        continue
                    }
                    let r = Int(p.y) + currentBrick.ty
                    let c = Int(p.x) + currentBrick.tx + 1
                    if self.board[r][c] !=  GameBoard.EmptyColor {
                        canMoveRight = false
                        break
                    }
                }
            }
            if canMoveRight {
                currentBrick.moveRight()
                self.setNeedsDisplay()
            }
        } else if x < 0 {
            var canMoveLeft = Int(currentBrick.left().x) + currentBrick.tx - 1 >= 0
            if canMoveLeft {
                for p in currentBrick.points {
                    // not visible brick points
                    if currentBrick.ty < 0 {
                        continue
                    }
                    let r = Int(p.y) + currentBrick.ty
                    let c = Int(p.x) + currentBrick.tx - 1
                    if self.board[r][c] !=  GameBoard.EmptyColor {
                        canMoveLeft = false
                        break
                    }
                }
            }
            if canMoveLeft {
                currentBrick.moveLeft()
                self.setNeedsDisplay()
            }
        }
    }

    
    override func drawRect(rect: CGRect) {
        // draw game board
        for r in  0..<GameBoard.rows {
            for c in 0..<GameBoard.cols {
                let color = self.board[r][c]
                self.drawAtRow(r, col: c, color:color)
            }
        }
        // draw current bricks
        guard let currentBrick = self.currentBrick else { return }
        for p in currentBrick.points {
            let r = Int(p.y) + currentBrick.ty
            let c = Int(p.x) + currentBrick.tx
            // (r >= 0) condition enable to draw partial brick
            if r >= 0 {
                self.drawAtRow(r, col: c, color: currentBrick.color)
            }
        }
    }

    
    func drawAtRow(r:Int, col c:Int, color:UIColor!) {
        let context = UIGraphicsGetCurrentContext()
        let block = CGRectMake(CGFloat((c+1)*GameBoard.gap + c*GameBoard.brickSize),
            CGFloat((r+1)*GameBoard.gap + r*GameBoard.brickSize),
            CGFloat(GameBoard.brickSize),
            CGFloat(GameBoard.brickSize))
        
            if color == GameBoard.EmptyColor {
                GameBoard.strokeColor.set()
                CGContextFillRect(context, block)
            } else {
                color.set()
                UIBezierPath(roundedRect: block, cornerRadius: 1).fill()
            }
    }
    
    func clear() {
        self.currentBrick = nil
        
        self.board = [[UIColor]]()
        for _ in 0..<GameBoard.rows {
            self.board.append(self.generateRow())
        }
        self.setNeedsDisplay()
    }
    
    var topY:CGFloat {
      return CGFloat(3 * GameBoard.brickSize)
    }
    var bottomY:CGFloat {
        return CGFloat((GameBoard.rows-1) * GameBoard.brickSize)
    }
    var centerX:CGFloat {
        return CGFloat(self.currentBrick!.tx * GameBoard.brickSize)
    }
}
