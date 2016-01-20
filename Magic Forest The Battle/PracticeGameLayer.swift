//
//  PracticeGameLayer.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 09/12/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class PracticeGameLayer: SKNode, MFCSControllerDelegate  {
	
	var player: Player!
	var enemy: Player!
	
	var canPlayerJump: Bool = false
	
	var size: CGSize?
	var spawnPoints = NSMutableArray()
	var spawnPointsLocations : Array<CGPoint> = []
	
	var scenesDelegate: ScenesDelegate?
	
	var isOnMeleeCollision: Bool = false
	var isOnSpecialCollision: Bool = false
	
	var hasLoadedGame: Bool
	
	
	// MARK: init
	init(size: CGSize, playerSelected: String) {
		self.hasLoadedGame = false
		
		super.init()
		
		self.populateSpawnPoints()
		self.size = size
		self.spawnPointGenerator()
		
		self.generatePlayer(playerSelected)
		self.generateEnemy(playerSelected)
		
		self.hasLoadedGame = true
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func generatePlayer(playerSelected: String) {
		switch(playerSelected) {
		case "Uhong":
			self.player = Uhong(position: getRandomSpawnPoint ().position, screenSize: size!)
			(self.player as! Uhong).generateMeleeBox()
			(self.player as! Uhong).generateSpecialBox()
			break
		case "Neith":
			self.player = Neith(position: getRandomSpawnPoint ().position, screenSize:  size!)
			break
		case "Salamang":
			self.player = Salamang(position: getRandomSpawnPoint ().position, screenSize:  size!)
			break
		case "Dinak":
			self.player = Dinak(position: getRandomSpawnPoint ().position, screenSize: size!)
			break
		default:
			print("Was not possible to create a player in singlePlayer mode")
		}
		
		self.player.isMyPlayer = true
		
		self.addChild(self.player!)
	}
	
	func generateEnemy(playerSelected: String) {
		switch(playerSelected) {
		case "Uhong":
			self.enemy = Salamang(position: getRandomSpawnPoint ().position, screenSize: size!)
			break
		case "Neith":
			self.enemy = Neith(position: getRandomSpawnPoint ().position, screenSize:  size!)
			break
		case "Salamang":
			self.enemy = Uhong(position: getRandomSpawnPoint ().position, screenSize:  size!)
			break
		case "Dinak":
			self.enemy = Dinak(position: getRandomSpawnPoint ().position, screenSize: size!)
			break
		default:
			print("Was not possible to create a player in singlePlayer mode")
		}
		
		self.enemy.zPosition = -1
		self.enemy.physicsBody?.categoryBitMask = PhysicsCategory.Enemy.rawValue
		self.enemy.createLifeBar()
		
		self.addChild(self.enemy!)
	}
	
	func update(currentTime: NSTimeInterval) {
		self.player.update(currentTime)
		self.enemy.update(currentTime)
		
		if self.isOnMeleeCollision == true {
			let offset = self.player.position.x - self.enemy.position.x
			
			if offset < 0 && self.player.isLeft == true {
				self.isOnMeleeCollision = false
			} else {
				// Check Distance
			}
			
			if offset >= 0 && self.player.isLeft == false {
				self.isOnMeleeCollision = false
			} else {
				// Check Distance
			}
		}
	}
	
	// MARK: MFCSContrllerDelegate Methods
	func recieveCommand(command: MFCSCommandType){
		if command == MFCSCommandType.Attack && player?.currentLife > 0 {
			if self.player.isAttacking == false {
				if self.player.isKindOfClass(Salamang) || self.player.isKindOfClass(Neith) {
					self.projectileToLayer(self.player!)
				}
				self.checkAttack(0)
				
				self.player?.isAttacking = true
			}
			
		} else if command == MFCSCommandType.SpecialAttack && player?.currentEnergy == player?.energy && player?.currentLife > 0 {
			if self.player.isSpecialAttacking == false {
				self.player?.isSpecialAttacking = true
				print("Player used Special Attack")
				self.checkAttack(1)
			}
		} else if command == MFCSCommandType.Jump && self.canPlayerJump == true {
			if self.player.isJumping == false {
				self.player.isJumping = true
				self.player?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (self.player?.jumpForce)!))
			}
		} else if command == MFCSCommandType.GetDown && player?.currentLife > 0 {
			self.player?.getDownOneFloor()
		}
	}
	
	func analogUpdate(relativePosition position: CGPoint) {
		self.setFlip(position, node: self.player)
		
		self.player?.movementVelocity = CGVector(dx: position.x, dy: 0)
	}
	
	func attack() {
		self.player?.isAttacking = true
	}

	func setFlip (flipX : CGPoint, node : SKSpriteNode) {
		if flipX.x == 0 || player?.currentLife <= 0{
			return
		}
		
		if flipX.x < 0 {
			node.xScale = -fabs(node.xScale)
			//self.player?.xScale = -fabs((self.player?.xScale)!)
			if node == self.player {
				self.player?.isLeft = true
				//				self.player.lifeBar.xScale = -self.player.lifeBar.xScale
				
				
				
			}
		} else {
			//self.player?.xScale = fabs((self.player?.xScale)!)
			node.xScale = fabs(node.xScale)
			if node == self.player {
				self.player?.isLeft = false
				//				self.player.lifeBar.xScale = fabs(self.player.lifeBar.xScale)
				
			}
		}
	}
	
	func checkAttack(type: Int) {
		if type == 0 { // if type is 0, the is normal attack
			if self.player.isKindOfClass(Uhong) == true {
				if self.isOnMeleeCollision == true {
					
					let damage = self.player.attackDamage
					
					self.dealDamageOnEnemy(damage!)
				}
			}
		} else if type == 1 { // if type is 1, the is special attack
			if self.player.isKindOfClass(Uhong) == true {
				if self.isOnSpecialCollision == true {
					let damage = self.player.specialDamage
					
					self.dealDamageOnEnemy(damage!)
				}
			} else if self.player.isKindOfClass(Salamang) == true {
				
				self.projectileToLayerSpecial(self.player)
			}
		}
	}
	
	func dealDamageOnEnemy(damage: CGFloat) {
		
		if self.enemy.currentLife! - damage > 0 {
			
			self.enemy.currentLife = enemy.currentLife! - damage
			
			
		} else {
			
			self.enemy.currentLife = 0
		}
		
		self.animateBar(enemy.currentLife!, bar: enemy.life!, node: enemy.lifeBar, scale: 0.01)
	}
	
	func animateBar(currentBar : CGFloat, bar : CGFloat, node : SKSpriteNode, scale : CGFloat) {
		let easeScale = SKAction.scaleXTo(((currentBar*100/bar)/100)*scale, duration: 0.1)
		easeScale.timingMode = SKActionTimingMode.EaseInEaseOut
		//self.lifeFrontBar.removeAllActions()
		node.runAction(easeScale)
	}
	
	func projectileToLayer (player: Player) {
		let projectile = player.createProjectile()
		
		self.addChild(projectile)
		
		if (player.isLeft == true){
			//self.setFlip((self.player?.position)!,node: projectile)
			projectile.xScale = -projectile.xScale
			projectile.physicsBody?.applyImpulse(CGVectorMake(-2000, 100))
		} else {
			projectile.physicsBody?.applyImpulse(CGVectorMake(2000, 100))
		}
		
		projectile.runAction(projectile.removeProjectile())
	}
	
	func projectileToLayerSpecial(player: Player) {
		if player.isKindOfClass(Salamang) == true {
			let projetile1 = player.createProjectile()
			let projetile2 = player.createProjectile()
			let projetile3 = player.createProjectile()
			let projetile4 = player.createProjectile()
			let projetile5 = player.createProjectile()
			let projetile6 = player.createProjectile()
			
			projetile4.xScale = -projetile4.xScale
			projetile5.xScale = -projetile5.xScale
			projetile6.xScale = -projetile6.xScale
			
			self.addChild(projetile1)
			self.addChild(projetile2)
			self.addChild(projetile3)
			self.addChild(projetile4)
			self.addChild(projetile5)
			self.addChild(projetile6)
			
			projetile1.physicsBody?.applyImpulse(CGVector(dx: 2000, dy: 100))
			projetile2.physicsBody?.applyImpulse(CGVector(dx: 2000, dy: 1200))
			projetile3.physicsBody?.applyImpulse(CGVector(dx: 2000, dy: -1000))
			projetile4.physicsBody?.applyImpulse(CGVector(dx: -2000, dy: 100))
			projetile5.physicsBody?.applyImpulse(CGVector(dx: -2000, dy: 1200))
			projetile6.physicsBody?.applyImpulse(CGVector(dx: -2000, dy: -1000))
			
			projetile1.runAction(projetile1.removeProjectile())
			projetile2.runAction(projetile2.removeProjectile())
			projetile3.runAction(projetile3.removeProjectile())
			projetile4.runAction(projetile4.removeProjectile())
			projetile5.runAction(projetile5.removeProjectile())
			projetile6.runAction(projetile6.removeProjectile())
			
		}
	}
	
	// MARK: Spawn Point
	func populateSpawnPoints () {
		let size = CGSize(width: DEFAULT_WIDTH, height: DEFAULT_HEIGHT)
		self.spawnPointsLocations = [
			CGPoint(x: size.width*0.7, y: size.height*0.8),
			CGPoint(x: -size.width*1.4, y: size.height*1.6), //ok
			CGPoint(x: -size.width*0.6, y: size.height*0.9),  //ok
			CGPoint(x: -size.width*1.1, y: -size.height*0.4), //ok
			CGPoint(x: size.width*0.01, y: -size.height*0.08), //ok
			CGPoint(x: size.width*1.2, y: size.height*1.4), //ok
			CGPoint(x: -size.width*0.2, y: size.height*1.2),//ok
			CGPoint(x: size.width*1.2, y: -size.height*0.01)] //ok
	}
	
	func spawnPointGenerator () {
		for point in spawnPointsLocations {
			let spawnPoint = SpawnPoint(position: point)
			spawnPoints.addObject(spawnPoint)
			self.addChild(spawnPoint)
		}
	}
	
	func getRandomSpawnPoint () -> SpawnPoint {
		var currentSpawnPoint = spawnPoints.objectAtIndex(Int.randomWithInt(0...7))
		
		while (currentSpawnPoint as! SpawnPoint).isBeingUsed {
			currentSpawnPoint = spawnPoints.objectAtIndex(Int.randomWithInt(0...7))
		}
		
		(currentSpawnPoint as! SpawnPoint).closeSpawnPoint(10)
		return (currentSpawnPoint as! SpawnPoint)
	}
}