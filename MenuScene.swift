//
//  MenuScene.swift
//  SpaceGame
//
//  Created by Josue Rosales on 11/15/17.
//  Copyright © 2017 Josue Rosales. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    var starfield:SKEmitterNode!
    
    var newGameButtonNode:SKSpriteNode!
    var extra:SKLabelNode!
    
    override func didMove(to view: SKView) {
        starfield = self.childNode(withName: "starfield") as! SKEmitterNode
        starfield.advanceSimulationTime(10)
        
        newGameButtonNode = self.childNode(withName: "newGameButton") as! SKSpriteNode //shows what to use
        newGameButtonNode.texture = SKTexture(imageNamed: "newGameButton") //changes the texture
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        
        if let location = touch?.location(in: self) {
            let nodesArray = self.nodes(at: location)
            
            if nodesArray.first?.name == "newGameButton" {
                let transition = SKTransition.flipHorizontal(withDuration: 0.5)
                let gameScene = GameScene(size: self.size)
                self.view?.presentScene(gameScene, transition: transition)
            } else if nodesArray.first?.name == "extra" {
                //Make a new scene
            }
        }
    }
    
}
