//
//  GameScene.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright (c) 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
	
	var backgroundLayer: BackgroundLayer?
	var gameLayer: GameLayer?
    var playerCamera: SKCameraNode?
	
	/**
	Initializes the game scene
	- parameter size: A reference to the device's screen size
	*/
	override init(size: CGSize) {
		super.init(size: size)
		
		self.gameLayer = GameLayer(size: size)
		self.gameLayer?.zPosition = -5
		
		self.backgroundLayer = VulcanScenery(size: size)
		self.backgroundLayer?.zPosition = -10
		
		self.addChild(self.gameLayer!)
		self.addChild(self.backgroundLayer!)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        
        self.initializeCamera()
	}
    
    private func initializeCamera(){
        self.playerCamera = SKCameraNode()
        self.camera = self.playerCamera
    }

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func update(currentTime: NSTimeInterval) {
		self.gameLayer?.update(currentTime)
	}
    
    //FIXME: The two next methods has duplicated code. They need to be refactored
    
    // Set the Y position of camera
    private func cameraPositionYAxis(){
        // The camera usually follows the player...
        let playerYPosition = (self.gameLayer?.player?.position.y)!;
        self.playerCamera?.position.y = playerYPosition
        
        let screenHeight = (self.view?.frame.size.height)!
        let backgroundHeight = self.backgroundLayer?.background?.size.height
        let cameraYPosition = self.playerCamera!.position.y

        //... but if player comes too close to an edge the camera stops to follow
        if cameraYPosition < -(backgroundHeight!/2) + screenHeight/2 {
            self.playerCamera?.position.y = -(backgroundHeight!/2) + screenHeight/2
        } else if cameraYPosition > (backgroundHeight!/2) - screenHeight/2 {
            self.playerCamera?.position.y = (backgroundHeight!/2) - screenHeight/2
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
        if cameraXPosition < -(backgroundWidth!/2) + screenWidth/2 {
            self.playerCamera?.position.x = -(backgroundWidth!/2) + screenWidth/2
        } else if cameraXPosition > backgroundWidth!/2 - screenWidth/2 {
            self.playerCamera?.position.x = backgroundWidth!/2 - screenWidth/2
        }
        
    }
    
    override func didFinishUpdate() {
        self.cameraPositionYAxis()
        self.cameraPositionXAxis()
    }
}
