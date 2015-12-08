//
//  ForestScenery.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class ForestScenery: BackgroundLayer, BasicLayer {
	
	var background2: SKSpriteNode?
	var background3: SKSpriteNode?
	var background4: SKSpriteNode?
	
	var backgroundParallaxOne : ParallaxLayerNode?
	var backgroundParallaxTwo : ParallaxLayerNode?
	var backgroundParallaxThree : ParallaxLayerNode?
	var backgroundParallaxFour : ParallaxLayerNode?
	var backgroundParallaxFive : ParallaxLayerNode?
	
	let parallaxLayers = NSMutableArray()
	
	/**
	Initializes the forest scenery
	- parameter size: A reference to the device's screen size
	*/
	required init(size: CGSize) {
		super.init()
		
		self.screenSize = CGSize(width: size.width, height: size.height)
		
		self.background = SKSpriteNode(imageNamed: "ForestScenery_1")
		self.background2 = SKSpriteNode(imageNamed: "ForestScenery_2")
		self.background3 = SKSpriteNode(imageNamed: "ForestScenery_3")
		self.background4 = SKSpriteNode(imageNamed: "ForestScenery_4")
		self.lastBackground = SKSpriteNode(imageNamed: "ForestScenery_5")
//
//		// Background 1 Resize
		var xRatio =  DEFAULT_WIDTH / (self.background?.size.width)!
		var yRatio =  DEFAULT_HEIGHT / (self.background?.size.height)!
		var scale = CGFloat(4.2)
		
		self.background?.size = CGSize(width: (self.background?.size.width)! * xRatio * scale, height: (self.background?.size.height)! * yRatio * scale)
		
//		// Background 2 Resize
		xRatio =  DEFAULT_WIDTH / (self.background2?.size.width)!
		yRatio =  DEFAULT_HEIGHT / (self.background2?.size.height)!
		scale = CGFloat(4.3)
//
		self.background2?.size = CGSize(width: (self.background2?.size.width)! * xRatio * scale, height: (self.background2?.size.height)! * yRatio * scale)
//
		// Background 3 Resize
		xRatio =  DEFAULT_WIDTH / (self.background3?.size.width)!
		yRatio =  DEFAULT_HEIGHT / (self.background3?.size.height)!
		scale = CGFloat(4.4)
		
		self.background3?.size = CGSize(width: (self.background3?.size.width)! * xRatio * scale, height: (self.background3?.size.height)! * yRatio * scale)

		// Background 4 Resize
		xRatio =  DEFAULT_WIDTH / (self.background4?.size.width)!
		yRatio =  DEFAULT_HEIGHT / (self.background4?.size.height)!
		scale = CGFloat(4.5)
		
		self.background4?.size = CGSize(width: (self.background4?.size.width)! * xRatio * scale, height: (self.background4?.size.height)! * yRatio * scale)
		
		// Background 5 Resize
		xRatio =  DEFAULT_WIDTH / (self.lastBackground?.size.width)!
		yRatio =  DEFAULT_HEIGHT / (self.lastBackground?.size.height)!
		scale = CGFloat(4.6)
		
		self.lastBackground?.size = CGSize(width: (self.lastBackground?.size.width)! * xRatio * scale, height: (self.lastBackground?.size.height)! * yRatio * scale)
		
		self.background?.zPosition = -90
		self.background2?.zPosition = -80
		self.background3?.zPosition = -70
		self.background4?.zPosition = -60
		self.lastBackground?.zPosition = -50
		
		self.addChild(self.background!)
		self.addChild(self.background2!)
		self.addChild(self.background3!)
		self.addChild(self.background4!)
		self.addChild(self.lastBackground!)
		
//		self.createParallaxLayers()
		
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: (self.background?.frame)!)
		self.physicsBody?.categoryBitMask = PhysicsCategory.WorldBox.rawValue
		self.physicsBody?.collisionBitMask = 0
		self.physicsBody?.contactTestBitMask = 0
		
		self.generatePlatforms()
		self.createGroundDeathCollider()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func generatePlatforms() {
		var x = CGFloat(0)
		var y = CGFloat(0)
		
		let originX = (self.background?.frame.origin.x)!
		let originY = (self.background?.frame.origin.y)!
		let width = (self.background?.frame.width)!
//		let height = (self.background?.frame.height)!
		
		let space = width / 8
		
		// Platforms instantiation
		let baseLPlatform = self.generateQuadruplePlatform(PhysicsCategory.WorldBaseFloorPlatform)
		let baseCPlatform = self.generateTriplePlatform(PhysicsCategory.WorldBaseFloorPlatform)
		let baseRPlatform = self.generateQuadruplePlatform(PhysicsCategory.WorldBaseFloorPlatform)
		
		let firstFloorLPlatfom = self.generateSinglePlatform(PhysicsCategory.WorldFirstFloorPlatform)
        
		let secondFLoorLPlatform = self.generateDoublePlatform(PhysicsCategory.WorldSecondFloorPlatform)
		let secondFloorRPlatform = self.generateQuadruplePlatform(PhysicsCategory.WorldSecondFloorPlatform)
		
		let thirdFloorLPlatform = self.generateDoublePlatform(PhysicsCategory.WorldThirdFloorPlatform)
		let thirdFloorCPlatform = self.generateTriplePlatform(PhysicsCategory.WorldThirdFloorPlatform)
		let thirdFloorRPlatform = self.generateTriplePlatform(PhysicsCategory.WorldThirdFloorPlatform)
		
		
		// Platforms configuration
		firstFloorLPlatfom.zPosition = -15
		
		// Platforms positioning
		
		y = originY + space
		
		baseLPlatform.position = CGPoint(x: originX + space + baseLPlatform.size.width * 0.5 , y: y - baseLPlatform.size.height * 0.3)
		baseCPlatform.position = CGPoint(x: baseLPlatform.position.x +  baseLPlatform.size.width * 0.5 + baseCPlatform.size.width * 0.5 + space * 0.6, y: y  + baseCPlatform.size.height / 4)
		baseRPlatform.position = CGPoint(x: baseCPlatform.position.x +  baseCPlatform.size.width * 0.5 + baseRPlatform.size.width * 0.5 + space * 0.6, y: y)
		firstFloorLPlatfom.position = CGPoint(x: baseLPlatform.position.x, y: baseLPlatform.position.y + firstFloorLPlatfom.size.height * 0.7)

		x = ( (baseLPlatform.position.x + baseLPlatform.size.width / 2) - (baseCPlatform.position.x - baseCPlatform.size.width / 2) ) / 2 - secondFLoorLPlatform.size.width / 2
		y = originY + space * 2 - secondFLoorLPlatform.size.height * 0.25
		
		secondFLoorLPlatform.position = CGPoint(x: x, y: y  - secondFLoorLPlatform.size.height / 5)
		
		x = baseRPlatform.position.x - baseRPlatform.size.width / 2
		secondFloorRPlatform.position = CGPoint(x: x, y: y)
		
		y = secondFLoorLPlatform.position.y + space - thirdFloorLPlatform.size.height * 0.45
		
		thirdFloorLPlatform.position = CGPoint(x: firstFloorLPlatfom.position.x - space * 0.6, y: y)
		
		x = secondFLoorLPlatform.position.x + secondFLoorLPlatform.size.width / 2
		y = secondFLoorLPlatform.position.y + space - thirdFloorCPlatform.size.height * 0.35
		
		thirdFloorCPlatform.position = CGPoint(x: x, y: y)
		
		x = x + thirdFloorCPlatform.size.width / 2 + space * 1.8
		
		thirdFloorRPlatform.position = CGPoint(x: x, y: y - thirdFloorRPlatform.size.height * 0.3)
		
		// Adding platforms to scenery
		self.addChild(baseLPlatform)
		self.addChild(baseCPlatform)
		self.addChild(baseRPlatform)
		
		self.addChild(firstFloorLPlatfom)
		
		self.addChild(secondFLoorLPlatform)
		self.addChild(secondFloorRPlatform)
		
		self.addChild(thirdFloorLPlatform)
		self.addChild(thirdFloorCPlatform)
		self.addChild(thirdFloorRPlatform)
		
		// Setting global variable for the lower platform of each floor
		BackgroundLayer.firstFloor = firstFloorLPlatfom
		BackgroundLayer.secondFloor = secondFLoorLPlatform
		BackgroundLayer.thirdFloor = thirdFloorRPlatform
	}
	
	func createGroundDeathCollider() {
		
		let size = CGSize(width: self.background!.size.width * 4, height: self.background!.size.height * 0.02)
		
		let groundDeathCollider = SKSpriteNode(color: UIColor.purpleColor(), size: size)
		groundDeathCollider.position = CGPoint(x: 0,y: -self.background!.size.height / 2 + size.height / 2)
		
		let physicsBody = SKPhysicsBody(rectangleOfSize: size)
		physicsBody.categoryBitMask = PhysicsCategory.DeathBox.rawValue
		physicsBody.collisionBitMask = 0
		physicsBody.contactTestBitMask = PhysicsCategory.Player.rawValue
		physicsBody.dynamic = false
		
		groundDeathCollider.physicsBody = physicsBody
		
		groundDeathCollider.alpha = 0
		
		self.addChild(groundDeathCollider)
	}
	
	func createParallaxLayers(){
		
		self.backgroundParallaxOne = ParallaxLayerNode(name: "ForestScenery_1", moveFactor: CGPoint(x: 0.3,y: 0.2))
		self.backgroundParallaxTwo = ParallaxLayerNode(name: "ForestScenery_2", moveFactor: CGPoint(x: 0.4,y: 0.1))
		self.backgroundParallaxThree = ParallaxLayerNode(name: "ForestScenery_3", moveFactor: CGPointMake(0.5,0.2))
		self.backgroundParallaxFour = ParallaxLayerNode(name: "ForestScenery_4", moveFactor: CGPointMake(0.4,0.5))
		self.backgroundParallaxFive = ParallaxLayerNode(name: "ForestScenery_5", moveFactor: CGPointMake(0,0))
		
		self.parallaxLayers.addObject(self.backgroundParallaxOne!)
		self.parallaxLayers.addObject(self.backgroundParallaxTwo!)
		self.parallaxLayers.addObject(self.backgroundParallaxThree!)
		self.parallaxLayers.addObject(self.backgroundParallaxFour!)
		self.parallaxLayers.addObject(self.backgroundParallaxFive!)
		
		self.addChild(self.backgroundParallaxOne!)
		self.addChild(self.backgroundParallaxTwo!)
		self.addChild(self.backgroundParallaxThree!)
		self.addChild(self.backgroundParallaxFour!)
		self.addChild(self.backgroundParallaxFive!)
		
		self.backgroundParallaxOne?.zPosition = -90
		self.backgroundParallaxTwo?.zPosition = -80
		self.backgroundParallaxThree?.zPosition = -70
		self.backgroundParallaxFour?.zPosition = -60
		self.backgroundParallaxFive?.zPosition = -50
		
	}
	
	func updateParallaxWithPosition (position : CGPoint){
		
		for layer in self.parallaxLayers{
			
			(layer as! ParallaxLayerNode).updatePosition(position)
			
		}
		
	}
	
}
