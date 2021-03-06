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
	
	var meleeBox: SKSpriteNode?
	var specialBox: SKSpriteNode?
	
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
		//Porcentagem 10% e 1%
		self.regEnergy = 10
		self.regLife = 1
		self.getDownForce = -50_000
		//self.anchorPoint = CGPointMake(self.anchorPoint.x, self.anchorPoint.y-0.25)
		
		self.isRanged = false
		
		self.setScale(4)
		
//		if self.isMyPlayer {
//		
//			self.generateMeleeBox()
//	//		self.generateSpecialBox()
//		}
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func generateMeleeBox() {
		self.meleeBox = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: self.size.width / 8, height: self.size.height / 32))
		self.meleeBox!.alpha = 0
		
		let physicsBody = SKPhysicsBody(rectangleOfSize: self.meleeBox!.size)
		physicsBody.categoryBitMask = PhysicsCategory.MeleeBox.rawValue
		physicsBody.collisionBitMask = 0
		physicsBody.contactTestBitMask = PhysicsCategory.OtherPlayer.rawValue | PhysicsCategory.Enemy.rawValue
		physicsBody.mass = 0
		physicsBody.affectedByGravity = false
		physicsBody.allowsRotation = false
		physicsBody.usesPreciseCollisionDetection = true
		
		self.meleeBox!.physicsBody = physicsBody
		
		self.addChild(self.meleeBox!)
	}
	
	func generateSpecialBox() {
		self.specialBox = SKSpriteNode(color: UIColor.blueColor(), size: CGSize(width: self.size.width / 5, height: self.size.height / 5))
		self.specialBox!.alpha = 0
		
		let physicsBody = SKPhysicsBody(rectangleOfSize: self.specialBox!.size)
		physicsBody.categoryBitMask = PhysicsCategory.SpecialBox.rawValue
		physicsBody.collisionBitMask = 0
		physicsBody.contactTestBitMask = PhysicsCategory.OtherPlayer.rawValue | PhysicsCategory.Enemy.rawValue
		physicsBody.mass = 0
		physicsBody.affectedByGravity = false
		physicsBody.allowsRotation = false
		
		self.specialBox!.physicsBody = physicsBody
		
		self.addChild(self.specialBox!)
	}
	
	override func generatePhysicsBody() -> SKPhysicsBody {
		let physicsBody = SKPhysicsBody(rectangleOfSize: CGSizeMake(self.size.width / 4, self.size.height / 2), center: CGPointMake(0, -self.size.height / 4))
		
		physicsBody.categoryBitMask = PhysicsCategory.Player.rawValue
		physicsBody.collisionBitMask = BITMASK_BASE_FLOOR
		physicsBody.contactTestBitMask = BITMASK_BASE_FLOOR | PhysicsCategory.DeathBox.rawValue | PhysicsCategory.Projectile.rawValue
		physicsBody.mass = 100
        physicsBody.restitution = 0
		physicsBody.affectedByGravity = true
		physicsBody.allowsRotation = false
		
		return physicsBody
	}
    
    /**
     Checks wheather the player can colide with floors
     */
    override func checkFloorLevel() {
		let deadZoneFirstFloor = (BackgroundLayer.firstFloor?.position.y)! + ((BackgroundLayer.firstFloor?.size.height)! * 0.4) / 2
		let deadZoneSecondFloor = (BackgroundLayer.secondFloor?.position.y)! + ((BackgroundLayer.secondFloor?.size.height)! * 0.4) / 2
		let deadZoneThridFloor = (BackgroundLayer.thirdFloor?.position.y)! + ((BackgroundLayer.thirdFloor?.size.height)! * 0.4) / 2
		
		let playerFoot = self.position.y - (self.size.height / 2) * 0.8
		
		if self.isMyPlayer {
			if playerFoot >= deadZoneThridFloor {
				self.physicsBody?.collisionBitMask = BITMASK_THIRD_FLOOR
				self.physicsBody?.contactTestBitMask = BITMASK_THIRD_FLOOR
			} else if playerFoot >= deadZoneSecondFloor {
				self.physicsBody?.collisionBitMask = BITMASK_SECOND_FLOOR
				self.physicsBody?.contactTestBitMask = BITMASK_SECOND_FLOOR
			} else if playerFoot >= deadZoneFirstFloor {
				self.physicsBody?.collisionBitMask = BITMASK_FIRST_FLOOR
				self.physicsBody?.contactTestBitMask = BITMASK_FIRST_FLOOR
			} else {
				self.physicsBody?.collisionBitMask = BITMASK_BASE_FLOOR
				self.physicsBody?.contactTestBitMask = BITMASK_BASE_FLOOR
			}
		} else {
			if playerFoot >= deadZoneThridFloor {
				self.physicsBody?.collisionBitMask = BITMASK_THIRD_FLOOR
				self.physicsBody?.contactTestBitMask = BITMASK_THIRD_FLOOR | PhysicsCategory.MeleeBox.rawValue
			} else if playerFoot >= deadZoneSecondFloor {
				self.physicsBody?.collisionBitMask = BITMASK_SECOND_FLOOR
				self.physicsBody?.contactTestBitMask = BITMASK_SECOND_FLOOR | PhysicsCategory.MeleeBox.rawValue
			} else if playerFoot >= deadZoneFirstFloor {
				self.physicsBody?.collisionBitMask = BITMASK_FIRST_FLOOR
				self.physicsBody?.contactTestBitMask = BITMASK_FIRST_FLOOR | PhysicsCategory.MeleeBox.rawValue
			} else {
				self.physicsBody?.collisionBitMask = BITMASK_BASE_FLOOR
				self.physicsBody?.contactTestBitMask = BITMASK_BASE_FLOOR | PhysicsCategory.MeleeBox.rawValue
			}
		}
    }
	
	override func update(currentTime: CFTimeInterval) {
		super.update(currentTime)
		
		if self.isMyPlayer == true {
			self.meleeBox!.position = CGPoint(x: self.meleeBox!.size.width/4, y: -self.meleeBox!.size.height * 2.5)
			self.specialBox!.position = CGPoint.zero
		}
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
		return self.loadAnimation("CogumeloHit", endIndex: 1, timePerFrame: 0.4)
	}
	
	/**
	Fazer a animação jump
	- returns: SKAction
	*/
	override func jump () -> SKAction {
		return self.loadAnimation("CogumeloSubindo", endIndex: 1, timePerFrame: 0.6)
	}
	
	/**
	Fazer a animação falling
	- returns: SKAction
	*/
	override func falling () -> SKAction {
		return self.loadAnimation("CogumeloDescendo", endIndex: 3, timePerFrame: 0.2)
	}
	
	/**
	Fazer a animação attack
	- returns: SKAction
	*/
	override func attack () -> SKAction {
		DMTSoundPlayer.sharedPlayer().playSoundEffect(DMTSoundPlayer.sharedPlayer().sounds[1])
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
    
    override func createProjectile() -> Projectile {
        let projectile = Projectile()
        return projectile
    }

    override func createLifeBar () {
        self.lifeBar = SKSpriteNode(imageNamed: "UI_COLORBAR_RED")
        self.lifeBar.setScale(0.01)
        self.lifeBar.yScale = 0.02
        self.lifeBar.position = CGPoint(x: -5.2 , y: -self.size.height*0.135)
        self.lifeBar.anchorPoint = CGPointMake(0, self.lifeBar.anchorPoint.y)
        lifeBar.zPosition = 0
        self.addChild(self.lifeBar)
    }
}