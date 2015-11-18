//
//  GameLayer.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class GameLayer: SKNode, MFCSControllerDelegate {

	var player: Player!
	var players = [Player]()
	var currentIndex: Int!
	var spawnPoints = NSMutableArray()
    var size: CGSize?
	var hasLoadedGame: Bool
    
    // Multiplayer variables
    var networkingEngine: MultiplayerNetworking?
    
	/**
	Initializes the game layer
	- parameter size: A reference to the device's screen size
	*/
	required init(size: CGSize, networkingEngine: MultiplayerNetworking) {
		self.hasLoadedGame = false
		super.init()
		
        self.size = size
		self.networkingEngine = networkingEngine
		self.spawnPointGenerator()
		self.currentIndex = networkingEngine.indexForLocalPlayer()
		
		if self.networkingEngine?.isPlayer1 == true {
			print("sou player 1, gerar spawnpoints")
			createPlayer()
			addPLayers()
			self.hasLoadedGame = true
		}
        
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func createPlayer() {
		let playersCount: Int = (GameKitHelper.sharedInstance.multiplayerMatch?.players.count)!
		var spawnPointIndexes = [Int]()

		for _ in 0...playersCount {
			var index = Int.randomWithInt(0...8)
			var currentSpawnPoint = spawnPoints.objectAtIndex(index)
			
			while (currentSpawnPoint as! SpawnPoint).isBeingUsed {
				index = Int.randomWithInt(0...8)
				currentSpawnPoint = spawnPoints.objectAtIndex(index)
			}
			
			(currentSpawnPoint as! SpawnPoint).closeSpawnPoint(10)
			
			let player = Uhong(position: currentSpawnPoint.position, screenSize: self.size!)
			players.append(player)
			spawnPointIndexes.append(index)
		}
		
		print(spawnPointIndexes)
		networkingEngine?.sendStartGameProperties(spawnPointIndexes)
	}
	
	func createPlayer(indexes: [Int]) {
		for index in 0...indexes.count - 1 {
			let currentSpawnPoint = spawnPoints.objectAtIndex(indexes[index])

			(currentSpawnPoint as! SpawnPoint).closeSpawnPoint(10)
			
			let player = Uhong(position: currentSpawnPoint.position, screenSize: self.size!)
			players.append(player)
		}
		
		addPLayers()
		self.hasLoadedGame = true
	}
	
	func addPLayers() {
		for index in 0...players.count - 1 {
			if index == self.currentIndex {
				self.player = self.players[index]
			}
			
			self.addChild(players[index])
		}
	}
	
	func update(currentTime: CFTimeInterval) {
		/* Called before each frame is rendered */
		for player in self.players {
			player.update(currentTime)
		}
	}
	
	
	// MARK: MFCSContrllerDelegate Methods
	func recieveCommand(command: MFCSCommandType){
		if command == MFCSCommandType.Attack {
            networkingEngine?.sendAttack()
			self.player?.isAttacking = true
		} else if command == MFCSCommandType.SpecialAttack {
			self.player?.isSpecialAttacking = true
				print("Special Attack")
		} else if command == MFCSCommandType.Jump {
            self.networkingEngine?.sendJump()
            self.player?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (self.player?.jumpForce)!))
		} else if command == MFCSCommandType.GetDown {
			self.player?.getDownOneFloor()
		}
	}
	
	func analogUpdate(relativePosition position: CGPoint) {
		self.setFlip(position)
        
        networkingEngine?.sendMove(Float(position.x), dy: Float(position.y))
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
    
    func attack() {
        print("Ataque de outro device")
        self.player?.isAttacking = true
    }

    // Perform a jump with an specific player
    func performJumpWithPlayer(player: Player) {
        player.isJumping = true
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (self.player?.jumpForce)!))
    }
    
    // Move a specific player
    func movePlayer(player: Player, dx: Float, dy: Float) {
        let movementVelocity = CGVector(dx: CGFloat(dx), dy: CGFloat(dy))
        player.movementVelocity = movementVelocity
    }
    
    // Perform an attack with an specific player
    func performAttackWithPlayer(player: Player) {
        player.isAttacking = true
    }
}

