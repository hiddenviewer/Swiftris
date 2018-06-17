//
//  GameTimer.swift
//  Swiftris
//
//  Created by Sungbae Kim on 2015. 7. 13..
//  Copyright (c) 2015년 1minute2life. All rights reserved.
//

import UIKit

class GameTimer: NSObject {
    
    var counter = 0
    fileprivate var displayLink:CADisplayLink!
    
    init(target:AnyObject, selector:Selector) {
        self.displayLink = CADisplayLink(target: target, selector: selector)
        self.displayLink.preferredFramesPerSecond = 2
        self.displayLink.isPaused = true
        self.displayLink.add(to: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
    }
    
    func start() {
        self.displayLink.isPaused = false
    }
    func pause() {
        self.displayLink.isPaused = true
    }
    deinit {
        print("deinit GameTimer")
        
        if let link = self.displayLink {
            link.remove(from: RunLoop.current, forMode: RunLoopMode.defaultRunLoopMode)
        }
    }
    
}
