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
	
	/**
	Initializes the game scene
	- parameter size: A reference to the device's screen size
	*/
	override init(size: CGSize) {
		super.init(size: size)
		
		self.gameLayer = GameLayer(size: size)
		self.gameLayer?.zPosition = -5
		
		self.backgroundLayer = ForestScenery(size: size)
		self.backgroundLayer?.zPosition = -10
		self.backgroundLayer?.position = CGPoint(x: size.width / 2, y: size.height / 2)
		
		self.addChild(self.gameLayer!)
		self.addChild(self.backgroundLayer!)
        
        self.physicsWorld.contactDelegate = self
        self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	override func update(currentTime: NSTimeInterval) {
		self.gameLayer?.update(currentTime)
	}
	
}
