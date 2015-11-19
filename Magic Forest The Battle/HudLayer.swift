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
	
	var energyFrontBar = SKSpriteNode()
	var lifeFrontBar = SKSpriteNode()
	
	required init(size: CGSize) {
		super.init()
		//barra vida
		//barra do fundo
		let lifeBackBar = SKSpriteNode(texture: SKTexture(imageNamed: "UI_ETCBAR"))
		lifeBackBar.position = CGPointMake(-size.width*0.48, size.height*0.45)
		lifeBackBar.setScale(0.3)
		lifeBackBar.zPosition = -1
		lifeBackBar.alpha = 0.5
		lifeBackBar.anchorPoint = CGPointMake(0, lifeBackBar.anchorPoint.y)
		self.addChild(lifeBackBar)

		//coracao
		let heart = SKSpriteNode(texture: SKTexture(imageNamed: "UI_HEART"))
		heart.position = CGPointMake(33, 0)
		heart.setScale(0.3)
		heart.zPosition = 1
		lifeBackBar.addChild(heart)
		
		//barra da frente
		lifeFrontBar = SKSpriteNode(texture: SKTexture(imageNamed: "UI_COLORBAR_RED"))
		lifeFrontBar.position = CGPointMake(70, 2)
		lifeFrontBar.xScale = 0.24
		lifeFrontBar.anchorPoint = CGPointMake(0, lifeFrontBar.anchorPoint.y)
		lifeFrontBar.zPosition = 0
		lifeBackBar.addChild(lifeFrontBar)
		
		//barra energia
		//barra do fundo
		let energyBackBar = SKSpriteNode(texture: SKTexture(imageNamed: "UI_ETCBAR"))
		energyBackBar.position = CGPointMake(-size.width*0.48, size.height*0.38)
		energyBackBar.setScale(0.3)
		energyBackBar.zPosition = -1
		energyBackBar.alpha = 0.5
		energyBackBar.anchorPoint = CGPointMake(0, lifeBackBar.anchorPoint.y)
		self.addChild(energyBackBar)
		
		//coracao
		let energy = SKSpriteNode(texture: SKTexture(imageNamed: "UI_BOLT"))
		energy.position = CGPointMake(33, 0)
		energy.setScale(0.3)
		energy.zPosition = 1
		energyBackBar.addChild(energy)
		
		//barra da frente
		energyFrontBar = SKSpriteNode(texture: SKTexture(imageNamed: "UI_COLORBAR_BLUE"))
		energyFrontBar.position = CGPointMake(70, 2)
		energyFrontBar.xScale = 0.24
		energyFrontBar.zPosition = 0
		energyFrontBar.anchorPoint = CGPointMake(0, lifeFrontBar.anchorPoint.y)
		energyBackBar.addChild(energyFrontBar)
		
		
	}
	
	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func animateBar (currentBar : CGFloat, bar : CGFloat, tipo : String) {
		let easeScale = SKAction.scaleXTo(((currentBar*100/bar)/100)*0.24, duration: 0.5)
		easeScale.timingMode = SKActionTimingMode.EaseInEaseOut
		self.lifeFrontBar.removeAllActions()
		if tipo == "life" {
			self.lifeFrontBar.runAction(easeScale)
		} else {
			self.energyFrontBar.runAction(easeScale)
		}
		
	}
	
	func animateFullBar () {
		if (energyFrontBar.actionForKey("full") != nil) {
			energyFrontBar.removeActionForKey("full")
		}
		let changeToNormal = SKAction(named: "UI_COLORBAR_BLUE")
		let changeToFlash = SKAction(named: "UI_COLORBAR_BLUE_FLASH")
		let wait = SKAction.waitForDuration(0.15)
		
		let seq = SKAction.sequence([changeToFlash!,wait,changeToNormal!,wait])
		energyFrontBar.runAction(SKAction.repeatActionForever(seq))
	}


}
