//
//  GameScene.swift
//  PettyCash
//
//  Created by Joshua O'Steen on 9/8/16.
//  Copyright (c) 2016 Joshua O'Steen. All rights reserved.
//

import SpriteKit
import ChameleonFramework

func random() -> CGFloat {
    return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
}

func random(min: CGFloat, max: CGFloat) -> CGFloat {
    return random() * (max - min) + min
}

class GameScene: SKScene {
    
    lazy var pet : SKSpriteNode = {
        let pet = SKSpriteNode(imageNamed: "dog")
        pet.zPosition = 100.0
        
        return pet
    }()
    
    lazy var backgroundGradientNode : SKSpriteNode = {
        let texture = SKTexture(imageNamed: "pet-background")
        texture.filteringMode = .nearest
        let backgroundGradientNode = SKSpriteNode(texture: texture, size: self.frame.size)
        backgroundGradientNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        return backgroundGradientNode
    }()
    
    lazy var shelter : SKSpriteNode = {
        let shelter = SKSpriteNode(imageNamed: "dog-house")
        shelter.position = CGPoint(x: shelter.size.width * 0.58, y: self.frame.size.height * 0.46)
        shelter.zPosition = 90.0
        return shelter
    }()
    
    lazy var foodBowl : SKSpriteNode = {
        let bowl = SKSpriteNode(imageNamed: "food")
        bowl.position = CGPoint(x: self.frame.size.width * 0.78, y: self.frame.size.height * 0.41)
        bowl.zPosition = 93.0
        return bowl
    }()
    
    lazy var waterBowl : SKSpriteNode = {
        let bowl = SKSpriteNode(imageNamed: "water")
        bowl.position = CGPoint(x: self.frame.size.width * 0.86, y: self.frame.size.height * 0.43)
        bowl.zPosition = 92.0
        return bowl
    }()
    
    override func didMove(to view: SKView) {
        
        // Set the background
        self.backgroundColor = UIColor.flatWhite()
        
        // Add the gradient background node
        self.addChild(self.backgroundGradientNode)
        
        // Add the pet to the scene
        self.pet.position = CGPoint(x: random(min: 0 + (self.pet.size.width / 2.0), max: self.size.width - (self.pet.size.width / 2.0)), y: random(min: 0 + (self.pet.size.height / 2.0), max: (self.size.height / 2) - (self.pet.size.height / 2)))
        self.addChild(self.pet)
        
        // Add the pet house
        self.addChild(self.shelter)
        self.addChild(self.foodBowl)
        self.addChild(self.waterBowl)
        
        // Make the little guy move around from time to time
        self.run(
            SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.wait(forDuration: 9.0),
                    SKAction.run(movePetRandom)
                ])
            )
        )
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
       /* Called when a touch begins */
    }
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    func movePetRandom() {
        // Pick a random x and y coordinate
        let randX = random(min: 0 + (self.pet.size.width / 2.0), max: self.size.width - (self.pet.size.width / 2.0))
        let randY = random(min: 0 + (self.pet.size.height / 2.0), max: (self.size.height / 2) - (self.pet.size.height / 2))
        let randPoint = CGPoint(x: randX, y: randY)
        print(randPoint)
        
        self.movePet(to: randPoint)
    }
    
    func movePet(to point: CGPoint) {
        let moveAction = SKAction.move(to: point, duration: TimeInterval(random(min: 1.8, max: 3.0)))
        self.pet.run(moveAction)
    }
    
}
