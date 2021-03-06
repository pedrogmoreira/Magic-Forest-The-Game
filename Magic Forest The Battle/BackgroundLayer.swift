//
//  BackgroundLayer.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class BackgroundLayer: SKNode {
	
	static var firstFloor: SKSpriteNode?
	static var secondFloor: SKSpriteNode?
	static var thirdFloor: SKSpriteNode?
	
	var background: SKSpriteNode?
    var lastBackground: SKSpriteNode?
	
	var screenSize: CGSize?
	
	private let scale = CGFloat(0.15)
	
	/**
	Generate a simple platform
	- parameter categoryBitmask: The platform categty bitmask
	*/
	func generateSimplePlatform(categoryBitmask: PhysicsCategory) -> SKSpriteNode {
		let left = SKSpriteNode(imageNamed: "ForestSceneryPlatformLeft")
		let right = left.copy() as! SKSpriteNode
		right.runAction(SKAction.scaleXBy(-1, y: 1, duration: 0))
		
		// Resize
		left.size = resize(left)
		right.size = resize(right)
		
		// Sizing variables
		let width = left.frame.width + right.frame.width
		let height = left.frame.height
		let size = CGSize(width: width, height: height)
		
		// Reposition
		left.position = CGPoint(x: -width / 2 + left.frame.width / 2, y: 0)
		right.position = CGPoint(x: left.position.x + right.size.width, y: 0)
		
		// Recolouring
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		// Platform
		let simplePlatform = SKSpriteNode(color: UIColor.clearColor(), size: size)
		simplePlatform.addChild(left)
		simplePlatform.addChild(right)
		simplePlatform.physicsBody = self.generatePhysicsBody(simplePlatform.size, categoryBitmask: categoryBitmask)
		simplePlatform.zPosition = -10
		
		
		return simplePlatform
	}
	
	/**
	Generate a single platform
	- parameter categoryBitmask: The platform categty bitmask
	*/
	func generateSinglePlatform(categoryBitmask: PhysicsCategory) -> SKSpriteNode {
		let left = SKSpriteNode(imageNamed: "ForestSceneryPlatformLeft")
		let center = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let right = SKSpriteNode(imageNamed: "ForestSceneryPlatformRight")
		
		// Resize
		left.size = resize(left)
		right.size = resize(right)
		center.size = resize(center)
		
		// Sizing variables
		let width = left.frame.width + right.frame.width + center.frame.width
		let height = left.frame.height
		let size = CGSize(width: width, height: height)

		// Reposition
		left.position = CGPoint(x: -width / 2 + left.frame.width / 2, y: 0)
		center.position = CGPoint(x: left.position.x + left.size.width, y: 0)
		right.position = CGPoint(x: center.position.x + center.size.width, y: 0)

		// Recolouring
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		center.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		// Platform
		let singlePlatform = SKSpriteNode(color: UIColor.clearColor(), size: size)
		singlePlatform.addChild(left)
		singlePlatform.addChild(center)
		singlePlatform.addChild(right)
		singlePlatform.physicsBody = self.generatePhysicsBody(singlePlatform.size, categoryBitmask: categoryBitmask)
		singlePlatform.zPosition = -10
		
		return singlePlatform
	}
	
	/**
	Generate a double platform
	- parameter categoryBitmask: The platform categty bitmask
	*/
	func generateDoublePlatform(categoryBitmask: PhysicsCategory) -> SKSpriteNode {
		let left = SKSpriteNode(imageNamed: "ForestSceneryPlatformLeft")
		let centerL = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let centerR = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let right = SKSpriteNode(imageNamed: "ForestSceneryPlatformRight")
		
		// Resize
		left.size = resize(left)
		right.size = resize(right)
		centerL.size = resize(centerL)
		centerR.size = resize(centerR)
		
		// Sizing variables
		let width = left.frame.width + right.frame.width + centerL.frame.width + centerR.frame.width
		let height = left.frame.height
		let size = CGSize(width: width, height: height)

		// Repositioning
		left.position = CGPoint(x: -width / 2 + left.frame.width / 2, y: 0)
		centerL.position = CGPoint(x: left.position.x + left.size.width, y: 0)
		centerR.position = CGPoint(x: centerL.position.x + centerL.size.width, y: 0)
		right.position = CGPoint(x: centerR.position.x + centerR.size.width, y: 0)
		
		// Recolouring
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerL.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerR.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		// Platform
		let doublePlatform = SKSpriteNode(color: UIColor.clearColor(), size: size)
		doublePlatform.addChild(left)
		doublePlatform.addChild(centerL)
		doublePlatform.addChild(centerR)
		doublePlatform.addChild(right)
		doublePlatform.physicsBody = self.generatePhysicsBody(doublePlatform.size, categoryBitmask: categoryBitmask)
		doublePlatform.zPosition = -10
		
		return doublePlatform
	}
	
	/**
	Generate a triple platform
	- parameter categoryBitmask: The platform categty bitmask
	*/
	func generateTriplePlatform(categoryBitmask: PhysicsCategory) -> SKSpriteNode {
		let left = SKSpriteNode(imageNamed: "ForestSceneryPlatformLeft")
		let centerL = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let centerC = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let centerR = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let right = SKSpriteNode(imageNamed: "ForestSceneryPlatformRight")
		
		// Resize
		left.size = resize(left)
		right.size = resize(right)
		centerL.size = resize(centerL)
		centerC.size = resize(centerC)
		centerR.size = resize(centerR)
		
		// Sizing variables
		let width = left.frame.width + right.frame.width + centerL.frame.width + centerC.frame.width + centerR.frame.width
		let height = left.frame.height
		let size = CGSize(width: width, height: height)
		
		// Repositioning
		left.position = CGPoint(x: -width / 2 + left.frame.width / 2, y: 0)
		centerL.position = CGPoint(x: left.position.x + left.size.width, y: 0)
		centerC.position = CGPoint(x: centerL.position.x + centerL.size.width, y: 0)
		centerR.position = CGPoint(x: centerC.position.x + centerC.size.width, y: 0)
		right.position = CGPoint(x: centerR.position.x + centerR.size.width, y: 0)
		
		// Recolouring
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerL.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerC.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerR.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		// Platform
		let triplePlatform = SKSpriteNode(color: UIColor.clearColor(), size: size)
		triplePlatform.addChild(left)
		triplePlatform.addChild(centerL)
		triplePlatform.addChild(centerC)
		triplePlatform.addChild(centerR)
		triplePlatform.addChild(right)
		triplePlatform.physicsBody = self.generatePhysicsBody(triplePlatform.size, categoryBitmask: categoryBitmask)
		triplePlatform.zPosition = -10
		
		return triplePlatform
	}
	
	/**
	Generate a quadruple platform
	- parameter categoryBitmask: The platform categty bitmask
	*/
	func generateQuadruplePlatform(categoryBitmask: PhysicsCategory) -> SKSpriteNode {
		let left = SKSpriteNode(imageNamed: "ForestSceneryPlatformLeft")
		let centerL = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let centerCL = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let centerCR = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let centerR = SKSpriteNode(imageNamed: "ForestSceneryPlatformCenter")
		let right = SKSpriteNode(imageNamed: "ForestSceneryPlatformRight")
		
		// Resize
		left.size = resize(left)
		right.size = resize(right)
		centerL.size = resize(centerL)
		centerCL.size = resize(centerCL)
		centerCR.size = resize(centerCR)
		centerR.size = resize(centerR)
		
		// Sizing variables
		let width = left.frame.width + right.frame.width + centerL.frame.width + centerCL.frame.width + centerCR.frame.width + centerR.frame.width
		let height = left.frame.height
		let size = CGSize(width: width, height: height)
		
		// Reposition
		left.position = CGPoint(x: -width / 2 + left.frame.width / 2, y: 0)
		centerL.position = CGPoint(x: left.position.x + left.size.width, y: 0)
		centerCL.position = CGPoint(x: centerL.position.x + centerL.size.width, y: 0)
		centerCR.position = CGPoint(x: centerCL.position.x + centerCL.size.width, y: 0)
		centerR.position = CGPoint(x: centerCR.position.x + centerCR.size.width, y: 0)
		right.position = CGPoint(x: centerR.position.x + centerR.size.width, y: 0)
		
		// Recolouring
		left.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerL.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerCL.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerCR.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		centerR.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		right.runAction(SKAction.colorizeWithColor(UIColor.brownColor(), colorBlendFactor: 1, duration: 0))
		
		// Platform
		let quadruplePlatform = SKSpriteNode(color: UIColor.clearColor(), size: size)
		quadruplePlatform.addChild(left)
		quadruplePlatform.addChild(centerL)
		quadruplePlatform.addChild(centerCL)
		quadruplePlatform.addChild(centerCR)
		quadruplePlatform.addChild(centerR)
		quadruplePlatform.addChild(right)
		quadruplePlatform.physicsBody = self.generatePhysicsBody(quadruplePlatform.size, categoryBitmask: categoryBitmask)
		quadruplePlatform.zPosition = -10
		
		return quadruplePlatform
	}
	
	/**
	Resizes the platform to a screen proportion and scaled down to 7%
	- parameter screenSize: The device screen size
	*/
	private func resize(spriteNode: SKSpriteNode) -> CGSize {
		// Resize
		let widthRatio =  DEFAULT_WIDTH / spriteNode.size.width
		let spriteRatio =  spriteNode.size.width / spriteNode.size.height
		
		
		let width = spriteNode.size.width * widthRatio * self.scale
		let height = width / spriteRatio
		
		return CGSize(width: width, height: height)
	}
	
	/**
	Generates a physic body with 90% of original width and 40% of original height. Made for Platforms
	- parameter size: The platform size
	- parameter categoryBitmask: The platform category bitmask
	*/
	private func generatePhysicsBody(var size: CGSize, categoryBitmask: PhysicsCategory) -> SKPhysicsBody {
		size = CGSize(width: size.width * 0.8, height: size.height * 0.4)
		
		let physicsBody = SKPhysicsBody(rectangleOfSize: size)
		physicsBody.categoryBitMask = categoryBitmask.rawValue
		physicsBody.collisionBitMask = 0
		physicsBody.contactTestBitMask = 0
        physicsBody.restitution = 0
		physicsBody.dynamic = false
		
		return physicsBody
	}
}

