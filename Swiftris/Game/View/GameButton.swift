//
//  GameButton.swift
//  Swiftris
//
//  Created by Sungbae Kim on 2016. 6. 12..
//  Copyright © 2016년 1minute2life. All rights reserved.
//

import UIKit

class GameButton: UIButton {

    convenience init(title:String, frame: CGRect) {
        self.init(frame: frame)
        self.setTitle(title, for: UIControlState())
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initializeView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initializeView()
    }
    
    fileprivate func initializeView() {
        self.backgroundColor = UIColor.clear
        self.setTitleColor(UIColor.white, for: UIControlState())
        self.titleLabel?.font = Swiftris.GameFont(18)
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 2
        self.layer.cornerRadius = 5
    }
}
