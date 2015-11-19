//
//  GameLayer.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class GameLayer: SKNode, BasicLayer, MFCSControllerDelegate {

	var player: Player?
	var hudLayer : HudLayer?
	var spawnPoints = NSMutableArray()
	
	/**
	Initializes the game layer
	- parameter size: A reference to the device's screen size
	*/
	required init(size: CGSize) {
		super.init()

		self.spawnPointGenerator()
		self.createPlayer(size)
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func createPlayer(size: CGSize) {
		var currentSpawnPoint = spawnPoints.objectAtIndex(Int.randomWithInt(0...8))
		
		while (currentSpawnPoint as! SpawnPoint).isBeingUsed {
			currentSpawnPoint = spawnPoints.objectAtIndex(Int.randomWithInt(0...8))
		}
		
		(currentSpawnPoint as! SpawnPoint).closeSpawnPoint(10)

		switch(playerSelected) {
			case "Uhong":
				self.player = Uhong(position: currentSpawnPoint.position, screenSize: size)
			break
			case "Neith":
				self.player = Neith(position: currentSpawnPoint.position, screenSize:  size)
			break
			case "Salamang":
				self.player = Salamang(position: currentSpawnPoint.position, screenSize:  size)
			break
			case "Dinak":
			    self.player = Dinak(position: currentSpawnPoint.position, screenSize: size)
		default:
			//self.playerAleatorio
			switch(Int.random(min: 1, max: 3)) {
			case 1:
				self.player = Uhong(position: currentSpawnPoint.position, screenSize: size)
				break
			case 2:
				self.player = Neith(position: currentSpawnPoint.position, screenSize:  size)
				break
			case 3:
				self.player = Salamang(position: currentSpawnPoint.position, screenSize:  size)
				break
			default:
				self.player = Dinak(position: currentSpawnPoint.position, screenSize: size)
			}
			
			
		}
		self.addChild(self.player!)
	}
	
	func update(currentTime: CFTimeInterval) {
		/* Called before each frame is rendered */
		self.player?.update(currentTime)
	}
	
	
	// MARK: MFCSContrllerDelegate Methods
	func recieveCommand(command: MFCSCommandType){
		if command == MFCSCommandType.Attack {
			self.projectileToLayer((self.player?.createProjectile())!)
			self.player?.isAttacking = true
			self.player?.currentLife = (self.player?.currentLife)! - 100
			self.hudLayer?.animateBar((self.player?.currentLife)!, bar: (self.player?.life)!, tipo: "life")
			
		} else if command == MFCSCommandType.SpecialAttack {
			self.player?.isSpecialAttacking = true
				print("Special Attack")
			self.player?.currentEnergy = 0
			self.hudLayer?.animateBar((self.player?.currentEnergy)!, bar: (self.player?.energy)!, tipo: "energy")
		} else if command == MFCSCommandType.Jump {
			self.player?.isJumping = true
			self.player?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (self.player?.jumpForce)!))
		} else if command == MFCSCommandType.GetDown {
			self.player?.getDownOneFloor()
		}
	}
	
	func projectileToLayer (projectile : Projectile) {
		self.addChild(projectile)
		
		if (self.player?.isLeft == true){
			//self.setFlip((self.player?.position)!,node: projectile)
			projectile.xScale = -projectile.xScale
			projectile.physicsBody?.applyImpulse(CGVectorMake(-2000, 100))
		} else {
			projectile.physicsBody?.applyImpulse(CGVectorMake(2000, 100))
		}
		projectile.runAction(projectile.removeProjectile())
	}
	
	func analogUpdate(relativePosition position: CGPoint) {
		self.setFlip(position,node: self.player!)

		player?.movementVelocity = CGVector(dx: position.x, dy: 0)
	}
	
	
	func setFlip (flipX : CGPoint, node : SKSpriteNode) {
		if flipX.x == 0 {
			return
		}
		if flipX.x < 0 {
			node.xScale = -fabs(node.xScale)
			//self.player?.xScale = -fabs((self.player?.xScale)!)
			if node == self.player {
				self.player?.isLeft = true
			}
		} else {
			//self.player?.xScale = fabs((self.player?.xScale)!)
			node.xScale = fabs(node.xScale)
			if node == self.player {
				self.player?.isLeft = false
			}
		}
	}
	
	func spawnPointGenerator () {
		for point in spawnPointsLocations {
			let spawnPoint = SpawnPoint(position: point)
			spawnPoints.addObject(spawnPoint)
			self.addChild(spawnPoint)
		}
	}
	
}
