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
    
    private var levelLabel = UILabel()
    private var lineClearLabel = UILabel()
    private var scoreLabel = UILabel()
    private var scores = [0, 10, 30, 60, 100]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.0)
        
        self.levelLabel.translatesAutoresizingMaskIntoConstraints = false
        self.levelLabel.textColor = UIColor.whiteColor()
        self.levelLabel.text = "Level: \(self.gameLevel)"
        self.levelLabel.font = Swiftris.GameFont(20)
        self.levelLabel.adjustsFontSizeToFitWidth = true
        self.levelLabel.minimumScaleFactor = 0.9
        self.addSubview(self.levelLabel)
        
        self.lineClearLabel.translatesAutoresizingMaskIntoConstraints = false
        self.lineClearLabel.textColor = UIColor.whiteColor()
        self.lineClearLabel.text = "Lines: \(self.lineClearCount)"
        self.lineClearLabel.font = Swiftris.GameFont(20)
        self.lineClearLabel.adjustsFontSizeToFitWidth = true
        self.lineClearLabel.minimumScaleFactor = 0.9
        self.addSubview(self.lineClearLabel)
        
        self.scoreLabel = UILabel(frame: CGRectZero)
        self.scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        self.scoreLabel.textColor = UIColor.whiteColor()
        self.scoreLabel.text = "Score: \(self.gameScore)"
        self.scoreLabel.font = Swiftris.GameFont(20)
        self.scoreLabel.adjustsFontSizeToFitWidth = true
        self.scoreLabel.minimumScaleFactor = 0.9
        self.addSubview(self.scoreLabel)
        
        let views = [
            "level": self.levelLabel,
            "lineClear": self.lineClearLabel,
            "score": self.scoreLabel,
            "selfView": self
        ]
        
        self.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "H:|-[level(80)]-10-[lineClear(>=90)]-10-[score(lineClear)]-|",
                options: NSLayoutFormatOptions.AlignAllCenterY,
                metrics: nil,
                views: views)
        )
        
        self.addConstraints(
            NSLayoutConstraint.constraintsWithVisualFormat(
                "[selfView]-(<=0)-[level]",
                options: NSLayoutFormatOptions.AlignAllCenterY,
                metrics: nil,
                views: views)
        )
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(GameScore.lineClear(_:)),
                                                         name: Swiftris.LineClearNotification,
                                                         object: nil)
    }
    
    func lineClear(noti:NSNotification) {
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
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
   func clear() {
        self.gameLevel = 0
        self.lineClearCount = 0
        self.gameScore = 0
        self.update()
    }
    
    func update() {
        self.levelLabel.text = "Level: \(self.gameLevel)"
        self.lineClearLabel.text = "Lines: \(self.lineClearCount)"
        self.scoreLabel.text = "Score: \(self.gameScore)"
    }
}

