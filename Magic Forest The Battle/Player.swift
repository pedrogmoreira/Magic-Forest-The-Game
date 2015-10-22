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
	
	/**
	Initializes the player
	- parameter position: The point where the player will apear
	*/
	required init(position: CGPoint) {
		super.init(texture: nil, color: UIColor.blackColor(), size: CGSize(width: 50, height: 100))
		
		self.position = position
		
		self.life = 100
		self.energy = 100
		self.movementVelocity = CGVector(dx: 0, dy: 0)
		self.movementSpeed = 2
		self.jumpForce = 400
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func update(currentTime: CFTimeInterval) {
		/* Called before each frame is rendered */
		let velocityX = movementVelocity!.dx * movementSpeed!
		let velocityY = movementVelocity!.dy * 0
		let move = SKAction.moveByX(velocityX, y: velocityY, duration: 0)
		self.runAction(move)
	}

	
	/**
	Generates a texture
	- parameter name: The image name for creating the texture
	- returns: SKTexture
	*/
	func generateTexture(name: String) -> SKTexture {
		return SKTexture(imageNamed: name)
	}
	
	/**
	Generates a physics body
	- returns: SKPhysicsBody
	*/
	func generatePhysicsBody() -> SKPhysicsBody {
		let physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
		
		physicsBody.categoryBitMask = 0
		physicsBody.contactTestBitMask = 0
		physicsBody.mass = 100
		physicsBody.affectedByGravity = true
		physicsBody.allowsRotation = false
		
		return physicsBody
	}
	
}
