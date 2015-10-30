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
		var scale = CGFloat(4.2)
		
		self.background?.size = CGSize(width: (self.background?.size.width)! * xRatio * scale, height: (self.background?.size.height)! * yRatio * scale)
		
		// Background 2 Resize
		xRatio =  size.width / (self.background2?.size.width)!
		yRatio =  size.height / (self.background2?.size.height)!
		scale = CGFloat(4.3)
		
		self.background2?.size = CGSize(width: (self.background2?.size.width)! * xRatio * scale, height: (self.background2?.size.height)! * yRatio * scale)
		
		// Background 3 Resize
		xRatio =  size.width / (self.background3?.size.width)!
		yRatio =  size.height / (self.background3?.size.height)!
		scale = CGFloat(4.4)
		
		self.background3?.size = CGSize(width: (self.background3?.size.width)! * xRatio * scale, height: (self.background3?.size.height)! * yRatio * scale)
		
		// Background 4 Resize
		xRatio =  size.width / (self.background4?.size.width)!
		yRatio =  size.height / (self.background4?.size.height)!
		scale = CGFloat(4.5)
		
		self.background4?.size = CGSize(width: (self.background4?.size.width)! * xRatio * scale, height: (self.background4?.size.height)! * yRatio * scale)
		
		// Background 5 Resize
		xRatio =  size.width / (self.background5?.size.width)!
		yRatio =  size.height / (self.background5?.size.height)!
		scale = CGFloat(4.6)
		
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
		
		self.generatePlatforms()
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func generatePlatforms() {
		let originX = (self.background?.frame.origin.x)!
		let originY = (self.background?.frame.origin.y)!
		let width = (self.background?.frame.width)!
		let height = (self.background?.frame.height)!
		
		let edgeRight = originX + width / 2
		let edgeLeft = originX - width / 2
		let edgeTop = originY + height / 2
		let edgeBottom = originY - height / 2
		
		let space = width / 8
		
		// Platforms instantiation
		let baseLPlatform = self.generateQuadruplePlatform()
		let baseCPlatform = self.generateTriplePlatform()
		let baseRPlatform = self.generateQuadruplePlatform()
		
		// Platforms positioning
		baseLPlatform.position = CGPoint(x: originX + space + baseLPlatform.size.width * 0.5 , y: originY + space + baseLPlatform.size.height * 0.5)
		baseCPlatform.position = CGPoint(x: baseLPlatform.position.x +  baseLPlatform.size.width * 0.5 + baseCPlatform.size.width * 0.5 + space * 0.6, y: baseLPlatform.position.y)
		baseRPlatform.position = CGPoint(x: baseCPlatform.position.x +  baseCPlatform.size.width * 0.5 + baseRPlatform.size.width * 0.5 + space * 0.6, y: baseLPlatform.position.y)
		
		// Adding platforms to scenery
		self.addChild(baseLPlatform)
		self.addChild(baseCPlatform)
		self.addChild(baseRPlatform)
	}
	
	private func generateSimplePlatform() -> SKSpriteNode {
		let left = SKSpriteNode(imageNamed: "ForestSceneryPlatformLeft")
		let right = left.copy() as! SKSpriteNode
		right.runAction(SKAction.scaleXBy(-1, y: 1, duration: 0))
		
		let width = left.frame.width + right.frame.width
		let height = left.frame.height
		let size = CGSize(width: width, height: height)
		
		let simplePlatform = SKSpriteNode(color: UIColor.clearColor(), size: size)
		simplePlatform.color = UIColor.blackColor()
		simplePlatform.addChild(left)
		simplePlatform.addChild(right)
		
		left.position = CGPoint(x: -width / 2 + left.frame.width / 2, y: 0)
		right.position = CGPoint(x: left.position.x + right.size.width, y: 0)
		
		simplePlatform.setScale(0.4)
		simplePlatform.zPosition = -6
		
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		return simplePlatform
	}
	
	private func generateSinglePlatform() -> SKSpriteNode {
		let left = SKSpriteNode(imageNamed: "ForestSceneryPlatformLeft")
		let center = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let right = SKSpriteNode(imageNamed: "ForestSceneryPlatformRight")
		
		let width = left.frame.width + right.frame.width + center.frame.width
		let height = left.frame.height
		let size = CGSize(width: width, height: height)
		
		let singlePlatform = SKSpriteNode(color: UIColor.clearColor(), size: size)
		singlePlatform.addChild(left)
		singlePlatform.addChild(center)
		singlePlatform.addChild(right)
		
		left.position = CGPoint(x: -width / 2 + left.frame.width / 2, y: 0)
		center.position = CGPoint(x: left.position.x + left.size.width, y: 0)
		right.position = CGPoint(x: center.position.x + center.size.width, y: 0)
		
		singlePlatform.setScale(0.4)
		singlePlatform.zPosition = -6
		
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		center.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		return singlePlatform
	}
	
	private func generateDoublePlatform() -> SKSpriteNode {
		let left = SKSpriteNode(imageNamed: "ForestSceneryPlatformLeft")
		let centerL = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let centerR = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let right = SKSpriteNode(imageNamed: "ForestSceneryPlatformRight")
		
		let width = left.frame.width + right.frame.width + centerL.frame.width + centerR.frame.width
		let height = left.frame.height
		let size = CGSize(width: width, height: height)
		
		let doublePlatform = SKSpriteNode(color: UIColor.clearColor(), size: size)
		doublePlatform.addChild(left)
		doublePlatform.addChild(centerL)
		doublePlatform.addChild(centerR)
		doublePlatform.addChild(right)
		
		left.position = CGPoint(x: -width / 2 + left.frame.width / 2, y: 0)
		centerL.position = CGPoint(x: left.position.x + left.size.width, y: 0)
		centerR.position = CGPoint(x: centerL.position.x + centerL.size.width, y: 0)
		right.position = CGPoint(x: centerR.position.x + centerR.size.width, y: 0)
		
		doublePlatform.setScale(0.4)
		doublePlatform.zPosition = -6
		
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerL.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerR.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		return doublePlatform
	}
	
	private func generateTriplePlatform() -> SKSpriteNode {
		let left = SKSpriteNode(imageNamed: "ForestSceneryPlatformLeft")
		let centerL = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let centerC = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let centerR = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let right = SKSpriteNode(imageNamed: "ForestSceneryPlatformRight")
		
		let width = left.frame.width + right.frame.width + centerL.frame.width + centerC.frame.width + centerR.frame.width
		let height = left.frame.height
		let size = CGSize(width: width, height: height)
		
		let triplePlatform = SKSpriteNode(color: UIColor.clearColor(), size: size)
		triplePlatform.addChild(left)
		triplePlatform.addChild(centerL)
		triplePlatform.addChild(centerC)
		triplePlatform.addChild(centerR)
		triplePlatform.addChild(right)
		
		left.position = CGPoint(x: -width / 2 + left.frame.width / 2, y: 0)
		centerL.position = CGPoint(x: left.position.x + left.size.width, y: 0)
		centerC.position = CGPoint(x: centerL.position.x + centerL.size.width, y: 0)
		centerR.position = CGPoint(x: centerC.position.x + centerC.size.width, y: 0)
		right.position = CGPoint(x: centerR.position.x + centerR.size.width, y: 0)
		
		triplePlatform.setScale(0.4)
		triplePlatform.zPosition = -6
		
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerL.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerC.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerR.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		return triplePlatform
	}
	
	private func generateQuadruplePlatform() -> SKSpriteNode {
		let left = SKSpriteNode(imageNamed: "ForestSceneryPlatformLeft")
		let centerL = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let centerCL = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let centerCR = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let centerR = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let right = SKSpriteNode(imageNamed: "ForestSceneryPlatformRight")
		
		let width = left.frame.width + right.frame.width + centerL.frame.width + centerCL.frame.width + centerCR.frame.width + centerR.frame.width
		let height = left.frame.height
		let size = CGSize(width: width, height: height)
		
		let quadruplePlatform = SKSpriteNode(color: UIColor.clearColor(), size: size)
		quadruplePlatform.addChild(left)
		quadruplePlatform.addChild(centerL)
		quadruplePlatform.addChild(centerCL)
		quadruplePlatform.addChild(centerCR)
		quadruplePlatform.addChild(centerR)
		quadruplePlatform.addChild(right)
		
		left.position = CGPoint(x: -width / 2 + left.frame.width / 2, y: 0)
		centerL.position = CGPoint(x: left.position.x + left.size.width, y: 0)
		centerCL.position = CGPoint(x: centerL.position.x + centerL.size.width, y: 0)
		centerCR.position = CGPoint(x: centerCL.position.x + centerCL.size.width, y: 0)
		centerR.position = CGPoint(x: centerCR.position.x + centerCR.size.width, y: 0)
		right.position = CGPoint(x: centerR.position.x + centerR.size.width, y: 0)
		
		quadruplePlatform.setScale(0.4)
		quadruplePlatform.zPosition = -6
		
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerL.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerCL.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerCR.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerR.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		return quadruplePlatform
	}
	
}
