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
	var spawnPoints = NSMutableArray()
    
    // Multiplayer variables
    var networkingEngine: MultiplayerNetworking?
    
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
		
		self.player = Uhong(position: currentSpawnPoint.position, screenSize: size)
		self.addChild(self.player!)
	}
	
	func update(currentTime: CFTimeInterval) {
		/* Called before each frame is rendered */
		self.player?.update(currentTime)
	}
	
	
	// MARK: MFCSContrllerDelegate Methods
	func recieveCommand(command: MFCSCommandType){
		if command == MFCSCommandType.Attack {
			self.player?.isAttacking = true
            networkingEngine?.sendString()
		} else if command == MFCSCommandType.SpecialAttack {
			self.player?.isSpecialAttacking = true
				print("Special Attack")
		} else if command == MFCSCommandType.Jump {
			self.player?.isJumping = true
			self.player?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (self.player?.jumpForce)!))
		} else if command == MFCSCommandType.GetDown {
			self.player?.getDownOneFloor()
		}
	}
	
	func analogUpdate(relativePosition position: CGPoint) {
		self.setFlip(position)

		player?.movementVelocity = CGVector(dx: position.x, dy: 0)
	}
	
	
	func setFlip (flipX : CGPoint) {
		if flipX.x == 0 {
			return
		}
		if flipX.x < 0 {
			self.player?.xScale = -fabs((self.player?.xScale)!)
		} else {
			self.player?.xScale = fabs((self.player?.xScale)!)
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
