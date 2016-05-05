//
//  OptionsScene.swift
//  tapitivity
//
//  Created by ALLEN SALLINGER on 8/5/15.
//  Copyright (c) 2015 GSD. All rights reserved.
//

import Foundation
import SpriteKit

class OptionsScene: SKScene{
    
    let bg = SKSpriteNode(imageNamed: "background_small")
    let backLabel = SKLabelNode()
    let optionsHello = SKLabelNode()
    let creditsLabel = SKLabelNode()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.whiteColor()
        
    }
    
    override func didMoveToView(view: SKView) {
        
        addChild(bg)
        
        // Create the store label
        //let storeHello = SKLabelNode()
        optionsHello.text = "Options menu!"
        optionsHello.position = CGPoint(x: size.width/2, y: size.height/2)
        optionsHello.fontColor = SKColor.blackColor()
        addChild(optionsHello)
        
        // Create the back button
        //let backLabel = SKLabelNode()
        backLabel.text = "Back"
        backLabel.position = CGPoint(x: size.width * 0.1, y: size.height * 0.95)
        backLabel.fontColor = SKColor.blackColor()
        addChild(backLabel)
        
        // Create a label to go to the credits scene
        creditsLabel.text = "Credits"
        creditsLabel.position = CGPoint(x: size.width / 2, y: size.height * 0.25)
        creditsLabel.fontColor = SKColor.blackColor()
        addChild(creditsLabel)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if let touch = touches.first as? UITouch{
            
            let touchLocation = touch.locationInNode(self)
            
            if(backLabel.containsPoint(touchLocation)){
                
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let startScene = StartScene(size: self.size)
                self.view?.presentScene(startScene)
                
            }
            
            if(creditsLabel.containsPoint(touchLocation)){
                
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let creditsScene = CreditsScene(size: self.size)
                self.view?.presentScene(creditsScene)
            }
            
        }
        
        
        
    }
    
}