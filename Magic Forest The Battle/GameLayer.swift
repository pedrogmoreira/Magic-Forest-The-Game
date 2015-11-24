//
//  GameLayer.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class GameLayer: SKNode, MFCSControllerDelegate {

	var hudLayer : HudLayer?
	var player: Player!
	var players = [Player]()
	var spawnPointIndexes = [Int]()
	var chosenCharacters = [Int]()
	var currentIndex: Int!
	var spawnPoints = NSMutableArray()
    var size: CGSize?
	var hasLoadedGame: Bool
    var playerPosition: CGPoint?
        
    // Multiplayer variables
    var networkingEngine: MultiplayerNetworking?
	var scenesDelegate: ScenesDelegate?
    
	/**
	Initializes the game layer
	- parameter size: A reference to the device's screen size
	*/
	required init(size: CGSize, networkingEngine: MultiplayerNetworking, chosenCharacters: [Int]) {
		self.hasLoadedGame = false
        self.playerPosition = CGPointZero
        
		super.init()
		
        self.size = size
		self.networkingEngine = networkingEngine
		self.chosenCharacters = chosenCharacters
		self.spawnPointGenerator()

		let wait = SKAction.waitForDuration(1)
		let block = SKAction.runBlock { () -> Void in
			self.upSpecialBar()
		}
		let seq = SKAction.sequence([wait,block])
		let repeatAct = SKAction.repeatActionForever(seq)
		self.runAction(repeatAct)
		
		self.currentIndex = self.networkingEngine!.indexForLocalPlayer()
		
		if self.networkingEngine?.isPlayer1 == true {
			createPlayer()
			addPLayers()
			self.hasLoadedGame = true
		}
	}
	
	init(size: CGSize) {
		self.hasLoadedGame = false
		super.init()
		
		self.size = size
		self.spawnPointGenerator()
		
		let wait = SKAction.waitForDuration(1)
		let block = SKAction.runBlock { () -> Void in
			self.upSpecialBar()
		}
		let seq = SKAction.sequence([wait,block])
		let repeatAct = SKAction.repeatActionForever(seq)
		self.runAction(repeatAct)
		
		singlePlayer()
		self.hasLoadedGame = true
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func singlePlayer() {
		var spawnPointIndex = Int.randomWithInt(0...8)
		var currentSpawnPoint = spawnPoints.objectAtIndex(spawnPointIndex)
		
		while (currentSpawnPoint as! SpawnPoint).isBeingUsed {
			spawnPointIndex = Int.randomWithInt(0...8)
			currentSpawnPoint = spawnPoints.objectAtIndex(spawnPointIndex)
		}
		
		(currentSpawnPoint as! SpawnPoint).closeSpawnPoint(10)
		
		switch(playerSelected) {
			case "Uhong":
				self.player = Uhong(position: currentSpawnPoint.position, screenSize: size!)
			break
			case "Neith":
				self.player = Neith(position: currentSpawnPoint.position, screenSize:  size!)
			break
			case "Salamang":
				self.player = Salamang(position: currentSpawnPoint.position, screenSize:  size!)
			break
			case "Dinak":
				self.player = Dinak(position: currentSpawnPoint.position, screenSize: size!)
		default:
			//self.playerAleatorio
			switch(Int.random(min: 1, max: 3)) {
			case 1:
				self.player = Uhong(position: currentSpawnPoint.position, screenSize: size!)
				break
			case 2:
				self.player = Neith(position: currentSpawnPoint.position, screenSize:  size!)
				break
			case 3:
				self.player = Salamang(position: currentSpawnPoint.position, screenSize:  size!)
				break
			default:
				self.player = Dinak(position: currentSpawnPoint.position, screenSize: size!)
			}
			
			
		}
		self.addChild(self.player!)
	}
	
	// The host will sort a positio to every player and then send the positions and selections to everyone
	func createPlayer() {
		let playersCount: Int = (GameKitHelper.sharedInstance.multiplayerMatch?.players.count)!
        
        var currentSpawnPoint = spawnPoints.objectAtIndex(0)
        
		for index in 0...playersCount {
			var spawnPointIndex = Int.randomWithInt(0...8)
            currentSpawnPoint = spawnPoints.objectAtIndex(spawnPointIndex)
			
			while (currentSpawnPoint as! SpawnPoint).isBeingUsed {
				spawnPointIndex = Int.randomWithInt(0...8)
				currentSpawnPoint = spawnPoints.objectAtIndex(spawnPointIndex)
			}
			
			(currentSpawnPoint as! SpawnPoint).closeSpawnPoint(10)

			let player = generatePlayer(currentSpawnPoint.position, chosenCharacter: self.chosenCharacters[index])
			players.append(player)
			spawnPointIndexes.append(spawnPointIndex)
		}
		
		(currentSpawnPoint as! SpawnPoint).closeSpawnPoint(10)

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
            let player = self.players[index]
            player.zPosition = -CGFloat(index)
			if index == self.currentIndex {
				self.player = player
                self.player.zPosition = 1
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
		if IS_ONLINE == true {
            networkingEngine?.sendMove(Float(player.position.x), dy: Float(player.position.y))
			for player in self.players {
				player.update(currentTime)
			}
		} else {
			self.player.update(currentTime)
		}
	}
	
	func upSpecialBar () {
		if player?.currentEnergy < player?.energy {
			let aux = ((player?.energy)! * (player?.regEnergy)!)/100
			player?.currentEnergy = (player?.currentEnergy)! + aux
			self.hudLayer?.animateBar((self.player?.currentEnergy)!, bar: (self.player?.energy)!, tipo: "energy")
			print(player?.currentEnergy)
		} else {
			self.hudLayer?.animateFullBar()
			
		}
	}
	
	// MARK: MFCSContrllerDelegate Methods
	func recieveCommand(command: MFCSCommandType){
		if command == MFCSCommandType.Attack {
			self.projectileToLayer((self.player?.createProjectile())!)
            networkingEngine?.sendAttack()
			self.player?.isAttacking = true
			if self.player?.currentLife > 0 {
				self.player?.currentLife = (self.player?.currentLife)! - 100
			}
			self.hudLayer?.animateBar((self.player?.currentLife)!, bar: (self.player?.life)!, tipo: "life")
			
		} else if command == MFCSCommandType.SpecialAttack && player?.currentEnergy == player?.energy {
			self.player?.isSpecialAttacking = true
				print("Special Attack")
			self.player?.currentEnergy = 0
			self.hudLayer?.energyFrontBar.removeAllActions()
			self.hudLayer?.animateBar((self.player?.currentEnergy)!, bar: (self.player?.energy)!, tipo: "energy")
            self.networkingEngine?.sendSpecialAttack()
		} else if command == MFCSCommandType.Jump {
            self.networkingEngine?.sendJump()
            self.player.isJumping = true
            self.player?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (self.player?.jumpForce)!))
		} else if command == MFCSCommandType.GetDown {
			self.player?.getDownOneFloor()
            self.networkingEngine?.sendGetDown()
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
		self.setFlip(position, node: self.player)
        
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
        let newPosition = CGPoint(x: CGFloat(dx), y: CGFloat(dy))
        
        // Adjusting player running animation. Refactor it :)
        if (self.playerPosition?.x != newPosition.x) && (self.playerPosition?.y == newPosition.y) {
            player.isRunning = true
        } else {
            player.isRunning = false
        }
        
        self.playerPosition = newPosition

        // Adjusting player flip. Refactor it :)
        if CGFloat(dx) > player.position.x {
            performFlipWithPlayer(player, flip: false)
        } else if CGFloat(dx) < player.position.x {
            performFlipWithPlayer(player, flip: true)
        }
        
        player.position = playerPosition!
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
    
    // Perform flip with an specific player
    func performFlipWithPlayer(player: Player, flip: Bool) {
        if flip {
            player.xScale = -fabs(player.xScale)
            player.isLeft = true
        } else {
            player.xScale = fabs(player.xScale)
            player.isLeft = false
        }
    }
}

