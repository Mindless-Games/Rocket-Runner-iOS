//
//  GameScene.swift
//  SpaceGame
//
//  Created by Josue Rosales on 11/13/17.
//  Copyright © 2017 Josue Rosales. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion
import CoreGraphics

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var obstacleArray:Array<Any>!
    
    var starfield:SKEmitterNode!
    var fire: SKEmitterNode!
    
    var player:SKSpriteNode!
    var playerXSize:Int!
    var playerYSize:Int!
    var yPos:CGFloat = 250
    
    var obstacle:SKSpriteNode!
    
    var loseLabel:SKLabelNode!
    
    var scoreLabel:SKLabelNode!
    var score:Int = 0 {
        didSet{
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    let motionManager = CMMotionManager() //in charge of accelerometer settings
    var xAcceleration:CGFloat = 0 //acceleration values
    //var yAcceleration:CGFloat = 0  **OPTIONAL, ONLY FOR Y MOVEMENT**
    
    var gameTimer:Timer!
    var possibleObstacles = ["obstacle"]
    let obstacleCategory:UInt32 = 0x1 << 1
    
    override func didMove(to view: SKView) {
        starfield = SKEmitterNode(fileNamed: "starfield")
        starfield.position = CGPoint(x: frame.size.width/2, y: frame.size.height)
        starfield.advanceSimulationTime(10)
        starfield.zPosition = -1
        self.addChild(starfield)
        
        fire = SKEmitterNode(fileNamed: "Fire") //initialliezes particle
        fire.position = CGPoint(x: 70, y: yPos + 20)
        fire.advanceSimulationTime(10)
        self.addChild(fire) //adds particle to scene
        
        fire.zPosition = 0 //makes sure particle is always behind everything
        
        player = SKSpriteNode(imageNamed: "shuttle")
        player.position = CGPoint(x: 70, y: yPos + player.size.height)
        self.addChild(player)
        
        player.zPosition = 1
        playerXSize = Int(player.size.width + player.position.x)
        playerYSize = Int(player.size.height + yPos)
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        self.physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.position = CGPoint(x: 150, y: self.frame.size.height - 100)
        scoreLabel.fontName = "Didot-Bold"
        scoreLabel.fontSize = 64
        scoreLabel.fontColor = UIColor.white
        score = 0

        self.addChild(scoreLabel)
        
        gameTimer = Timer.scheduledTimer(timeInterval: 0.95, target: self, selector: #selector(addObstacle), userInfo: nil, repeats: true)
        
    /* OLD STUFF TO MAKE OBJECT MOVE AND APPEAR
        obstacle = SKSpriteNode(imageNamed: "obstacle")
        obstacle.position = CGPoint(x: 70, y: frame.size.height / 2)
        self.addChild(obstacle)
        let moveObstacle = SKAction.moveTo(y: 100, duration: 10)
        obstacle.run(moveObstacle)
    */
        
        
        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: OperationQueue.current!) { (data:CMAccelerometerData?, error:Error?) in
            if let accelerometerData = data {
                let acceleration = accelerometerData.acceleration
                self.xAcceleration = CGFloat(acceleration.x) * 0.75 + self.xAcceleration * 0.25
                //self.yAcceleration = CGFloat(acceleration.y) * 0.75 + self.yAcceleration * 0.25  **OPTIONAL, ONLY FOR Y MOVEMENT**
            }
        }
        
    }
    
    @objc func addObstacle () {
        possibleObstacles = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: possibleObstacles) as! [String]
        obstacle = SKSpriteNode(imageNamed: possibleObstacles[0])
        
        let randomObstaclePosition = GKRandomDistribution(lowestValue: 0, highestValue: Int(frame.size.width))
        let position = CGFloat(randomObstaclePosition.nextInt())
        
        obstacle.position = CGPoint(x: position, y: self.frame.size.height + obstacle.size.height)
        obstacle.physicsBody = SKPhysicsBody(rectangleOf: obstacle.size)
        obstacle.physicsBody?.isDynamic = true
        
        obstacle.physicsBody?.categoryBitMask = obstacleCategory
        obstacle.physicsBody?.collisionBitMask = 0
        
        self.addChild(obstacle)
        let animationDuration:TimeInterval = 6
        
        var actionArray = [SKAction]()
        
        actionArray.append(SKAction.move(to: CGPoint(x: position, y: -obstacle.size.height), duration: animationDuration))
        actionArray.append(SKAction.removeFromParent())
        
        obstacle.run(SKAction.sequence(actionArray))
    }
    
    override func didSimulatePhysics() {
        player.position.x += xAcceleration * 50
        //player.position.y += yAcceleration * 50  **OPTIONAL, ONLY FOR Y MOVEMENT**
        
        fire.position.x += xAcceleration * 50
        //fire.position.y += yAcceleration * 50  **OPTIONAL, ONLY FOR Y MOVEMENT**
/* OLD COLLISION DETECTION
        if Int(obstacle.position.y) == 250 { //Works with just yPos, haven't done xPos yet..
            loseLabel = SKLabelNode(text: "You Lose!")
            loseLabel.position = CGPoint(x: frame.size.width / 2, y: frame.size.height / 2)
            loseLabel.fontName = "Didot-Bold"
            loseLabel.fontSize = 64
            loseLabel.fontColor = UIColor.white
            loseLabel.zPosition = 1
            self.addChild(loseLabel)
        }
 */
        
        if player.position.x < -20 {
            player.position = CGPoint(x: self.size.width + 20, y: player.position.y)
            fire.position = CGPoint(x: self.size.width + 20, y: fire.position.y)
        } else if player.position.x > self.size.width + 20 {
            player.position = CGPoint(x: -20, y: player.position.y)
            fire.position = CGPoint(x: -20, y: fire.position.y)
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
