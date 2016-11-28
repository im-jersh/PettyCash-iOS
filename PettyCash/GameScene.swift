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
    
    let pet = SKSpriteNode(imageNamed: "dog")
    lazy var backgroundGradientNode : SKSpriteNode = {
        let texture = SKTexture(size: self.size, color1: CIColor(color: UIColor.flatGreen()), color2: CIColor(color: UIColor.flatSkyBlue()), direction: GradientDirection.Up)
        texture.filteringMode = .linear
        let backgroundGradientNode = SKSpriteNode(texture: texture, size: self.frame.size)
        backgroundGradientNode.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        return backgroundGradientNode
    }()
    
    override func didMove(to view: SKView) {
        
        // Set the background
        self.backgroundColor = UIColor.flatWhite()
        
        // Add the gradient background node
        self.addChild(self.backgroundGradientNode)
        
        // Add the pet to the scene
        self.pet.position = CGPoint(x: random(min: 0 + (self.pet.size.width / 2.0), max: self.size.width - (self.pet.size.width / 2.0)), y: random(min: 0 + (self.pet.size.height / 2.0), max: (self.size.height / 2) - (self.pet.size.height / 2)))
        self.pet.zPosition = 100.0
        self.addChild(self.pet)
        
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
