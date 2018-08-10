//
//  GameScene.swift
//  FlappyBird
//
//  Created by Admin on 06.08.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var bird = SKSpriteNode()
    var bg = SKSpriteNode()
    var topPipe = SKSpriteNode()
    var botPipe = SKSpriteNode()
    var gameOver = false
    
    enum ColliderType:UInt32 {
        case Bird = 1
        case Object = 2
    }
    
    @objc func makePips() {
        let gapHight = bird.size.height * 4
        let moveAmount = arc4random_uniform(UInt32(self.frame.height / 2))
        let pipeOffset = CGFloat(moveAmount) - self.frame.height / 4
        let pipsMove = SKAction.move(by: CGVector(dx: -2 * self.size.width, dy: 0), duration: TimeInterval        (self.size.width / 100))
        
        let topPipeTexture = SKTexture(imageNamed: "pipe1.png")
        topPipe = SKSpriteNode(texture: topPipeTexture)
        topPipe.position = CGPoint(x: self.frame.midX + self.size.width, y: self.frame.midY + topPipeTexture.size().height / 2 + gapHight / 2 + pipeOffset)
        topPipe.zPosition = 3
        topPipe.run(pipsMove)
        topPipe.physicsBody = SKPhysicsBody(rectangleOf: topPipeTexture.size())
        topPipe.physicsBody!.isDynamic = false
        topPipe.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        topPipe.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        topPipe.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        self.addChild(topPipe)
        
        let botPipeTexture = SKTexture(imageNamed: "pipe2.png")
        botPipe = SKSpriteNode(texture: botPipeTexture)
        botPipe.position = CGPoint(x: self.frame.midX + self.size.width, y: self.frame.midY - botPipeTexture.size().height / 2 - gapHight / 2 + pipeOffset)
        botPipe.zPosition = 3
        botPipe.physicsBody = SKPhysicsBody(rectangleOf: botPipeTexture.size())
        botPipe.physicsBody!.isDynamic = false
        botPipe.physicsBody!.collisionBitMask = ColliderType.Object.rawValue
        botPipe.physicsBody!.categoryBitMask = ColliderType.Object.rawValue
        botPipe.physicsBody!.contactTestBitMask = ColliderType.Object.rawValue
        botPipe.run(pipsMove)
        
        self.addChild(botPipe)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        self.speed = 0
        gameOver = true
    }
    
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        _ = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.makePips), userInfo: nil, repeats: true)
        
        let bgTexture = SKTexture(imageNamed: "bg.png")
        let moveBg = SKAction.move(by: CGVector(dx: -bgTexture.size().width, dy: 0), duration: 7)
        let moveBgShift = SKAction.move(by: CGVector(dx: bgTexture.size().width, dy: 0), duration: 0)
        let moveBgRepeat = SKAction.repeatForever(SKAction.sequence([moveBg, moveBgShift]))
        
        var i : CGFloat = 0
        while i < 3 {
            bg = SKSpriteNode(texture: bgTexture)
            bg.position = CGPoint(x: bgTexture.size().width * i, y: self.frame.midY)
            bg.size.height = self.frame.height
            bg.run(moveBgRepeat)
            bg.zPosition = 1
            self.addChild(bg)
            i += 1
        }
        
        
        
        let birdTexture1 = SKTexture(imageNamed: "flappy1.png")
        let birdTexture2 = SKTexture(imageNamed: "flappy2.png")
        
        let animation = SKAction.animate(with: [birdTexture1, birdTexture2], timePerFrame: 0.1)
        let flap = SKAction.repeatForever(animation)
        
        bird = SKSpriteNode(texture: birdTexture1)
        bird.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        bird.run(flap)
        bird.physicsBody = SKPhysicsBody(circleOfRadius: birdTexture1.size().height / 2)
        bird.physicsBody?.isDynamic = false
        bird.zPosition = 3
        bird.physicsBody?.collisionBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.categoryBitMask = ColliderType.Bird.rawValue
        bird.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        self.addChild(bird)
        
        let  ground = SKNode()
        ground.position = CGPoint(x: self.frame.midX - self.size.width, y: -self.size.height / 2)
        ground.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.size.width, height: 1))
        ground.physicsBody?.isDynamic = false
        ground.physicsBody?.collisionBitMask = ColliderType.Object.rawValue
        ground.physicsBody?.categoryBitMask = ColliderType.Object.rawValue
        ground.physicsBody?.contactTestBitMask = ColliderType.Object.rawValue
        self.addChild(ground)
        
        
        
    }
    
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if gameOver == false {
            bird.physicsBody!.isDynamic = true
            bird.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            bird.physicsBody!.applyImpulse(CGVector(dx: 0, dy: 100))
        }
    }
    
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
