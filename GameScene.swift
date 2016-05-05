//
//  GameScene.swift
//  tapitivity
//
//  Created by ALLEN SALLINGER on 7/1/15.
//  Copyright (c) 2015 GSD. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // Add background
    let bg = SKSpriteNode(imageNamed: "background_small")
    
    // Initializing Smiley for the app
    let player = SKSpriteNode(imageNamed: "smiley_small")
    //let player = SKSpriteNode(imageNamed: "player")
    let coinLabel = SKLabelNode(text: "Coins: 0")
    let waterLabel = SKLabelNode(text: "Water: 30")
    let storeLabel = SKSpriteNode(imageNamed: "store_btn")
    let startLabel = SKSpriteNode(imageNamed: "start_btn")
    
    // Initialize the music
    var gameMusic = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("background-music", ofType: "mp3")!), fileTypeHint: nil)
    
    // Initialization for the water
    var waterCount = 30
    
    var coinsHit = 0
    
    var musicEnabled = true
    
    struct PhysicsCategory {
        static let None        :    UInt32 = 0
        static let All         :    UInt32 = UInt32.max
        static let Player      :    UInt32 = 0b1        // 1
        static let Coin        :    UInt32 = 0b10       // 2
    }
    
    
    override func didMoveToView(view: SKView) {
        // Loads the background
        addChild(bg)
        
        // Boxes in the player so that they do not leave the screen.
        let borderBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        borderBody.friction = 0
        self.physicsBody = borderBody
        
        let defaults = NSUserDefaults.standardUserDefaults()
        coinsHit = defaults.integerForKey(COINS_HIT)
        coinLabel.text = "Coins: \(coinsHit)"
    
        backgroundColor = SKColor.whiteColor()
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.9)
        player.physicsBody?.allowsRotation = false
        
        // Initialize coin label
        coinLabel.fontSize = 20
        coinLabel.fontColor = UIColor.blackColor()
        coinLabel.position = CGPointMake(size.width * 0.15, size.height * 0.05)
        
        // Initialize water label
        waterLabel.fontSize = 20
        waterLabel.fontColor = UIColor.blueColor()
        waterLabel.position = CGPointMake(size.width * 0.85, size.height * 0.05)
        
        // Initialize store button
        storeLabel.position = CGPointMake(size.width * 0.4, size.height * 0.05)
        
        // Set options button
        startLabel.position = CGPointMake(size.width * 0.6, size.height * 0.05)
        
        //Play the background music
        playBGMusic()
        
        addChild(player)
        addChild(coinLabel)
        addChild(waterLabel)
        addChild(storeLabel)
        addChild(startLabel)
        
        physicsWorld.gravity = CGVectorMake(0, -2.3)
        physicsWorld.contactDelegate = self
        
        // Physics initialization for the player
        player.physicsBody = SKPhysicsBody(rectangleOfSize: player.size)
        //player.physicsBody?.dynamic = true
        
        player.physicsBody?.categoryBitMask = PhysicsCategory.Player
        player.physicsBody?.contactTestBitMask = PhysicsCategory.Coin
        // What broke the boundaries
        //player.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        // Generates the water
        generateWater()
        
        runAction(SKAction.repeatActionForever(
            SKAction.sequence([
            SKAction.runBlock(addCoin),
            SKAction.waitForDuration(1.0)
            ])
        ))
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if let touch = touches.first as? UITouch{
            
            let touchLocation = touch.locationInNode(self)
            
            if(storeLabel.containsPoint(touchLocation)){
                print("You entered the store.")
                // Add show store function here.
                
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let storeScene = StoreScene(size: self.size)
                gameMusic.stop()
                self.view?.presentScene(storeScene)
                
            }
                
            if(startLabel.containsPoint(touchLocation)){
                
                print("Entered the options menu")
                
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let startScene = StartScene(size: self.size)
                gameMusic.stop()
                self.view?.presentScene(startScene)
                
            }
            
            else if(waterCount > 0){
                
                // Sets impulse parameters for the tap
                if(touchLocation.x < player.position.x){
                    player.physicsBody?.applyImpulse(CGVector(dx: -50.0, dy: 200.0))
                } else{
                    player.physicsBody?.applyImpulse(CGVector(dx: 50.0, dy: 200))
                }
                
                updateWater()
                
            } else{
                print("You are out of water.")
            }
        }
        
        
        
    }
    
    // Random gernerating function
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    // Generates random number to get a random Y position for the coin
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addCoin() {
        // Create sprite of the coin
        let coin = SKSpriteNode(imageNamed: "coin")
        
        // Setting up the contact interface for the player
        coin.physicsBody = SKPhysicsBody(circleOfRadius: coin.size.width/2)
        coin.physicsBody?.dynamic = true
        coin.physicsBody?.categoryBitMask = PhysicsCategory.Coin
        //coin.physicsBody?.contactTestBitMask = PhysicsCategory.Player
        coin.physicsBody?.collisionBitMask = PhysicsCategory.None
        
        
        let actualY = random(min: (size.height * 0.5) - coin.size.height/2, max: size.height - coin.size.height)
        
        coin.position = CGPoint(x: size.width + coin.size.width/2, y: actualY)
        
        // Add coin to the scene
        addChild(coin)
        
        // Duration for time to float across the screen
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the action for the coin
        let actionMove = SKAction.moveTo(CGPoint(x: -coin.size.width/2, y: actualY), duration: NSTimeInterval(actualDuration))
        
        // Initializing the actions for the coin
        let actionMoveDone = SKAction.removeFromParent()
        coin.runAction(SKAction.sequence([actionMove, actionMoveDone]))
    
    }
    
    func playerDidCollideWithCoin (coin: SKSpriteNode){
        updateCoins()
        coin.removeFromParent()
        print(coinsHit)
    }
    
    func didBeginContact(contact: SKPhysicsContact) {

        var firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        // Checks for the coin and then removes it
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyB
            playerDidCollideWithCoin(firstBody.node as! SKSpriteNode)
        }
    
    }
    
    func generateWater() {
        let waitForWater = SKAction.waitForDuration(3.0);
        let addWaterPoint = SKAction.runBlock{
            self.waterCount++
            self.waterLabel.text = "Water: \(self.waterCount)"
        }
        
        self.runAction(SKAction.repeatActionForever(SKAction.sequence([waitForWater, addWaterPoint])))
        
    }
    
    func updateWater() {
        waterCount--
        waterLabel.text = "Water: \(waterCount)"
    }
    
    func updateCoins() {
        coinsHit += 1
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(coinsHit, forKey: COINS_HIT)
        coinLabel.text = "Coins: \(coinsHit)"
    }

    func playBGMusic() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(musicEnabled, forKey: "musicEnabled")
        
        if(musicEnabled == true){
            gameMusic.numberOfLoops = -1
            gameMusic.play()
        }
    }
    
}

    

