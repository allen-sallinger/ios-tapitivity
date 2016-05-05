//
//  StartScene.swift
//  tapitivity
//
//  Created by ALLEN SALLINGER on 8/6/15.
//  Copyright (c) 2015 GSD. All rights reserved.
//

import Foundation
import SpriteKit

class StartScene: SKScene{
    
    let bg = SKSpriteNode(imageNamed: "background_small")
    let playLabel = SKLabelNode()
    let optionsLabel = SKLabelNode()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.whiteColor()
        
    }
    
    override func didMoveToView(view: SKView) {
        
        addChild(bg)
        
        // Create the play label
        playLabel.text = "Play"
        playLabel.fontSize = 80
        playLabel.fontColor = SKColor.blackColor()
        playLabel.position = CGPoint(x: size.width/2, y: size.height * 0.7)
        addChild(playLabel)
        
        //let storeHello = SKLabelNode()
        optionsLabel.text = "Options"
        optionsLabel.fontSize = 40
        optionsLabel.fontColor = SKColor.blackColor()
        optionsLabel.position = CGPoint(x: size.width/2, y: size.height/2)
        addChild(optionsLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if let touch = touches.first as? UITouch{
            
            let touchLocation = touch.locationInNode(self)
            
            if(playLabel.containsPoint(touchLocation)){
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene)
            }
            
            if(optionsLabel.containsPoint(touchLocation)){
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let optionsScene = OptionsScene(size: self.size)
                self.view?.presentScene(optionsScene)
            }
            
        }
        
        
        
    }
    
}