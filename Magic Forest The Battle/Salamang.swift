//
//  Salamang.swift
//  Magic Forest The Battle
//
//  Created by Camila Ribeiro Rodrigues on 26/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit
class Salamang: Player {
	required init(position: CGPoint, screenSize: CGSize) {
		super.init(position: position, screenSize: screenSize)
		
		self.position = position
		
		self.life = 1_000
		self.currentLife = 1_000
		self.energy = 100
		self.currentEnergy = 100
		self.attackDamage = 150
		self.specialDamage = 200
		self.movementVelocity = CGVector(dx: 0, dy: 0)
		self.movementSpeed = 10
		self.jumpForce = 100_000
		self.defesa = 20 //Defende 20% do dano
		self.attackSpeed = 1
		//Porcentagem 10% e 1%
		self.regEnergy = 10
		self.regLife = 1
		self.getDownForce = -50_000
		self.setScale(4)
		
		self.isRanged = true
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	override func generatePhysicsBody() -> SKPhysicsBody {
		let size = CGSize(width: self.size.width * 0.3, height: self.size.height * 0.45)
		let physicsBody = SKPhysicsBody(rectangleOfSize: size, center: CGPointMake(0, -size.height / 3))
		
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
		let repeateForever = SKAction.repeatActionForever(loadAnimation("SalamangParado", endIndex: 10, timePerFrame: 0.08))
		return repeateForever
	}
	
	/**
	Fazer a animação run repetir para sempre
	- returns: SKAction
	*/
	override func run () -> SKAction {
		let repeateForever = SKAction.repeatActionForever(self.loadAnimation("SalamangAndando",endIndex: 10, timePerFrame: 0.1))
		return repeateForever
	}
	
	/**
	Fazer a animação hit
	- returns: SKAction
	*/
	override func hit () -> SKAction {
		return self.loadAnimation("SalamangHit", endIndex: 1, timePerFrame: 0.08)
	}
	
	/**
	Fazer a animação jump
	- returns: SKAction
	*/
	override func jump () -> SKAction {
		//return SKAction.repeatActionForever(self.loadAnimation("jump", endIndex: 2, timePerFrame: 0.1))
		return self.loadAnimation("SalamangPulando", endIndex: 1, timePerFrame: 0.25)
	}
	
	/**
	Fazer a animação falling
	- returns: SKAction
	*/
	override func falling () -> SKAction {
		return self.loadAnimation("SalamangCaindo", endIndex: 3, timePerFrame: 0.25)
	}
	
	/**
	Fazer a animação attack
	- returns: SKAction
	*/
	override func attack () -> SKAction {
		return self.loadAnimation("SalamangAtacando", endIndex: 10, timePerFrame: 0.03)
	}
	
	/**
	Fazer a animação attack special
	- returns: SKAction
	*/
	override func specialAttack() -> SKAction {
		return self.loadAnimation("SalamangEspecial", endIndex: 9, timePerFrame: 0.03)
	}
	
	/**
	Fazer a animação death
	- returns: SKAction
	*/
	override func death() -> SKAction {
		return self.loadAnimation("SalamangHit", endIndex: 1, timePerFrame: 0.25)
	}
	
	override func createProjectile() -> Projectile {
		let jujuba = Jujuba(position: self.position)
		return jujuba
	}
}
