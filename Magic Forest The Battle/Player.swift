//
//  Player.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

// Bitmask values, made for avoid code repetition
let BITMASK_BASE_FLOOR = PhysicsCategory.WorldBox.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue
let BITMASK_FIRST_FLOOR = PhysicsCategory.WorldBox.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue | PhysicsCategory.WorldFirstFloorPlatform.rawValue
let BITMASK_SECOND_FLOOR = PhysicsCategory.WorldBox.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue | PhysicsCategory.WorldFirstFloorPlatform.rawValue | PhysicsCategory.WorldSecondFloorPlatform.rawValue
let BITMASK_THIRD_FLOOR = PhysicsCategory.WorldBox.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue | PhysicsCategory.WorldFirstFloorPlatform.rawValue | PhysicsCategory.WorldSecondFloorPlatform.rawValue | PhysicsCategory.WorldThirdFloorPlatform.rawValue

class Player: SKSpriteNode, GameObject {
	
	var isMyPlayer: Bool = false
	
	// Player properties
	var life: CGFloat?
	var currentLife: CGFloat?
	var energy: CGFloat?
	var currentEnergy: CGFloat?
	var attackDamage: CGFloat?
	var specialDamage: CGFloat?
	var movementVelocity: CGVector?
	var movementSpeed: CGFloat?
	var attackSpeed: CGFloat?
	var defesa: CGFloat?
	var jumpForce: CGFloat?
	var getDownForce: CGFloat?
	var regLife: CGFloat?
	var regEnergy: CGFloat?
	var state: PlayerState?
    var score = 0
	var isRanged: Bool = false
	
	// Player flags
	var isAttacking: Bool = false
	var isJumping: Bool = false
	var isSpecialAttacking: Bool = false
	var isGetDown: Bool = false
	var isLeft: Bool = false
	var isDead: Bool = false
    var isRunning: Bool = false
	
	let scale = CGFloat(0.07)
	
	var lifeBar = SKSpriteNode()
	
	// Bitmask values, made for avoid code repetition
	let BITMASK_BASE_FLOOR = PhysicsCategory.WorldBox.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue
	let BITMASK_FIRST_FLOOR = PhysicsCategory.WorldBox.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue | PhysicsCategory.WorldFirstFloorPlatform.rawValue
	let BITMASK_SECOND_FLOOR = PhysicsCategory.WorldBox.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue | PhysicsCategory.WorldFirstFloorPlatform.rawValue | PhysicsCategory.WorldSecondFloorPlatform.rawValue
	let BITMASK_THIRD_FLOOR = PhysicsCategory.WorldBox.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue | PhysicsCategory.WorldFirstFloorPlatform.rawValue | PhysicsCategory.WorldSecondFloorPlatform.rawValue | PhysicsCategory.WorldThirdFloorPlatform.rawValue
	/**
	Initializes the player
	- parameter position: The point where the player will apear
	*/
	required init(position: CGPoint, screenSize: CGSize) {
        let playerTexture = SKTexture(imageNamed: "CogumeloParado1")
		
		super.init(texture: playerTexture, color: UIColor.blackColor(), size: playerTexture.size())
		
		self.position = position
		self.resize(screenSize)
//        self.setScale(0.4)
        
//        self.createLifeBar()
		
        self.setBasicAttributes()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	/**
	Resizes the player to a screen proportion and scaled down to 7%
	- parameter screenSize: The device screen size
	*/
	private func resize(screenSize: CGSize) {
		let widthRatio =  DEFAULT_WIDTH / self.size.width
		let spriteRatio =  self.size.width / self.size.height
		
		let width = self.size.width * widthRatio * self.scale
		let height = width / spriteRatio
		
		self.size = CGSize(width: width, height: height)
	}
	
	func update(currentTime: CFTimeInterval) {
		/* Called before each frame is rendered */
		let velocityX = movementVelocity!.dx * movementSpeed!
		let velocityY = movementVelocity!.dy * 0
		let move = SKAction.moveByX(velocityX, y: velocityY, duration: 0)
		if self.currentLife <= 0 {

			self.changeState(PlayerState.Death)
			if self.isDead == false {
				self.rebirth()
			}
			return
		}
        
		self.runAction(move)
        
		if !self.isGetDown {
			self.checkFloorLevel()
		}
        
		if (self.isRunning || velocityX != 0 && self.physicsBody?.velocity.dy == 0) && self.state != .Hit && !isAttacking && !isSpecialAttacking {
			self.changeState(PlayerState.Running)
		} else if (self.isJumping && self.state != .Hit && !self.isAttacking && !isSpecialAttacking) {
			self.changeState(PlayerState.Jump)
		} else if self.physicsBody?.velocity.dy < 0 && self.state != .Hit && !self.isAttacking && !isSpecialAttacking {
			self.changeState(PlayerState.Falling)
		} else if self.isAttacking && !isSpecialAttacking {
			self.changeState(PlayerState.Attack)
		}else if self.isSpecialAttacking {
			self.changeState(PlayerState.SpecialAttack)
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
     Sets basic attributes
     */
    func setBasicAttributes() {
        self.physicsBody = self.generatePhysicsBody()
        
        self.life = 1000
		self.currentLife = 1000
        self.energy = 100
		self.currentEnergy = 100
        self.movementVelocity = CGVector(dx: 0, dy: 0)
        self.movementSpeed = 90
        self.jumpForce = 900
    }
	
	/**
	Generates a physics body
	- returns: SKPhysicsBody
	*/
	func generatePhysicsBody() -> SKPhysicsBody {
		return SKPhysicsBody()
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
	
	func specialAttack () -> SKAction {
		return SKAction()
	}
	
	/**
	Changes player state to a given state
	- parameter state: The new state
	*/
	func changeState(state: PlayerState) {
		
		if ((self.actionForKey("attack")) != nil) {
			self.isAttacking = true
		} else {
			self.isAttacking = false
		}
		
		if ((self.actionForKey("specialAttack")) != nil) {
			self.isSpecialAttacking = true
		} else {
			self.isSpecialAttacking = false
		}
		
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
			case PlayerState.Falling:
                self.runAction(falling())
			case PlayerState.Attack:
				self.runAction(SKAction.sequence([attack(),SKAction.runBlock({ () -> Void in
					self.isAttacking = false
				})]), withKey: "attack")
			case PlayerState.SpecialAttack:
				self.runAction(SKAction.sequence([specialAttack(),SKAction.runBlock({ () -> Void in
					self.isSpecialAttacking = false
				})]), withKey: "specialAttack")
			case PlayerState.Death:
				self.removeAllActions()
				self.runAction(death())
			default:
				self.runAction(idle())
			}
		}
	}
	
	/**
	Make the player get down the current floor
	*/
	func getDownOneFloor() {
		self.isGetDown = true
		
		if self.currentLife <= 0 {
			return
		}
		if self.physicsBody?.collisionBitMask == self.BITMASK_FIRST_FLOOR {
			self.physicsBody?.collisionBitMask = BITMASK_BASE_FLOOR
			self.physicsBody?.contactTestBitMask = BITMASK_BASE_FLOOR
		} else if self.physicsBody?.collisionBitMask == BITMASK_SECOND_FLOOR {
			self.physicsBody?.collisionBitMask = BITMASK_FIRST_FLOOR
			self.physicsBody?.contactTestBitMask = BITMASK_FIRST_FLOOR
		} else if self.physicsBody?.collisionBitMask == BITMASK_THIRD_FLOOR {
			self.physicsBody?.collisionBitMask = BITMASK_SECOND_FLOOR
			self.physicsBody?.contactTestBitMask = BITMASK_SECOND_FLOOR
		} else {
			self.physicsBody?.collisionBitMask = BITMASK_BASE_FLOOR
			self.physicsBody?.contactTestBitMask = BITMASK_BASE_FLOOR
		}
		
		let wait = SKAction.waitForDuration(0.2)
		let getDownImpulse = SKAction.runBlock({
			self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: self.getDownForce!))
		})
		
		self.runAction(SKAction.group([wait, getDownImpulse]), completion: {
			self.isGetDown = false
		})
		
	}
	
	/**
	Checks wheather the player can colide with floors
	*/
	func checkFloorLevel() {
		return
	}
	
	/**
	Criar Projétil
	- returns: Projectile
	*/
	
	func createProjectile () -> Projectile {
		let projectile = Projectile(position: self.position)
		return projectile
	}
	
	/**
	Reviver o personagem depois de 5 segundos
	*/
	func rebirth () {
		self.isDead = true
		let wait = SKAction.waitForDuration(5)
		self.runAction(wait) { () -> Void in
			self.currentLife = self.life
			self.currentEnergy = self.energy
			self.isDead = false
			self.position = (self.parent as! GameLayer).getRandomSpawnPoint().position
			
		}
		
	}
    
	func createLifeBar () {
		self.lifeBar = SKSpriteNode(imageNamed: "UI_COLORBAR_RED")
		self.lifeBar.setScale(0.01)
		self.lifeBar.yScale = 0.02
        self.lifeBar.position = CGPoint(x: -5 , y: -self.size.height*0.1)
        self.lifeBar.anchorPoint = CGPointMake(0, self.lifeBar.anchorPoint.y)
		lifeBar.zPosition = 0
		self.addChild(self.lifeBar)
	}
//	let easeScale = SKAction.scaleXTo(((self.currentLife!*100/self.life!)/100), duration: 0.5)
//	easeScale.timingMode = SKActionTimingMode.EaseInEaseOut
//	self.lifeBar.runAction(easeScale)
}