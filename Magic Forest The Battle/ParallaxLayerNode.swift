//
//  ParallaxLayerNode.swift
//  Magic Forest The Battle
//
//  Created by Camila Ribeiro Rodrigues on 07/12/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit

class ParallaxLayerNode: SKNode {
	
	var moveFactor : CGPoint?
	var positionOffset : CGPoint?
	var backOffset1 : CGFloat?
	var backOffset2 : CGFloat?
	var backgroundOne : SKSpriteNode?
	var backgroundTwo : SKSpriteNode?
	
	required init(name : String, moveFactor : CGPoint) {
		super.init()
		
		self.moveFactor = moveFactor
		self.backgroundOne = SKSpriteNode(imageNamed: name)
		self.backgroundOne!.texture?.filteringMode = SKTextureFilteringMode.Linear
//		self.backgroundOne?.anchorPoint = CGPointMake(0, 0)
		self.backOffset1 = 0
		self.addChild(self.backgroundOne!)
		
		self.backgroundTwo = SKSpriteNode(imageNamed: name)
//		self.backgroundTwo?.anchorPoint = CGPointMake(0, 0)
		self.backOffset2 = self.backgroundTwo?.size.width
		self.addChild(self.backgroundTwo!)
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func updatePosition(position : CGPoint){
		
		let destPoint = CGPointMake(position.x * self.moveFactor!.x, position.y*0.25 * self.moveFactor!.y)
		
		let desiredPositionOne = CGPointMake(destPoint.x + self.backOffset1!, destPoint.y)
		let desiredPositionTwo = CGPointMake(destPoint.x + self.backOffset2!, destPoint.y)
		
		
		if(desiredPositionOne.x < -self.backgroundOne!.size.width) {
			self.backOffset1 = self.backOffset1! + 2*self.backgroundOne!.size.width
		}
		else if(desiredPositionOne.x > self.backgroundOne!.size.width) {
			self.backOffset1 = self.backOffset1! + 2*self.backgroundOne!.size.width;
		}
		
		if(desiredPositionTwo.x < -self.backgroundTwo!.size.width) {
			self.backOffset2 = self.backOffset2! + 2*self.backgroundTwo!.size.width;
		}
		else if(desiredPositionTwo.x > self.backgroundTwo!.size.width) {
			self.backOffset2 = self.backOffset2! + 2*self.backgroundTwo!.size.width;
		}
		
		self.backgroundOne!.position = CGPointMake(destPoint.x + self.backOffset1!, destPoint.y);
		self.backgroundTwo!.position = CGPointMake(destPoint.x + self.backOffset2!, destPoint.y);
		
	}

}
