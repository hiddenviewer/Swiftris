//
//  ViewController.swift
//  Swiftris
//
//  Created by Sungbae Kim on 2015. 7. 3..
//  Copyright (c) 2015년 1minute2life. All rights reserved.
//

import UIKit

// this view controller not used.
// entry view controller is SwiftrisViewController.
class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }
    
    @IBAction func startGame(_ sender: UIButton) {
        let swiftrisViewController = SwiftrisViewController()
        self.present(swiftrisViewController, animated: true, completion: nil)
    }
}

