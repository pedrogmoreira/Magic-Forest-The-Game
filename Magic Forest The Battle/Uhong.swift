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
		self.movementSpeed = 2
		self.jumpForce = 400
		initializeAnimations()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: Animations
	
	func initializeAnimations () {
		self.runAction(idle())
		self.runAction(run())
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
	
	override func changeState(state: PlayerState) {
		if self.state != state {
			self.state = state
			
			switch (self.state!) {
			case PlayerState.Running:
				self.runAction(run())
			case PlayerState.Idle:
				self.runAction(idle())
			default:
				print("<< State Not Handled >>")
			}
		}
	}
	
}

