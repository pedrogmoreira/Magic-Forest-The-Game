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
	var spawnPointsLocations : Array<CGPoint> = []
    var playerPosition: CGPoint?
    
    var canPlayerJump: Bool = false
        
    // Multiplayer variables
    var networkingEngine: MultiplayerNetworking?
	var scenesDelegate: ScenesDelegate?
	
	var normalAreaPlayersIndex: [Int] = [Int]()
	var specialAreaPlayersIndex: [Int] = [Int]()
	var isOnMeleeCollision: Bool = false
	var isOnSpecialCollision: Bool = false
	
	var score: Int = 0
	/**
	Initializes the game layer
	- parameter size: A reference to the device's screen size
	*/
	required init(size: CGSize, networkingEngine: MultiplayerNetworking, chosenCharacters: [Int]) {
		self.hasLoadedGame = false
		specialAreaPlayersIndex.removeAll()
        self.playerPosition = CGPointZero
        print("initial normal box collisions: \(self.normalAreaPlayersIndex.count)")
		super.init()
        
		self.populateSpawnPoints(size)
        self.size = size
		self.networkingEngine = networkingEngine
		self.chosenCharacters = chosenCharacters
		self.spawnPointGenerator()
//		self.lifeBar()
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
	
	
    init(size: CGSize, playerSelected: String) {
		self.hasLoadedGame = false
		super.init()
		self.populateSpawnPoints(size)
		self.size = size
		self.spawnPointGenerator()
//		self.lifeBar()
		let wait = SKAction.waitForDuration(1)
		let block = SKAction.runBlock { () -> Void in
			self.upSpecialBar()
		}
		let seq = SKAction.sequence([wait,block])
		let repeatAct = SKAction.repeatActionForever(seq)
		self.runAction(repeatAct)
		
        singlePlayer(playerSelected)
		self.hasLoadedGame = true
	}
	
	func populateSpawnPoints (size : CGSize) {
		self.spawnPointsLocations = [CGPoint(x: size.width/4, y: size.width/4),
			CGPoint(x: size.width/2, y: size.height/2),
			CGPoint(x: size.width*0.33, y: size.height*0.8),
			CGPoint(x: size.width*0.6, y: size.height*0.8),
			CGPoint(x: size.width*0.5, y: size.height*0.2),
			CGPoint(x: size.width*0.5, y: size.height*0.7),
			CGPoint(x: size.width*0.33, y: size.height*0.6),
			CGPoint(x: size.width*0.2, y: size.height*0.8),
			CGPoint(x: size.width*0.2, y: size.height*0.6)]
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    func singlePlayer(playerSelected: String) {
		switch(playerSelected) {
        case "Uhong":
            self.player = Uhong(position: getRandomSpawnPoint ().position, screenSize: size!)
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
		self.addChild(self.player!)
	}
	/**
	Pegar um spawn point aleatorio e que não tenha sido usado nos ultimos 10s
	- return: Spawn point
	*/
	func getRandomSpawnPoint () -> SpawnPoint {
		var currentSpawnPoint = spawnPoints.objectAtIndex(Int.randomWithInt(0...8))
		
		while (currentSpawnPoint as! SpawnPoint).isBeingUsed {
			currentSpawnPoint = spawnPoints.objectAtIndex(Int.randomWithInt(0...8))
		}
		
		(currentSpawnPoint as! SpawnPoint).closeSpawnPoint(10)
		return (currentSpawnPoint as! SpawnPoint)
	}
	
	// The host will sort a position to every player and then send the positions and selections to everyone
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
				player.isMyPlayer = true
				if player.isKindOfClass(Uhong) {
					print("is uhong")
					
					(player as! Uhong).generateMeleeBox()
					(player as! Uhong).generateSpecialBox()
				}
				self.player = player
                self.player.zPosition = 1
				
			} else {
				player.physicsBody?.categoryBitMask = PhysicsCategory.OtherPlayer.rawValue
//				player.physicsBody?.contactTestBitMask = (player.physicsBody?.contactTestBitMask)! | PhysicsCategory.MeleeBox.rawValue
				player.physicsBody?.usesPreciseCollisionDetection = true
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
        
        var player = Player(position: position, screenSize: self.size!)
        
		switch chosenCharacter {
		case CharacterType.Uhong.rawValue:
			print("Generated uhong")
			player = Uhong(position: position, screenSize: self.size!)
		case CharacterType.Dinak.rawValue:
			print("Generated dinak")
			player = Dinak(position: position, screenSize: self.size!)
		case CharacterType.Salamang.rawValue:
			print("Generated salamang")
			player =  Salamang(position: position, screenSize: self.size!)
		case CharacterType.Neith.rawValue:
			print("Generated neith")
			player = Neith(position: position, screenSize: self.size!)
		default:
			print("Was not possible to create a player in GeneratePlayer-gameLayer method")
		}
        
        return player
	}
	
	func update(currentTime: CFTimeInterval) {
		/* Called before each frame is rendered */
		if IS_ONLINE == true && self.hasLoadedGame == true {
            networkingEngine?.sendMove(Float(player.position.x), dy: Float(player.position.y))
			for player in self.players {
				player.update(currentTime)
			}
			
			if self.normalAreaPlayersIndex.count > 0 {
				for index in self.normalAreaPlayersIndex {
					let enemy = self.players[index]
					
					let offset = self.player.position.x - enemy.position.x
					
					if offset < 0 && self.player.isLeft == true {
						self.normalAreaPlayersIndex.removeAtIndex(self.normalAreaPlayersIndex.indexOf(index)!)
					} else {
						// Check Distance
					}
					
					if offset >= 0 && self.player.isLeft == false {
						self.normalAreaPlayersIndex.removeAtIndex(self.normalAreaPlayersIndex.indexOf(index)!)
					} else {
						// Check Distance
					}
				}
			}
		} else if IS_ONLINE == false && self.hasLoadedGame == true {
			self.player.update(currentTime)
		}
	}
	
	func upSpecialBar () {
		if player?.currentEnergy < player?.energy {
			let aux = ((player?.energy)! * (player?.regEnergy)!)/100
			player?.currentEnergy = (player?.currentEnergy)! + aux
			self.hudLayer?.animateBar((self.player?.currentEnergy)!, bar: (self.player?.energy)!,node: (hudLayer?.energyFrontBar)!, scale:  0.24)
			print("Current energy: \(player?.currentEnergy)")
		} else {
			self.hudLayer?.animateFullBar()
			
		}
	}
	
	// MARK: MFCSContrllerDelegate Methods
	func recieveCommand(command: MFCSCommandType){
		if command == MFCSCommandType.Attack && player?.currentLife > 0 {
			if self.player.isAttacking == false {
				self.projectileToLayer((self.player?.createProjectile())!, player: self.player!)
				self.checkAttack(0)
				networkingEngine?.sendAttack()
				self.player?.isAttacking = true
			}
			
		} else if command == MFCSCommandType.SpecialAttack && player?.currentEnergy == player?.energy && player?.currentLife > 0 {
			self.player?.isSpecialAttacking = true
				print("Player used Special Attack")
			self.checkAttack(1)
			self.player?.currentEnergy = 0
			self.hudLayer?.energyFrontBar.removeAllActions()
			self.hudLayer?.animateBar((self.player?.currentEnergy)!, bar: (self.player?.energy)!, node: (hudLayer?.energyFrontBar)!, scale:  0.24)
            self.networkingEngine?.sendSpecialAttack()
		} else if command == MFCSCommandType.Jump && self.canPlayerJump == true {
			if self.player.isJumping == false {
				self.player.isJumping = true
				self.player?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: (self.player?.jumpForce)!))
			}
		} else if command == MFCSCommandType.GetDown && player?.currentLife > 0 {
            self.canPlayerJump = false
			self.player?.getDownOneFloor()
            self.networkingEngine?.sendGetDown()
		}
	}
	
	func checkAttack(type: Int) {
		if type == 0 { // if type is 0, the is normal attack
			if self.normalAreaPlayersIndex.count > 0 && self.player.isRanged == false {
				print("Deal damage with NORMAL ATTACK on \(self.networkingEngine?.orderOfPlayers[self.normalAreaPlayersIndex.first!].player.alias)")
				
				let enemyIndex = self.normalAreaPlayersIndex.first!
				let enemy = self.players[enemyIndex]
				let damage = self.player.attackDamage
				
				self.dealDamageOnEnemy(enemy, enemyIndex: enemyIndex, WithDamage: damage!)
				
			}
		} else if type == 1 { // if type is 1, the is special attack
			if self.player.isKindOfClass(Uhong) == true {
				if self.specialAreaPlayersIndex.count > 0 {
					let damage = self.player.specialDamage
					
					for index in self.specialAreaPlayersIndex {
						let enemy = self.players[index]
						print("Deal damage with SPECIAL ATTACK on \(self.networkingEngine?.orderOfPlayers[index].player.alias)")
						
						self.dealDamageOnEnemy(enemy, enemyIndex: index, WithDamage: damage!)
					}
				}
			} else if self.player.isKindOfClass(Salamang) == true {
				print("im salamang")
				
				self.projectileToLayerSpecial(self.player)
			}
		}
	}
	
	func dealDamageOnEnemy(enemy: Player, enemyIndex: Int, WithDamage damage: CGFloat) {
		
		if enemy.currentLife! - damage > 0 {
			
			enemy.currentLife = enemy.currentLife! - damage
			
			
		} else {
			enemy.currentLife = 0
			
			if enemy.isDead == false {
				self.score++
				self.hudLayer?.updateScoreLabel(withScore: self.score)
			}
		}
		
		self.networkingEngine?.sendLoseLife(enemy.currentLife!, playerIndex: enemyIndex)
		hudLayer?.animateBar(enemy.currentLife!, bar: enemy.life!, node: enemy.lifeBar, scale: 0.01)
	}
	
	func projectileToLayer (projectile : Projectile, player: Player) {
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
			
			if player.isEqual(self.player) == false {
				print("special do salamang inimigo")
				
				projetile1.physicsBody?.contactTestBitMask = PhysicsCategory.OtherPlayerProjectile.rawValue
				projetile1.canDealDamage = false
				projetile2.physicsBody?.contactTestBitMask = PhysicsCategory.OtherPlayerProjectile.rawValue
				projetile2.canDealDamage = false
				projetile3.physicsBody?.contactTestBitMask = PhysicsCategory.OtherPlayerProjectile.rawValue
				projetile3.canDealDamage = false
				
				projetile4.physicsBody?.contactTestBitMask = PhysicsCategory.OtherPlayerProjectile.rawValue
				projetile4.canDealDamage = false
				projetile5.physicsBody?.contactTestBitMask = PhysicsCategory.OtherPlayerProjectile.rawValue
				projetile5.canDealDamage = false
				projetile6.physicsBody?.contactTestBitMask = PhysicsCategory.OtherPlayerProjectile.rawValue
				projetile6.canDealDamage = false
			}
		}
	}
	
	func analogUpdate(relativePosition position: CGPoint) {
		self.setFlip(position, node: self.player)
        
		setFlip(player.position, node: player.lifeBar)

		player?.movementVelocity = CGVector(dx: position.x, dy: 0)
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
				self.player.lifeBar.xScale = fabs(self.player.lifeBar.xScale)
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
		
		let projectile = player.createProjectile()
		projectile.physicsBody?.contactTestBitMask = PhysicsCategory.OtherPlayerProjectile.rawValue
		projectile.canDealDamage = false
		
		self.projectileToLayer(projectile, player: player)
    }
    
    // Perform get down with an specific player
    func performGetDownWithPlayer(player: Player) {
        player.getDownOneFloor()
    }
    
    // Perform special attack with an specific player
    func performSpecialWithPlayer(player: Player) {
        player.isSpecialAttacking = true
		
		if player.isKindOfClass(Salamang) {
			print("inimigo é salamang")
			
			self.projectileToLayerSpecial(player)
		}
    }

	func performLoseLifeWithPlayer (player: Player, currentLife: Float) {
		player.currentLife = CGFloat(currentLife)
        
		if player.currentLife <= 0 {
			if player.isDead == false {
				self.score--
				self.hudLayer?.updateScoreLabel(withScore: self.score)
			}
		}

		hudLayer?.animateBar(player.currentLife!, bar: player.life!, node: player.lifeBar, scale: 0.01)
	}
	func performDeathWithPlayer (player: Player) {
		player.isDead = true
	}
	
	// MARK: Physics Contact Delegate
	
	func checkIndex(index: Int, atArray array: [Int]) -> Bool {
		for collidedIndex in array {
			if collidedIndex == index {
				return true
			}
		}
		
		return false
	}
	
	func didBeginContact(contact: SKPhysicsContact) {
		let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		switch(contactMask) {
			
		case PhysicsCategory.Player.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue,
		PhysicsCategory.Player.rawValue | PhysicsCategory.WorldFirstFloorPlatform.rawValue,
		PhysicsCategory.Player.rawValue | PhysicsCategory.WorldSecondFloorPlatform.rawValue,
		PhysicsCategory.Player.rawValue | PhysicsCategory.WorldThirdFloorPlatform.rawValue:
			
			self.canPlayerJump = true
			
		case PhysicsCategory.MeleeBox.rawValue | PhysicsCategory.OtherPlayer.rawValue:
			if contact.bodyA.categoryBitMask == PhysicsCategory.MeleeBox.rawValue {
				let index = self.players.indexOf(contact.bodyB.node as! Player)!
				print("entry index: \(index)")
				
				print(self.checkIndex(index, atArray: self.normalAreaPlayersIndex))
				
				if self.checkIndex(index, atArray: self.normalAreaPlayersIndex) == false {
					self.normalAreaPlayersIndex.append(index)
				}
			} else {
				let index = self.players.indexOf(contact.bodyA.node as! Player)!
				
				print("entry index: \(index)")
				
				print(self.checkIndex(index, atArray: self.normalAreaPlayersIndex))
				
				if self.checkIndex(index, atArray: self.normalAreaPlayersIndex) == false {
					self.normalAreaPlayersIndex.append(index)
				}
			}
			
			print("Entry on melee box, count: \(self.normalAreaPlayersIndex.count)")

		case PhysicsCategory.Projectile.rawValue | PhysicsCategory.OtherPlayer.rawValue:
			print("PROJECTILE DAMAGE")
			var player: Player?
			var projectile: Projectile?
			if contact.bodyA.categoryBitMask == PhysicsCategory.OtherPlayer.rawValue {
				player = (contact.bodyA.node as! Player)
				
				if let body = (contact.bodyB.node as? Arrow) {
					projectile = body
				} else {
					projectile = (contact.bodyB.node as? Jujuba)
				}
			} else {
				player = (contact.bodyB.node as! Player)
				projectile = (contact.bodyA.node as! Projectile)
			}
			
			if projectile?.canDealDamage == true {
				projectile?.canDealDamage = false
				projectile?.hitSound()
				projectile?.removeFromParent()
				
				let damage = self.player.attackDamage
				
				if player!.currentLife! - damage! > 0 {
					
					player!.currentLife = player!.currentLife! - damage!
					
				} else {
					player!.currentLife = 0
					
					if player!.isDead == false {
						self.score++
						self.hudLayer?.updateScoreLabel(withScore: self.score)
					}
				}
				
				self.networkingEngine?.sendLoseLife(player!.currentLife!, playerIndex: self.players.indexOf(player!)!)
				hudLayer?.animateBar(player!.currentLife!, bar: player!.life!, node: player!.lifeBar, scale: 0.01)
			}
		case PhysicsCategory.SpecialBox.rawValue | PhysicsCategory.OtherPlayer.rawValue:
			if contact.bodyA.categoryBitMask == PhysicsCategory.SpecialBox.rawValue {
				let index = self.players.indexOf(contact.bodyB.node as! Player)!
				
				if self.checkIndex(index, atArray: self.specialAreaPlayersIndex) == false {
					self.specialAreaPlayersIndex.append(index)
				}
			} else {
				let index = self.players.indexOf(contact.bodyA.node as! Player)!
				
				if self.checkIndex(index, atArray: self.specialAreaPlayersIndex) == false {
					self.specialAreaPlayersIndex.append(index)
				}
			}
		case PhysicsCategory.Player.rawValue | PhysicsCategory.DeathBox.rawValue:
			self.player.currentLife = 0
			if IS_ONLINE == true {
				self.score--
				self.hudLayer?.updateScoreLabel(withScore: self.score)
			}
		default:
			return
		}
	}
	
	func didEndContact(contact: SKPhysicsContact) {
		let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		print("\nEND\n")
		
		print(contact.bodyA.categoryBitMask)
		print(contact.bodyB.categoryBitMask)
		
		switch(contactMask) {
            
        case PhysicsCategory.Player.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue,
        PhysicsCategory.Player.rawValue | PhysicsCategory.WorldFirstFloorPlatform.rawValue,
        PhysicsCategory.Player.rawValue | PhysicsCategory.WorldSecondFloorPlatform.rawValue,
        PhysicsCategory.Player.rawValue | PhysicsCategory.WorldThirdFloorPlatform.rawValue:
            
            // If player began the contact with floor and he is not jumping, he can jump again
            //            if self.player.isJumping == false {
            //                self.player.jumpCount = 0
            //            }
            self.canPlayerJump = false
		case PhysicsCategory.SpecialBox.rawValue | PhysicsCategory.OtherPlayer.rawValue:
			if self.specialAreaPlayersIndex.count > 0 {
				if contact.bodyA.categoryBitMask == PhysicsCategory.SpecialBox.rawValue {
					self.specialAreaPlayersIndex.removeAtIndex(self.specialAreaPlayersIndex.indexOf((self.players.indexOf(contact.bodyB.node as! Player)!))!)
				} else {
					self.specialAreaPlayersIndex.removeAtIndex(self.specialAreaPlayersIndex.indexOf((self.players.indexOf(contact.bodyA.node as! Player)!))!)
				}
				
				if self.specialAreaPlayersIndex.count == 0 {
					self.isOnSpecialCollision = false
				}
			}
		default:
			print("default")
		}
		
		if contactMask == PhysicsCategory.MeleeBox.rawValue | PhysicsCategory.OtherPlayer.rawValue {
			if self.normalAreaPlayersIndex.count > 0 {
				if contact.bodyA.categoryBitMask == PhysicsCategory.OtherPlayer.rawValue {
					let player = (contact.bodyA.node as! Player)
					let playerIndex = self.players.indexOf(player)
					
					if checkIndex(playerIndex!, atArray: self.normalAreaPlayersIndex) == true {
						print("removing player index: \(playerIndex)")
						
						self.normalAreaPlayersIndex.removeAtIndex(self.normalAreaPlayersIndex.indexOf(playerIndex!)!)
					}
				} else {
					let player = (contact.bodyB.node as! Player)
					let playerIndex = self.players.indexOf(player)
					
					if checkIndex(playerIndex!, atArray: self.normalAreaPlayersIndex) == true {
						print("removing player index: \(playerIndex)")
						
						self.normalAreaPlayersIndex.removeAtIndex(self.normalAreaPlayersIndex.indexOf(playerIndex!)!)
					}
				}
			}
			
			print("remove on melee box, count: \(self.normalAreaPlayersIndex.count)")
		}
	}
	
    // Check if player is dead
    private func isPlayerDead(player: Player) {
        if player.currentLife <= 0 {
            player.isDead = true
        }
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

