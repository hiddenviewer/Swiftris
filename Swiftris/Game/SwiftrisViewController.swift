//
//  SwiftrisViewController.swift
//  Swiftris
//
//  Created by Sungbae Kim on 2016. 6. 4..
//  Copyright © 2016년 1minute2life. All rights reserved.
//

import UIKit

class SwiftrisViewController: UIViewController {

    @IBOutlet weak var contentView: UIView!

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
        // after layout pass, ensure GameView to make
        DispatchQueue.main.async {
            let gameView = GameView(self.contentView)
            self.swiftris = Swiftris(gameView: gameView)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first  {
            self.swiftris.touch(touch)
        }
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
}
