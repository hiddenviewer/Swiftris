//
//  GameScore.swift
//  Swiftris
//
//  Created by Sungbae Kim on 2015. 7. 4..
//  Copyright (c) 2015년 1minute2life. All rights reserved.
//

import UIKit

class GameScore: UIView {

    var gameLevel = 0
    var lineClearCount = 0
    var gameScore = 0
    
    var levelLabel = UILabel(frame: CGRectZero)
    var lineClearLabel = UILabel(frame: CGRectZero)
    var scoreLabel = UILabel(frame: CGRectZero)
    var scores = [0, 10, 30, 60, 100]
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.0)
        
        self.levelLabel.translatesAutoresizingMaskIntoConstraints = false
        self.levelLabel.textColor = UIColor.whiteColor()
        self.levelLabel.text = "Level: 1"
        self.levelLabel.font = Swiftris.GameFont(20)
        self.levelLabel.invalidateIntrinsicContentSize()
        self.addSubview(self.levelLabel)
        
        self.lineClearLabel.translatesAutoresizingMaskIntoConstraints = false
        self.lineClearLabel.textColor = UIColor.whiteColor()
        self.lineClearLabel.text = "Lines: \(self.lineClearCount)"
        self.lineClearLabel.invalidateIntrinsicContentSize()
        self.lineClearLabel.font = Swiftris.GameFont(20)
        self.addSubview(self.lineClearLabel)
        
        self.scoreLabel = UILabel(frame: CGRectZero)
        self.scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        self.scoreLabel.textColor = UIColor.whiteColor()
        self.scoreLabel.text = "Score: \(self.gameScore)"
        self.scoreLabel.invalidateIntrinsicContentSize()
        self.scoreLabel.font = Swiftris.GameFont(20)
        self.addSubview(self.scoreLabel)
     
        let views = ["level":self.levelLabel, "lineClear":self.lineClearLabel, "score":self.scoreLabel, "superView":self]
        let metrics = ["spacer":50]
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[level(80)]-(10)-[lineClear(100)]-(5)-[score(>=120)]-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metrics, views: views))
        self.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("[superView]-(<=0)-[level]", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: metrics, views: views))
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "lineClear:", name: Swiftris.LineClearNotification, object: nil)
    }
    
    func lineClear(noti:NSNotification!) {
        if let userInfo = noti.userInfo as? [String:NSNumber] {
            if let lineCount = userInfo["lineCount"] {
                self.lineClearCount += lineCount.integerValue
                self.gameScore += self.scores[lineCount.integerValue]
                self.update()
            }
        }
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   func clear() {
        self.gameLevel = 0
        self.lineClearCount = 0
        self.gameScore = 0
    }
    func update() {
        self.levelLabel.text = "Level: 1"
        self.lineClearLabel.text = "Lines: \(self.lineClearCount)"
        self.scoreLabel.text = "Score: \(self.gameScore)"
    }

}
