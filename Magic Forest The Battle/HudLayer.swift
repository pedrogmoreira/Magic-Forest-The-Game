//
//  HudLayer.swift
//  Magic Forest The Battle
//
//  Created by Camila Ribeiro Rodrigues on 18/11/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit
class HudLayer: SKNode, BasicLayer {
	
	var lifeFrontBar2 = SKSpriteNode()
	var lifeFrontBar = SKSpriteNode()
	
	required init(size: CGSize) {
		super.init()
		//barra vida
		//barra do fundo
		let lifeBackBar = SKSpriteNode(texture: SKTexture(imageNamed: "UI_ETCBAR"))
		lifeBackBar.position = CGPointMake(-size.width*0.4, size.height*0.45)
		lifeBackBar.setScale(0.3)
		lifeBackBar.zPosition = -1
		lifeBackBar.alpha = 0.5
		self.addChild(lifeBackBar)

		//coracao
		let heart = SKSpriteNode(texture: SKTexture(imageNamed: "UI_HEART"))
		heart.position = CGPointMake(-145, 0)
		heart.setScale(0.3)
		heart.zPosition = 1
		lifeBackBar.addChild(heart)
		
		//barra da frente
		lifeFrontBar = SKSpriteNode(texture: SKTexture(imageNamed: "UI_COLORBAR_RED"))
		lifeFrontBar.position = CGPointMake(25, 2)
		lifeFrontBar.xScale = 0.24
		lifeFrontBar.zPosition = 0
		lifeBackBar.addChild(lifeFrontBar)
		
		//barra energia
		//barra do fundo
		let lifeBackBar2 = SKSpriteNode(texture: SKTexture(imageNamed: "UI_ETCBAR"))
		lifeBackBar2.position = CGPointMake(-size.width*0.4, size.height*0.38)
		lifeBackBar2.setScale(0.3)
		lifeBackBar2.zPosition = -1
		lifeBackBar2.alpha = 0.5
		self.addChild(lifeBackBar2)
		
		//coracao
		let energy = SKSpriteNode(texture: SKTexture(imageNamed: "UI_BOLT"))
		energy.position = CGPointMake(-145, 0)
		energy.setScale(0.3)
		energy.zPosition = 1
		lifeBackBar2.addChild(energy)
		
		//barra da frente
		lifeFrontBar2 = SKSpriteNode(texture: SKTexture(imageNamed: "UI_COLORBAR_BLUE"))
		lifeFrontBar2.position = CGPointMake(25, 2)
		lifeFrontBar2.xScale = 0.24
		lifeFrontBar2.zPosition = 0
		lifeBackBar2.addChild(lifeFrontBar2)
		
		
	}
	
	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
//	func animateBar (currentBar : CGFloat, bar : CGFloat) {
//		var easeScale = SKAction.scaleXTo((currentBar*100/bar), duration: 0.5)
//		
//	}
	
//	func animateFullBar () {
//		if (lifeFrontBar2.actionForKey("full") != nil) {
//			lifeFrontBar2.removeActionForKey("full")
//		}
//		let changeToNormal = SKAction(named: "UI_COLORBAR_BLUE")
//		let changeToFlash = SKAction(named: "UI_COLORBAR_BLUE_FLASH")
//		let wait = SKAction.waitForDuration(0.15)
//		
//		let seq = SKAction.sequence([changeToFlash!,wait,changeToNormal!,wait])
//		lifeFrontBar2.runAction(SKAction.repeatActionForever(seq))
//	}


}
