//
//  Dinak.swift
//  Magic Forest The Battle
//
//  Created by Camila Ribeiro Rodrigues on 26/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit

class Dinak: Player {
	required init(position: CGPoint, screenSize: CGSize) {
		super.init(position: position, screenSize: screenSize)
		
		self.position = position
		
		self.life = 1_000
		self.energy = 100
		self.attackDamage = 100
		self.specialDamage = 200
		self.movementVelocity = CGVector(dx: 0, dy: 0)
		self.movementSpeed = 20
		self.jumpForce = 100_000
		self.defesa = 20 //defende 20% do dano
		self.attackSpeed = 2
		self.doubleJump = true
		//Porcentagem 10% e 1%
		self.regEnergy = 10
		self.regLife = 1
		self.getDownForce = -50_000
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func generatePhysicsBody() -> SKPhysicsBody {
		let physicsBody = SKPhysicsBody(rectangleOfSize: self.size)
		
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
		let repeateForever = SKAction.repeatActionForever(loadAnimation("idle", endIndex: 11, timePerFrame: 0.2))
		return repeateForever
	}
	
	/**
	Fazer a animação run repetir para sempre
	- returns: SKAction
	*/
	override func run () -> SKAction {
		let repeateForever = SKAction.repeatActionForever(self.loadAnimation("corre",endIndex: 8, timePerFrame: 0.2))
		return repeateForever
	}
	
	/**
	Fazer a animação hit
	- returns: SKAction
	*/
	override func hit () -> SKAction {
		return self.loadAnimation("hit", endIndex: 3, timePerFrame: 0.2)
	}
	
	/**
	Fazer a animação jump
	- returns: SKAction
	*/
	override func jump () -> SKAction {
		//return SKAction.repeatActionForever(self.loadAnimation("jump", endIndex: 2, timePerFrame: 0.5))
		return self.loadAnimation("jump", endIndex: 2, timePerFrame: 0.5)
	}
	
	/**
	Fazer a animação falling
	- returns: SKAction
	*/
	override func falling () -> SKAction {
		return self.loadAnimation("falling", endIndex: 3, timePerFrame: 0.3)
	}
	
	/**
	Fazer a animação attack
	- returns: SKAction
	*/
	override func attack () -> SKAction {
		return self.loadAnimation("Attack", endIndex: 3, timePerFrame: 0.1)
	}
	
	/**
	Fazer a animação attack special
	- returns: SKAction
	*/
	override func specialAttack() -> SKAction {
		return self.loadAnimation("SpecialAttack", endIndex: 2, timePerFrame: 0.3)
	}
	
	/**
	Fazer a animação death
	- returns: SKAction
	*/
	override func death() -> SKAction {
		return self.loadAnimation("Death", endIndex: 3, timePerFrame: 0.5)
	}
}
