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
    
    fileprivate var levelLabel = UILabel()
    fileprivate var lineClearLabel = UILabel()
    fileprivate var scoreLabel = UILabel()
    fileprivate var scores = [0, 10, 30, 60, 100]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(red:0.21, green:0.21, blue:0.21, alpha:1.0)
        
        self.levelLabel.translatesAutoresizingMaskIntoConstraints = false
        self.levelLabel.textColor = UIColor.white
        self.levelLabel.text = "Level: \(self.gameLevel)"
        self.levelLabel.font = Swiftris.GameFont(20)
        self.levelLabel.adjustsFontSizeToFitWidth = true
        self.levelLabel.minimumScaleFactor = 0.9
        self.addSubview(self.levelLabel)
        
        self.lineClearLabel.translatesAutoresizingMaskIntoConstraints = false
        self.lineClearLabel.textColor = UIColor.white
        self.lineClearLabel.text = "Lines: \(self.lineClearCount)"
        self.lineClearLabel.font = Swiftris.GameFont(20)
        self.lineClearLabel.adjustsFontSizeToFitWidth = true
        self.lineClearLabel.minimumScaleFactor = 0.9
        self.addSubview(self.lineClearLabel)
        
        self.scoreLabel = UILabel(frame: CGRect.zero)
        self.scoreLabel.translatesAutoresizingMaskIntoConstraints = false
        self.scoreLabel.textColor = UIColor.white
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
        ] as [String : Any]
        
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "H:|-[level(80)]-10-[lineClear(>=90)]-10-[score(lineClear)]-|",
                options: NSLayoutFormatOptions.alignAllCenterY,
                metrics: nil,
                views: views)
        )
        
        self.addConstraints(
            NSLayoutConstraint.constraints(
                withVisualFormat: "[selfView]-(<=0)-[level]",
                options: NSLayoutFormatOptions.alignAllCenterY,
                metrics: nil,
                views: views)
        )
        
        NotificationCenter.default.addObserver(self,
                                                         selector: #selector(GameScore.lineClear(_:)),
                                                         name: NSNotification.Name(rawValue: Swiftris.LineClearNotification),
                                                         object: nil)
    }
    
    @objc func lineClear(_ noti:Notification) {
        if let userInfo = noti.userInfo as? [String:NSNumber] {
            if let lineCount = userInfo["lineCount"] {
                self.lineClearCount += lineCount.intValue
                self.gameScore += self.scores[lineCount.intValue]
                self.update()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
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

