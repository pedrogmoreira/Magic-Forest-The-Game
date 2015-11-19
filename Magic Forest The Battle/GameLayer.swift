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
	var spawnPointIndexes = [Int]()
	var chosenCharacters = [Int]()
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
	required init(size: CGSize, networkingEngine: MultiplayerNetworking, chosenCharacters: [Int]) {
		self.hasLoadedGame = false
		super.init()
		
        self.size = size
		self.networkingEngine = networkingEngine
		self.chosenCharacters = chosenCharacters
		self.spawnPointGenerator()
		self.currentIndex = self.networkingEngine!.indexForLocalPlayer()
		
		if self.networkingEngine?.isPlayer1 == true {
			createPlayer()
			addPLayers()
			self.hasLoadedGame = true
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// The host will sort a positio to every player and then send the positions and selections to everyone
	func createPlayer() {
		let playersCount: Int = (GameKitHelper.sharedInstance.multiplayerMatch?.players.count)!

		for index in 0...playersCount {
			var spawnPointIndex = Int.randomWithInt(0...8)
			var currentSpawnPoint = spawnPoints.objectAtIndex(spawnPointIndex)
			
			while (currentSpawnPoint as! SpawnPoint).isBeingUsed {
				spawnPointIndex = Int.randomWithInt(0...8)
				currentSpawnPoint = spawnPoints.objectAtIndex(spawnPointIndex)
			}
			
			(currentSpawnPoint as! SpawnPoint).closeSpawnPoint(10)

			let player = generatePlayer(currentSpawnPoint.position, chosenCharacter: self.chosenCharacters[index])
			players.append(player)
			spawnPointIndexes.append(spawnPointIndex)
		}
		
		networkingEngine?.sendStartGameProperties(self.spawnPointIndexes, chosenCharacters: self.chosenCharacters)
	}
	
	// Called when the host sorted the positions and sent all players character selection
	func createPlayer(indexes: [Int], chosenCharacters: [CharacterType.RawValue]) {
		self.chosenCharacters = chosenCharacters
		for index in 0...indexes.count - 1 {
			let currentSpawnPoint = spawnPoints.objectAtIndex(indexes[index])

			(currentSpawnPoint as! SpawnPoint).closeSpawnPoint(10)
			
			let player = generatePlayer(currentSpawnPoint.position, chosenCharacter: self.chosenCharacters[index])
			players.append(player)
		}
		
		addPLayers()
		self.hasLoadedGame = true
	}
	
	// Adds all players to the game
	func addPLayers() {
		for index in 0...players.count - 1 {
			if index == self.currentIndex {
				self.player = self.players[index]
			}
			
			self.addChild(players[index])
		}
	}
	
	/**
	Generates a player on a position and with a chosen character class
	-Parameter position: The position where the player will be created
	-Parameter chosenCharacter: The character class type to be created from
	*/
	private func generatePlayer(position: CGPoint, chosenCharacter: CharacterType.RawValue) -> Player {
		switch chosenCharacter {
		case CharacterType.Uhong.rawValue:
			print("uhong")
			return Uhong(position: position, screenSize: self.size!)
		case CharacterType.Dinak.rawValue:
			print("dinak")
			return Dinak(position: position, screenSize: self.size!)
		case CharacterType.Salamang.rawValue:
			print("salamang")
			return Salamang(position: position, screenSize: self.size!)
		case CharacterType.Neith.rawValue:
			print("neith")
			return Neith(position: position, screenSize: self.size!)
		default:
			print("player")
			return Player(position: position, screenSize: self.size!)
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
            self.networkingEngine?.sendSpecialAttack()
		} else if command == MFCSCommandType.Jump {
            self.networkingEngine?.sendJump()
            self.player?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (self.player?.jumpForce)!))
		} else if command == MFCSCommandType.GetDown {
			self.player?.getDownOneFloor()
            self.networkingEngine?.sendGetDown()
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
    
    // Perform get down with an specific player
    func performGetDownWithPlayer(player: Player) {
        player.getDownOneFloor()
    }
    
    // Perform special attack with an specific player
    func performSpecialWithPlayer(player: Player) {
        player.isSpecialAttacking = true
    }
}

