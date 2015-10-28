//
//  Player.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class Player: SKSpriteNode, GameObject {
	
	var life: CGFloat?
	var energy: CGFloat?
	var movementVelocity: CGVector?
	var movementSpeed: CGFloat?
	var jumpForce: CGFloat?
	var state: PlayerState?
	
	/**
	Initializes the player
	- parameter position: The point where the player will apear
	*/
	required init(position: CGPoint) {
        let playerTexture = SKTexture(imageNamed: "sonic")
        
		super.init(texture: playerTexture, color: UIColor.blackColor(), size: CGSize(width: 50, height: 100))
		
		self.position = position
		
        self.setBasicAttributes()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	
	func update(currentTime: CFTimeInterval) {
		/* Called before each frame is rendered */
		let velocityX = movementVelocity!.dx * movementSpeed!
		let velocityY = movementVelocity!.dy * 0
		
		
		if velocityX != 0 {
			let move = SKAction.moveByX(velocityX, y: velocityY, duration: 0)
			
			self.changeState(PlayerState.Running)
			
			self.runAction(move)
		} else {
			self.changeState(PlayerState.Idle)
		}
		
	}

	/**
	Gerar animação dos personagens
	- parameter: name: animation's name endIndex: The amount of sprites timePerFrame: The amount of time that each texture is displayed.
	- returns: SKAction
	*/
	func loadAnimation (name: String, endIndex: Int, timePerFrame: NSTimeInterval) -> SKAction {
		var animationTextures = [SKTexture]()
		
		for i in 1...endIndex {
			animationTextures.append(SKTexture(imageNamed: name + "\(i)"))
		}
		let animation = SKAction.animateWithTextures(animationTextures, timePerFrame: timePerFrame)
		return animation
	}
	
    
    /**
     Generates basic attributes
     */
    func setBasicAttributes() {
        self.physicsBody = self.generatePhysicsBody()
        
        self.life = 100
        self.energy = 100
        self.movementVelocity = CGVector(dx: 0, dy: 0)
        self.movementSpeed = 90
        self.jumpForce = 400
    }
	
	/**
	Generates a physics body
	- returns: SKPhysicsBody
	*/
	func generatePhysicsBody() -> SKPhysicsBody {
		let physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
		
        physicsBody.categoryBitMask = PhysicsCategory.Player.rawValue
		physicsBody.contactTestBitMask = 0
		physicsBody.mass = 100
		physicsBody.affectedByGravity = true
		physicsBody.allowsRotation = false
		
		return physicsBody
	}
	
	func changeState(state: PlayerState) {
		//Override
		
	}

	
}
