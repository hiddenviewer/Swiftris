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
    private var displayLink:CADisplayLink!
    
    init(target:AnyObject, selector:Selector) {
        self.displayLink = CADisplayLink(target: target, selector: selector)
        self.displayLink.frameInterval = 2
        self.displayLink.paused = true
        self.displayLink.addToRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
    }
    
    func start() {
        self.displayLink.paused = false
    }
    func pause() {
        self.displayLink.paused = true
    }
    deinit {
        print("deinit GameTimer")
        
        if let link = self.displayLink {
            link.removeFromRunLoop(NSRunLoop.currentRunLoop(), forMode: NSDefaultRunLoopMode)
        }
    }
    
}
