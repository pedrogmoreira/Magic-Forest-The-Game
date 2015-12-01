//
//  GameScene.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright (c) 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

let DEFAULT_WIDTH = CGFloat(667)
let DEFAULT_HEIGHT = CGFloat(375)

class GameScene: SKScene, SKPhysicsContactDelegate, MultiplayerProtocol, MatchEndDelegate {
	
    var playerSelected: String?
    
	var backgroundLayer: BackgroundLayer?
	var hudLayer: HudLayer?
	var gameLayer: GameLayer?
	var gameOverLayer: GameOverLayer?
	
    var playerCamera: SKCameraNode?
    
    // Multiplayer variables
    var networkingEngine: MultiplayerNetworking?
    var currentIndex: Int?
	var chosenCharacters = [Int]()
	var playersDetails = [PlayerDetails]()
	var playersScores = [PlayerScores]()
	var finalScores = [Int]()
	var scenesDelegate: ScenesDelegate?
	var controlUnit: MFCSControlUnit?
	var isGameOver: Bool = false
	
	/**
	Initializes the game scene
	- parameter size: A reference to the device's screen size
	*/
	override init(size: CGSize) {
        self.playerSelected = ""
		super.init(size: size)
	}
    
    override func didMoveToView(view: SKView) {
		if IS_ONLINE == true {
			self.gameLayer = GameLayer(size: size, networkingEngine:  self.networkingEngine!, chosenCharacters: self.chosenCharacters)
		} else {
			self.gameLayer = GameLayer(size: size, playerSelected: self.playerSelected!)
		}
		
        self.gameLayer?.zPosition = -5
//        self.networkingEngine?.createPlayers()
        
        self.backgroundLayer = ForestScenery(size: size)
        self.backgroundLayer?.zPosition = -10
        
        self.hudLayer = HudLayer(size: size)
        self.hudLayer?.zPosition = 1_000
		self.hudLayer?.matchEndDelegate = self
		self.hudLayer?.networkingEngine = self.networkingEngine
        
        self.gameLayer?.hudLayer = self.hudLayer
        
        self.addChild(self.gameLayer!)
        self.addChild(self.backgroundLayer!)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        self.initializeCamera()
		
		self.addChild(self.playerCamera!)
		self.playerCamera?.addChild(hudLayer!)
    }
    
    private func initializeCamera(){
        self.playerCamera = SKCameraNode()
		self.playerCamera?.setScale(1.3)
        
        let scaleX = (DEFAULT_WIDTH * 1.3)/self.size.width
        self.playerCamera?.xScale = scaleX
        
        let scaleY = (DEFAULT_HEIGHT * 1.3)/self.size.height
        self.playerCamera?.yScale = scaleY

        self.camera = self.playerCamera
        
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func update(currentTime: NSTimeInterval) {
		self.gameLayer?.update(currentTime)
	}
    
    // FIXME: The two next methods has duplicated code. They need to be refactored
	// IF CAMERA SCALE EQUALS 1.3, USE Y 0.9 / X 0.905
	// IF CAMERA SCALE EQUALS 1.5, USE Y 0.84 / X 0.845
    
    // Set the Y position of camera
    private func cameraPositionYAxis(){
        // The camera usually follows the player...
        let playerYPosition = (self.gameLayer?.player?.position.y)!;
        self.playerCamera?.position.y = playerYPosition
        
        let screenHeight = DEFAULT_HEIGHT
        let backgroundHeight = self.backgroundLayer?.background?.size.height
//		backgroundHeight = backgroundHeight! * 0.8
        let cameraYPosition = self.playerCamera!.position.y
		
        //... but if player comes too close to an edge the camera stops to follow
        if cameraYPosition < (-(backgroundHeight!/2) + screenHeight/2) * 0.9 {
            self.playerCamera?.position.y = (-(backgroundHeight!/2) + screenHeight/2) * 0.9
        } else if cameraYPosition > ((backgroundHeight!/2) - screenHeight/2) * 0.9 {
            self.playerCamera?.position.y = ((backgroundHeight!/2) - screenHeight/2) * 0.9
        }
    }
    
    // Set the X position of camera
    private func cameraPositionXAxis(){
        // The camera usually follows the player...
        let playerXPosition = (self.gameLayer?.player?.position.x)!
        self.playerCamera?.position.x = playerXPosition
        
        let cameraXPosition = self.playerCamera!.position.x
        let backgroundWidth = self.backgroundLayer?.background?.size.width
        let screenWidth = DEFAULT_WIDTH
        
        //...but if player comes too close to an edge the camera stops to follow
        if cameraXPosition < (-(backgroundWidth!/2) + screenWidth/2) * 0.905 {
            self.playerCamera?.position.x = (-(backgroundWidth!/2) + screenWidth/2) * 0.905
        } else if cameraXPosition > (backgroundWidth!/2 - screenWidth/2) * 0.905 {
            self.playerCamera?.position.x = (backgroundWidth!/2 - screenWidth/2) * 0.905
        }
        
    }
    
    override func didFinishUpdate() {
		if self.gameLayer?.hasLoadedGame == true {
			self.cameraPositionYAxis()
			self.cameraPositionXAxis()
		}
    }
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		if self.isGameOver {
			scenesDelegate?.showMenu()
			scenesDelegate?.removeMenuSelectPlayerScene()
			scenesDelegate?.removeGameScene()
			
			GameKitHelper.sharedInstance.multiplayerMatch?.disconnect()
		}
	}
    
    // Called when the match has ended
    func matchEnded() {
        
    }
    
    func startGame() {
        
    }
	
    func attack() {
        self.gameLayer?.attack()
    }
	
	// Called when my device receive the message to create the players
	func createPlayer(indexes: [Int], chosenCharacters: [CharacterType.RawValue]) {
        self.gameLayer?.createPlayer(indexes, chosenCharacters: chosenCharacters)
    }
	
	// Called when a player send his selection
	func receiveChosenCharacter(chosenCharacter: CharacterType, playerIndex: Int) {
		self.playersDetails.append(PlayerDetails(character: chosenCharacter, index: playerIndex))
				
		if self.playersDetails.count == (GameKitHelper.sharedInstance.multiplayerMatch!.players.count + 1) {
			
			let multableArray = NSMutableArray(array: self.playersDetails)
			let sortByIndex = NSSortDescriptor(key: "index", ascending: true)
			let sortDescriptiors = [sortByIndex]
			multableArray.sortUsingDescriptors(sortDescriptiors)
			self.playersDetails = NSArray(array: multableArray) as! [PlayerDetails]
			
			for playerDetail in self.playersDetails {
				self.chosenCharacters.append(playerDetail.character.rawValue)
			}
			
			self.gameLayer?.createPlayer()
			self.gameLayer?.addPLayers()
			self.gameLayer?.hasLoadedGame = true
			print("All players send character info to me, sending to all info to everyone")
			networkingEngine?.tryStartGame()
			
		}
	}
	
	func chooseCharacter() {
		print("Multiplayer select player")
		let menuSelectPlayerScene = MenuSelectPlayerScene(size: self.size)
		scenesDelegate?.showMenuSelectPlayerScene(menuSelectPlayerScene)
	}
	
	
	// Class to determine player character selection and index for ordering array of players selections
	class PlayerDetails: NSObject {
		let character: CharacterType
		let index: Int
			
		init(character: CharacterType, index: Int) {
			self.character = character
			self.index = index
			super.init()
		}
	}

	class PlayerScores: NSObject {
		let score: Int
		let index: Int
		
		init(score: Int, index: Int) {
			self.score = score
			self.index = index
			super.init()
		}
	}
	
    // Perform a jump in all devices
    func performJump (index: Int) {
        let player = gameLayer!.players[index] as Player
        gameLayer?.performJumpWithPlayer(player)
    }
    
    // Move the player in all devices
    func movePlayer(index: Int, dx: Float, dy: Float) {
        let player = gameLayer!.players[index] as Player
        self.gameLayer?.movePlayer(player, dx: dx, dy: dy)
    }
    
    // Attack in all devices
    func attack(index: Int) {
        let player = gameLayer!.players[index] as Player
        self.gameLayer?.performAttackWithPlayer(player)
    }
    
    // Get down in all devices
    func performGetDown(index: Int) {
        let player = gameLayer!.players[index] as Player
        self.gameLayer?.performGetDownWithPlayer(player)
    }
    
    // Perform special in all devices
    func performSpecial(index: Int) {
        let player = gameLayer!.players[index] as Player
        self.gameLayer?.performSpecialWithPlayer(player)
    }
	// Perform special in all devices
	func performLoseLife(index: Int, currentLife: Float) {
		let player = gameLayer!.players[index] as Player
		self.gameLayer?.performLoseLifeWithPlayer(player, currentLife: currentLife)
	}
    
    // Set the player index
    func setCurrentPlayerIndex(index: Int) {
        currentIndex = index
    }
	
	func didBeginContact(contact: SKPhysicsContact) {
		self.gameLayer?.didBeginContact(contact)
	}
	
	func didEndContact(contact: SKPhysicsContact) {
		self.gameLayer?.didEndContact(contact)
	}
	
	func sendMyScore() {
		self.networkingEngine?.sendMyScore((self.gameLayer?.score)!)
	}
	
	// Called when a player send his score
	func receiveScore(score: Int, playerIndex: Int) {
		self.playersScores.append(PlayerScores(score: score, index: playerIndex))
		
		
		if self.playersScores.count == ((GameKitHelper.sharedInstance.multiplayerMatch?.players.count)! + 1) {
			
			let multableArray = NSMutableArray(array: self.playersScores)
			let sortByIndex = NSSortDescriptor(key: "index", ascending: true)
			let sortDescriptiors = [sortByIndex]
			multableArray.sortUsingDescriptors(sortDescriptiors)
			self.playersScores = NSArray(array: multableArray) as! [PlayerScores]
			
			for playerScore in self.playersScores {
				self.finalScores.append(playerScore.score)
			}
			
			var aliases = [String]()
			for index in 0...self.finalScores.count - 1 {
				aliases.append((self.networkingEngine?.orderOfPlayers[index].player.alias)!)
			}
			
			print("All players send their scores info to me, sending all info to everyone")
			networkingEngine?.sendScores(self.finalScores)
			
			self.gameOverLayer?.removeLoad()
			self.runAction(SKAction.waitForDuration(0.2), completion: {
				self.gameOverLayer?.showTwoPlayerScores(self.finalScores, players: aliases)
				self.isGameOver = true
			})
		}
	}
	
	func addMyScore() {
		self.playersScores.append(PlayerScores(score: (self.gameLayer?.score)!, index: self.currentIndex!))
	}
	
	func receiveAllScores(scores: [Int]) {
		self.finalScores = scores
		var aliases = [String]()
		for index in 0...self.finalScores.count - 1 {
			aliases.append((self.networkingEngine?.orderOfPlayers[index].player.alias)!)
			print("\nScores:\n\(aliases[index]): \(self.finalScores[index])")
		}
		
		self.gameOverLayer?.removeLoad()
		self.runAction(SKAction.waitForDuration(0.2), completion: {
			self.gameOverLayer?.showTwoPlayerScores(self.finalScores, players: aliases)
			self.isGameOver = true
		})
	}
	
	func pauseGame() {
		self.controlUnit?.alpha = 0
		
		self.gameOverLayer = GameOverLayer(size: (self.view?.bounds.size)!)
		self.gameOverLayer?.zPosition = 1_200
		
		self.hudLayer?.runAction(SKAction.fadeAlphaTo(0, duration: 0))
		self.runAction(SKAction.waitForDuration(0.1), completion: {
			
			let bluredTexture = SKTexture(image: self.getBluredScreenShot())
			
			self.scenesDelegate?.deinitControllersSystem()
			
			let bluredScreenShot = SKSpriteNode(texture: bluredTexture)
			bluredScreenShot.size = (self.view?.bounds.size)!
			bluredScreenShot.zPosition = 1_100
			bluredScreenShot.alpha = 0
			self.playerCamera!.addChild(bluredScreenShot)
			
			let fadeOut = SKAction.fadeAlphaTo(0, duration: 0.25)
			
			self.gameLayer?.runAction(fadeOut, completion: {
				self.gameLayer?.paused = true
			})
			self.backgroundLayer?.runAction(fadeOut, completion: {
				self.backgroundLayer?.paused = true
			})
			
			bluredScreenShot.runAction(SKAction.fadeAlphaTo(1, duration: 0.25))
			
			self.playerCamera?.addChild(self.gameOverLayer!)
		})
	}
	
	func sendScore() {
		self.networkingEngine?.sendMyScore((self.gameLayer?.score)!)
	}
	
	func getBluredScreenShot() -> UIImage {
		UIGraphicsBeginImageContextWithOptions((self.view?.bounds.size)!, false, 1)
		self.view?.drawViewHierarchyInRect((self.view?.frame)!, afterScreenUpdates: true)
		let screenShot = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		let gaussianBlurFilter = CIFilter(name: "CIGaussianBlur")
		gaussianBlurFilter?.setDefaults()
		gaussianBlurFilter?.setValue(CIImage(image: screenShot), forKey: kCIInputImageKey)
		gaussianBlurFilter?.setValue(7, forKey: kCIInputRadiusKey)
		
		let outputImage = gaussianBlurFilter?.outputImage
		let context = CIContext()
		var rect = outputImage?.extent
		rect?.origin.x += ((rect?.size.width)! - screenShot.size.width) / 2
		rect?.origin.y += ((rect?.size.height)! - screenShot.size.height) / 2
		rect?.size = (self.view?.bounds.size)!
		let cgImage = context.createCGImage(outputImage!, fromRect: rect!)
		let image = UIImage(CGImage: cgImage)
		
		return image
	}
	
	deinit {
		print("dealoc")
	}
}
