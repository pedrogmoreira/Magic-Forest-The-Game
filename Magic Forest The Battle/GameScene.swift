//
//  GameScene.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright (c) 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, MultiplayerProtocol {
	
	var backgroundLayer: BackgroundLayer?
	var gameLayer: GameLayer?
    var playerCamera: SKCameraNode?
    
    // Multiplayer variables
    var networkingEngine: MultiplayerNetworking?
    var currentIndex: Int?
    var players = [Player]()
	
	/**
	Initializes the game scene
	- parameter size: A reference to the device's screen size
	*/
	override init(size: CGSize) {
		super.init(size: size)
		
	}
    
    override func didMoveToView(view: SKView) {
        self.gameLayer = GameLayer(size: size, networkingEngine:  self.networkingEngine!)
        self.gameLayer?.zPosition = -5
//        self.networkingEngine?.createPlayers()
        
        self.backgroundLayer = ForestScenery(size: size)
        self.backgroundLayer?.zPosition = -10
        
        self.addChild(self.gameLayer!)
        self.addChild(self.backgroundLayer!)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        self.initializeCamera()
    }
    
    private func initializeCamera(){
        self.playerCamera = SKCameraNode()
		
		self.playerCamera?.setScale(1.3)
		
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
        
        let screenHeight = (self.view?.frame.size.height)!
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
        let screenWidth = self.size.width
        
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
    
    // Called when the match has ended
    func matchEnded() {
        
    }
    
    func startGame() {
        
    }
    
    func attack() {
        self.gameLayer?.attack()
    }
    
	func createPlayer(indexes: [Int]) {
		print("create players")
        self.gameLayer?.createPlayer(indexes)
    }
    
    
    // Set the player index
    func setCurrentPlayerIndex(index: Int) {
        currentIndex = index
    }
}
