//
//  GameViewController.swift
//  tapitivity
//
//  Created by ALLEN SALLINGER on 7/1/15.
//  Copyright (c) 2015 GSD. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
 
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = StartScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .ResizeFill
        skView.presentScene(scene)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}