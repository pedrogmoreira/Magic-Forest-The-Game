//
//  Uhong.swift
//  Magic Forest The Battle
//
//  Created by Camila Ribeiro Rodrigues on 26/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit

class Uhong: Player {
	required init(position: CGPoint, screenSize: CGSize) {
		super.init(position: position, screenSize: screenSize)
		
		self.position = position
	
		self.life = 1_500
		self.currentLife = 1_500
		self.energy = 100
		self.currentEnergy = 100
		self.attackDamage = 100
		self.specialDamage = 200
		self.movementVelocity = CGVector(dx: 0, dy: 0)
		self.movementSpeed = 10
		self.jumpForce = 100_000
		self.defesa = 30 //Defende 30% do dano
		self.attackSpeed = 1
		self.doubleJump = false
		//Porcentagem 10% e 1%
		self.regEnergy = 10
		self.regLife = 1
		self.getDownForce = -50_000
		//self.anchorPoint = CGPointMake(self.anchorPoint.x, self.anchorPoint.y-0.25)
		
		self.setScale(4)
		
		//initializeAnimations()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	override func generatePhysicsBody() -> SKPhysicsBody {
		let physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.size.width/2, self.size.height/2), center: CGPointMake(0, -self.size.height/4))
		
		physicsBody.categoryBitMask = PhysicsCategory.Player.rawValue
		physicsBody.collisionBitMask = BITMASK_BASE_FLOOR
		physicsBody.contactTestBitMask = 0
		physicsBody.mass = 100
		physicsBody.affectedByGravity = true
		physicsBody.allowsRotation = false
		
		return physicsBody
	}
	
	// MARK: Animations
	
	func initializeAnimations () {
		//testar animacoes
		self.runAction(hit())
	}
	
	
	/**
	Fazer a animação do idle repetir para sempre
	- returns: SKAction
	*/
	override func idle () -> SKAction {
		let repeateForever = SKAction.repeatActionForever(loadAnimation("CogumeloParado", endIndex: 10, timePerFrame: 0.08))
		return repeateForever
	}
	
	/**
	Fazer a animação run repetir para sempre
	- returns: SKAction
	*/
	override func run () -> SKAction {
		let repeateForever = SKAction.repeatActionForever(self.loadAnimation("CogumeloAndando",endIndex: 10, timePerFrame: 0.1))
		return repeateForever
	}
	
	/**
	Fazer a animação hit
	- returns: SKAction
	*/
	override func hit () -> SKAction {
		return self.loadAnimation("CogumeloHit", endIndex: 1, timePerFrame: 0.08)
	}
	
	/**
	Fazer a animação jump
	- returns: SKAction
	*/
	override func jump () -> SKAction {
		//return SKAction.repeatActionForever(self.loadAnimation("jump", endIndex: 2, timePerFrame: 0.1))
		return self.loadAnimation("CogumeloSubindo", endIndex: 1, timePerFrame: 0.25)
	}
	
	/**
	Fazer a animação falling
	- returns: SKAction
	*/
	override func falling () -> SKAction {
		return self.loadAnimation("CogumeloSubindodescendo", endIndex: 2, timePerFrame: 0.25)
	}
	
	/**
	Fazer a animação attack
	- returns: SKAction
	*/
	override func attack () -> SKAction {
		return self.loadAnimation("CogumeloAtaque", endIndex: 10, timePerFrame: 0.03)
	}
	
	/**
	Fazer a animação attack special
	- returns: SKAction
	*/
	override func specialAttack() -> SKAction {
		return self.loadAnimation("CogumeloEspecial", endIndex: 10, timePerFrame: 0.03)
	}
	
	/**
	Fazer a animação death
	- returns: SKAction
	*/
	override func death() -> SKAction {
		return self.loadAnimation("CogumeloHit", endIndex: 1, timePerFrame: 0.25)
	}

}