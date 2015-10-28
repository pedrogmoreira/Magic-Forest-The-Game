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
	required init(position: CGPoint) {
		super.init(position: position)
		
		self.position = position
		
		self.life = 100
		self.energy = 100
		self.movementVelocity = CGVector(dx: 0, dy: 0)
		self.movementSpeed = 10
		self.jumpForce = 100000
		
		self.runAction(SKAction.repeatActionForever(self.jump()))
//		self.changeState(PlayerState.Jump)
		//initializeAnimations()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
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
	
	
	func idle () -> SKAction {
		
		let repeateForever = SKAction.repeatActionForever(loadAnimation("idle", endIndex: 11, timePerFrame: 0.2))
		return repeateForever
	}
	
	/**
	Fazer a animação run repetir para sempre
	- returns: SKAction
	*/
	
	func run () -> SKAction {
		let repeateForever = SKAction.repeatActionForever(self.loadAnimation("corre",endIndex: 8, timePerFrame: 0.2))
		return repeateForever
	}
	
	/**
	Fazer a animação hit
	- returns: SKAction
	*/
	func hit () -> SKAction {
		return self.loadAnimation("hit", endIndex: 3, timePerFrame: 0.2)
	}
	
	/**
	Fazer a animação hit
	- returns: SKAction
	*/
	func jump () -> SKAction {
		//return SKAction.repeatActionForever(self.loadAnimation("jump", endIndex: 2, timePerFrame: 0.5))
		return self.loadAnimation("jump", endIndex: 2, timePerFrame: 0.5)
	}
	/**
	Fazer a animação falling
	- returns: SKAction
	*/
	func falling () -> SKAction {
		return self.loadAnimation("falling", endIndex: 3, timePerFrame: 0.3)
	}
	/**
	Fazer a animação attack
	- returns: SKAction
	*/
	func attack () -> SKAction {
		return self.loadAnimation("Attack", endIndex: 4, timePerFrame: 0.2)
	}
	
	override func changeState(state: PlayerState) {
		
		
		if self.state != state {
			self.state = state
			
			switch (self.state!) {
			case PlayerState.Running:
				self.runAction(run())
			case PlayerState.Idle:
				self.runAction(idle())
			case PlayerState.Jump:
				self.runAction(jump())
			case PlayerState.Falling:
				self.runAction(falling())
			default:
				self.runAction(idle())
			}
		}
	}
	
}

