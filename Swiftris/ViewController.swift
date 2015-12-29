//
//  ViewController.swift
//  Swiftris
//
//  Created by Sungbae Kim on 2015. 7. 3..
//  Copyright (c) 2015년 1minute2life. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    var gameView:GameView!
    var swiftris:Swiftris!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeGame() {
        self.gameView = GameView(self.view)
        self.swiftris = Swiftris(gameView: self.gameView)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first  {
            self.swiftris.touch(touch)
        }
    }
    
    func makePanGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: "panned:")
        panGesture.delegate = self
        self.view.addGestureRecognizer(panGesture)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
}

