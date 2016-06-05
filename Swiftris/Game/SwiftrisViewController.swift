//
//  SwiftrisViewController.swift
//  Swiftris
//
//  Created by 김성배 on 2016. 6. 4..
//  Copyright © 2016년 1minute2life. All rights reserved.
//

import UIKit

class SwiftrisViewController: UIViewController {

    var swiftris:Swiftris!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initializeGame()
    }
    
    deinit {
        self.swiftris.deinitGame()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initializeGame() {
        let gameView = GameView(self.view)
        self.swiftris = Swiftris(gameView: gameView)
    }

    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if let touch = touches.first  {
            self.swiftris.touch(touch)
        }
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
    }
}