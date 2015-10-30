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
	var isAttacking: Bool = false
	var isJumping: Bool = false
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
		let move = SKAction.moveByX(velocityX, y: velocityY, duration: 0)
		
		self.runAction(move)
		
		if self.life <= 0 {
			print("to morto")
			self.changeState(PlayerState.Death)
		} else {
			if velocityX != 0 && self.physicsBody?.velocity.dy == 0 && self.state != .Hit && !isAttacking {
				self.changeState(PlayerState.Running)
			} else if (isJumping && self.state != .Hit && !isAttacking) {
				self.changeState(PlayerState.Jump)
				
			} else if self.physicsBody?.velocity.dy < 0 && self.state != .Hit && !isAttacking{
				self.changeState(PlayerState.Falling)
				
			} else if isAttacking {
				self.changeState(PlayerState.Attack)
				
			}else{
				self.changeState(PlayerState.Idle)
			}
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
        self.jumpForce = 900
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
		// MARK: States Animation
	func run () -> SKAction {
		return SKAction()
		
	}
	func idle () -> SKAction {
		return SKAction()
	}
	
	func jump () -> SKAction {
		return SKAction()
	}
	
	func falling () -> SKAction {
		return SKAction()
	}
	
	func attack () -> SKAction {
		return SKAction()
	}
	
	func hit () -> SKAction {
		return SKAction()		
	}
	
	func death () -> SKAction {
		return SKAction()
	}
	
	func changeState(state: PlayerState) {
		
		if((self.actionForKey("attack")) != nil){
			self.isAttacking = true
		}
		else{
			self.isAttacking = false
		}
//		if((self.actionForKey("jump")) != nil){
//			self.isJumping = true
//		}
//		else{
//			self.isJumping = false
//		}
		
		if self.state != state {
			self.state = state
			if self.state != PlayerState.Attack {
				self.isAttacking = false
			}
			switch (self.state!) {
			case PlayerState.Running:
				self.runAction(run())
			case PlayerState.Idle:
				self.runAction(idle())
			case PlayerState.Jump:
				self.runAction(jump(), completion: { () -> Void in
					self.isJumping = false
				})
//				self.runAction(SKAction.sequence([jump(),SKAction.runBlock({ () -> Void in
//					self.isJumping = false
//				})]), withKey: "jump")
				
			case PlayerState.Falling:
				self.runAction(falling())
			case PlayerState.Attack:
				self.runAction(SKAction.sequence([attack(),SKAction.runBlock({ () -> Void in
					self.isAttacking = false
				})]), withKey: "attack")
			case PlayerState.Death:
				self.runAction(death())
			default:
				self.runAction(idle())
			}
		}
	}

	
}
