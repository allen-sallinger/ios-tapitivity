//
//  StoreScene.swift
//  tapitivity
//
//  Created by ALLEN SALLINGER on 8/5/15.
//  Copyright (c) 2015 GSD. All rights reserved.
//

import Foundation
import SpriteKit

class StoreItem {
    var name = ""
    var cost = 0
    var imageName = ""
    var bought = false
    var toggleOn = false
    
    func printInfo(){
        println("Item \(name) cost \(cost) credits.")
        println("The image name is: \(imageName)")
        println("You have bought this item: \(bought)")
        println("Toggled on as current player: \(toggleOn)")
    }
    
    func setItem(newName:String, newCost:Int, newImageName:String, newBought:Bool, newToggleOn:Bool){
        self.name = newName
        self.cost = newCost
        self.imageName = newImageName
        self.bought = newBought
        self.toggleOn = newToggleOn
    }
    
    
}

class StoreScene: SKScene{
    // Holds all the store items
    var store : [StoreItem] = []
    
    // Create the store items
    var derp = StoreItem()
    var smiley = StoreItem()
    var starboy = StoreItem()
    
    // Testing label for store
    let derpLabel = SKLabelNode()
    let bg = SKSpriteNode(imageNamed: "background_small")
    let backLabel = SKLabelNode()
    let storeHello = SKLabelNode()
    
    override init(size: CGSize) {
        super.init(size: size)
        
        backgroundColor = SKColor.whiteColor()
        
    }
    
    override func didMoveToView(view: SKView) {
        
        // Code for the store
        derp.setItem("Derp", newCost:0, newImageName: "path_to_derp", newBought: true, newToggleOn: false)
        smiley.setItem("Smiley", newCost: 500, newImageName: "path_to_smiley", newBought: true, newToggleOn: false)
        starboy.setItem("Starboy", newCost: 750, newImageName: "path_to_startboy", newBought : true, newToggleOn: false)
        
        // Set items in store
        store.append(derp)
        store.append(starboy)
        store.append(smiley)
        
        // Insert Background
        addChild(bg)
        
        // Create the back button
        //let backLabel = SKLabelNode()
        backLabel.text = "Back"
        backLabel.position = CGPoint(x: size.width * 0.1, y: size.height * 0.95)
        backLabel.fontColor = SKColor.blackColor()
        addChild(backLabel)
        
        // Go through store list and create labels for store
        for var i = 0; i < store.count; ++i{
            addStoreLabel(store[i], index: i)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if let touch = touches.first as? UITouch{
            
            let touchLocation = touch.locationInNode(self)
            // Node that was touched
            let touchedNode = self.nodeAtPoint(touchLocation)
            
                        
            if(backLabel.containsPoint(touchLocation)){
                
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene)
                
            }
            
            // Checks to see which store label was touched.
            for item in store{
                
                if(item.name == touchedNode.name){
                    println("You touched the \(item.name)")
                }
                
                // If node is not already the current sprite node set to current node.
            }
            
        
        }
    }
    
    
    
    // function to generate the labels for the
    func addStoreLabel(item: StoreItem, index: Int){
        
        var width : CGFloat = 0.0
        var height = 0
        
        // Calculate the position for the label
        if( index % 2 == 0){
            width = 0.25
        } else {
            width = 0.75
        }
        
        height = index / 2
        
        var yHeight : CGFloat = 0.15
        for var i = 0; i < height; ++i{
            yHeight = yHeight + 0.15
        }
        
        
        
        let newLabel = SKLabelNode()
        
        newLabel.name = "\(item.name)"
        newLabel.text = item.name
        newLabel.fontColor = UIColor.blackColor()
        newLabel.zPosition = 1
        newLabel.position = CGPoint(x: size.width * width, y: size.height * (1 - yHeight))
        
        addChild(newLabel)
        
        // Set position for the label
    }

}