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
    
    func generateRow() -> [UIColor]! {
        var row = [UIColor]()
        for _ in 0..<GameBoard.cols {
            row.append(GameBoard.EmptyColor)
        }
        return row
    }

    func generateBrick() {
        self.currentBrick = Brick.generate()
        NSNotificationCenter.defaultCenter().postNotificationName(Swiftris.NewBrickDidGenerateNotification, object: nil)
    }
    
    
    func dropBrick() {
        while self.canMoveDown() {
            self.currentBrick!.moveDown()
            self.setNeedsDisplay()
        }
    }
    
    func rotateBrick() {
        let rotatedBrick = self.currentBrick!.rotatedPoints()
        if self.canRotate(rotatedBrick) {
            self.currentBrick!.points = rotatedBrick
            self.setNeedsDisplay()
        }
    }
    
    func canRotate(points:[CGPoint]) -> Bool {
        for p in points {
            let r = Int(p.y) + self.currentBrick!.ty
            let c = Int(p.x) + self.currentBrick!.tx
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
    
    
    func canMoveDown() -> Bool {
        for p in self.currentBrick!.points {
            let r = Int(p.y) + self.currentBrick!.ty + 1
            if r >= GameBoard.rows {
                return false
            }
            let c = Int(p.x) + self.currentBrick!.tx
            if self.board[r][c] !=  GameBoard.EmptyColor {
                return false
            }
        }
        return true
    }
    
    func update() -> (isGameOver:Bool, droppedBrick:Bool) {

        guard let currentBrick = self.currentBrick else { return (false, false)  }
        
        var droppedBrick = false
        
        if self.canMoveDown() {
            currentBrick.moveDown()
        } else {
            
            droppedBrick = true
            
            for p in currentBrick.points {
                let r = Int(p.y) + currentBrick.ty
                let c = Int(p.x) + currentBrick.tx
                if self.board[r][c] != GameBoard.EmptyColor {
                    // game over
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
        
        for var i=0; i < self.board.count; i++ {
            let row = self.board[i]
            let rows = row.filter { c -> Bool in
                return c != GameBoard.EmptyColor
            }
            if rows.count == GameBoard.cols {
                linesToRemove.append(i)
                lineCount++
            }
        }
        for line in linesToRemove {
            self.board.removeAtIndex(line)
            self.board.insert(self.generateRow(), atIndex: 0)
        }
        
        NSNotificationCenter.defaultCenter().postNotificationName(Swiftris.LineClearNotification, object: nil, userInfo: ["lineCount":NSNumber(integer: lineCount)])
    }
    
    func updateX(x:Int) {
        
        guard let currentBrick = self.currentBrick else { return }
        
        if x > 0 {
            var canMoveRight = Int(currentBrick.right().x) + currentBrick.tx + 1 <= GameBoard.cols-1
            if canMoveRight {
                for p in self.currentBrick!.points {
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
            self.drawAtRow(r, col: c, color: currentBrick.color)
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