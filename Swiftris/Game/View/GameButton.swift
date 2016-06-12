//
//  GameButton.swift
//  Swiftris
//
//  Created by 김성배 on 2016. 6. 12..
//  Copyright © 2016년 1minute2life. All rights reserved.
//

import UIKit

class GameButton: UIButton {

    convenience init(title:String, frame: CGRect) {
        self.init(frame: frame)
        self.setTitle(title, forState: UIControlState.Normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeView()
    }
    
    private func initializeView() {
        self.backgroundColor = UIColor.clearColor()
        self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.titleLabel?.font = Swiftris.GameFont(18)
        self.layer.borderColor = UIColor.whiteColor().CGColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 5
    }
}
