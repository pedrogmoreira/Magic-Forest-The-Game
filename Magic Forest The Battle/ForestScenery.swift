//
//  ForestScenery.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class ForestScenery: BackgroundLayer, BasicLayer {
	
	/**
	Initializes the forest scenery
	- parameter size: A reference to the device's screen size
	*/
	required init(size: CGSize) {
		super.init()
		
		self.background = SKSpriteNode(color: UIColor.greenColor(), size: size)
		
		self.addChild(self.background!)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
}
