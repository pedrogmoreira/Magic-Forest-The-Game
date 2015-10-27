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
		super.init(texture: nil, color: UIColor.blackColor(), size: CGSize(width: 50, height: 100))
		
		self.position = position
		
		self.life = 100
		self.energy = 100
		self.movementVelocity = CGVector(dx: 0, dy: 0)
		self.movementSpeed = 20
		self.jumpForce = 400
		self.state = PlayerState.Idle
		
		initializeAnimations()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}

	func initializeAnimations () {
		self.runAction(idle())
		self.runAction(run())
	}
	
	/**
	Gerar animação idle dos personagens
	- returns: SKAction
	*/

	func loadIdleAnimation () -> SKAction {
		var idleTextures = [SKTexture]()
		
		for i in 1...11 {
			idleTextures.append(SKTexture(imageNamed: "idle\(i)"))
		}
		let idle = SKAction.animateWithTextures(idleTextures, timePerFrame: 0.2)
		return idle
	}
	
	/**
	Fazer a animação do idle repetir para sempre
	- returns: SKAction
	*/
	
	func idle () -> SKAction {
		let repeateForever = SKAction.repeatActionForever(self.loadIdleAnimation())
		return repeateForever
	}
	/**
	Gerar animação run dos personagens
	- returns: SKAction
	*/
	func loadRunAnimation () -> SKAction {
		var runTextures = [SKTexture]()
		
		for i in 1...8{
			runTextures.append(SKTexture(imageNamed: "corre\(i)"))
		}
		let run = SKAction.animateWithTextures(runTextures, timePerFrame: 0.2)
		return run
	}
	
	/**
	Fazer a animação run repetir para sempre
	- returns: SKAction
	*/
	
	func run () -> SKAction {
		let repeateForever = SKAction.repeatActionForever(self.loadRunAnimation())
		return repeateForever
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
