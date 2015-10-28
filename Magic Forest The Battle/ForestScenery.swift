//
//  ForestScenery.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class ForestScenery: BackgroundLayer, BasicLayer {
	
	var corner: CGPoint?
	
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
		
//		let screenRatio = size.width / size.height
	
		
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
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
}
