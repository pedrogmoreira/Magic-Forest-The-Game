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
	var background5: SKSpriteNode?
	
	/**
	Initializes the forest scenery
	- parameter size: A reference to the device's screen size
	*/
	required init(size: CGSize) {
		super.init()
		
		self.background = SKSpriteNode(imageNamed: "ForestScenery_1")
		self.background2 = SKSpriteNode(imageNamed: "ForestScenery_2")
		self.background3 = SKSpriteNode(imageNamed: "ForestScenery_3")
		self.background4 = SKSpriteNode(imageNamed: "ForestScenery_4")
		self.background5 = SKSpriteNode(imageNamed: "ForestScenery_5")
		
		// Background 1 Resize
		var xRatio =  size.width / (self.background?.size.width)!
		var yRatio =  size.height / (self.background?.size.height)!
		var scale = CGFloat(1)
		
		self.background?.size = CGSize(width: (self.background?.size.width)! * xRatio * scale, height: (self.background?.size.height)! * yRatio * scale)
		
		// Background 2 Resize
		xRatio =  size.width / (self.background2?.size.width)!
		yRatio =  size.height / (self.background2?.size.height)!
		scale = CGFloat(1.1)
		
		self.background2?.size = CGSize(width: (self.background2?.size.width)! * xRatio * scale, height: (self.background2?.size.height)! * yRatio * scale)
		
		// Background 3 Resize
		xRatio =  size.width / (self.background3?.size.width)!
		yRatio =  size.height / (self.background3?.size.height)!
		scale = CGFloat(1.2)
		
		self.background3?.size = CGSize(width: (self.background3?.size.width)! * xRatio * scale, height: (self.background3?.size.height)! * yRatio * scale)
		
		// Background 4 Resize
		xRatio =  size.width / (self.background4?.size.width)!
		yRatio =  size.height / (self.background4?.size.height)!
		scale = CGFloat(1.3)
		
		self.background4?.size = CGSize(width: (self.background4?.size.width)! * xRatio * scale, height: (self.background4?.size.height)! * yRatio * scale)
		
		// Background 5 Resize
		xRatio =  size.width / (self.background5?.size.width)!
		yRatio =  size.height / (self.background5?.size.height)!
		scale = CGFloat(1.4)
		
		self.background5?.size = CGSize(width: (self.background5?.size.width)! * xRatio * scale, height: (self.background5?.size.height)! * yRatio * scale)
		
		self.background?.zPosition = -11
		self.background2?.zPosition = -10
		self.background3?.zPosition = -9
		self.background4?.zPosition = -8
		self.background5?.zPosition = -7
		
		self.addChild(self.background!)
		self.addChild(self.background2!)
		self.addChild(self.background3!)
		self.addChild(self.background4!)
		self.addChild(self.background5!)
        
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: (self.background?.frame)!)
		
		self.addChild(self.generateDoublePlatform())
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func generateSimplePlatform() -> SKSpriteNode {
		let left = SKSpriteNode(imageNamed: "ForestSceneryPlatformLeft")
		let right = left.copy() as! SKSpriteNode
		right.runAction(SKAction.scaleXBy(-1, y: 1, duration: 0))
		
		let simplePlatform = SKSpriteNode()
		simplePlatform.color = UIColor.blackColor()
		simplePlatform.addChild(left)
		simplePlatform.addChild(right)
		
		right.position = CGPoint(x: right.size.width, y: 0)
		
		simplePlatform.setScale(0.4)
		
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		return simplePlatform
	}
	
	private func generateSinglePlatform() -> SKSpriteNode {
		let left = SKSpriteNode(imageNamed: "ForestSceneryPlatformLeft")
		let center = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let right = SKSpriteNode(imageNamed: "ForestSceneryPlatformRight")
		
		let simplePlatform = SKSpriteNode()
		simplePlatform.addChild(left)
		simplePlatform.addChild(center)
		simplePlatform.addChild(right)
		
		center.position = CGPoint(x: left.size.width, y: 0)
		right.position = CGPoint(x: left.size.width + center.size.width, y: 0)
		
		simplePlatform.setScale(0.4)
		
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		center.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		return simplePlatform
	}
	
	private func generateDoublePlatform() -> SKSpriteNode {
		let left = SKSpriteNode(imageNamed: "ForestSceneryPlatformLeft")
		let centerL = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let centerR = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let right = SKSpriteNode(imageNamed: "ForestSceneryPlatformRight")
		
		let doublePlatform = SKSpriteNode()
		doublePlatform.addChild(left)
		doublePlatform.addChild(centerL)
		doublePlatform.addChild(centerR)
		doublePlatform.addChild(right)
		
		centerL.position = CGPoint(x: left.size.width, y: 0)
		centerR.position = CGPoint(x: centerL.position.x + centerL.size.width, y: 0)
		right.position = CGPoint(x: centerR.position.x + centerR.size.width, y: 0)
		
		doublePlatform.setScale(0.4)
		
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerL.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerR.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		return doublePlatform
	}
	
}
