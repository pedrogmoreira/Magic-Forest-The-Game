//
//  BackgroundLayer.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class BackgroundLayer: SKNode {
	
	var background: SKSpriteNode?
    var lastBackground: SKSpriteNode?
	
	func generateSimplePlatform() -> SKSpriteNode {
		let left = SKSpriteNode(imageNamed: "ForestSceneryPlatformLeft")
		let right = left.copy() as! SKSpriteNode
		right.runAction(SKAction.scaleXBy(-1, y: 1, duration: 0))
		
		let width = left.frame.width + right.frame.width
		let height = left.frame.height
		let size = CGSize(width: width, height: height)
		
		let simplePlatform = SKSpriteNode(color: UIColor.clearColor(), size: size)
		simplePlatform.addChild(left)
		simplePlatform.addChild(right)
		
		left.position = CGPoint(x: -width / 2 + left.frame.width / 2, y: 0)
		right.position = CGPoint(x: left.position.x + right.size.width, y: 0)
		
		simplePlatform.setScale(0.4)
		simplePlatform.zPosition = -10
		
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		simplePlatform.physicsBody = self.generatePhysicsBody(simplePlatform.size)
		
		return simplePlatform
	}
	
	func generateSinglePlatform() -> SKSpriteNode {
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
		singlePlatform.zPosition = -10
		
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		center.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		singlePlatform.physicsBody = self.generatePhysicsBody(singlePlatform.size)
		
		return singlePlatform
	}
	
	func generateDoublePlatform() -> SKSpriteNode {
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
		doublePlatform.zPosition = -10
		
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerL.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerR.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		doublePlatform.physicsBody = self.generatePhysicsBody(doublePlatform.size)
		
		return doublePlatform
	}
	
	func generateTriplePlatform() -> SKSpriteNode {
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
		triplePlatform.zPosition = -10
		
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerL.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerC.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerR.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		triplePlatform.physicsBody = self.generatePhysicsBody(triplePlatform.size)
		
		return triplePlatform
	}
	
	func generateQuadruplePlatform() -> SKSpriteNode {
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
		quadruplePlatform.zPosition = -10
		
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerL.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerCL.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerCR.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerR.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		quadruplePlatform.physicsBody = self.generatePhysicsBody(quadruplePlatform.size)
		
		return quadruplePlatform
	}
	
	func generatePhysicsBody(var size: CGSize) -> SKPhysicsBody {
		size = CGSize(width: size.width, height: size.height * 0.6)
		
		let physicsBody = SKPhysicsBody(rectangleOfSize: size)
		physicsBody.dynamic = false
		
		return physicsBody
	}
}

