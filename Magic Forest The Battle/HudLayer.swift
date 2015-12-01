//
//  HudLayer.swift
//  Magic Forest The Battle
//
//  Created by Camila Ribeiro Rodrigues on 18/11/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit

protocol MatchEndDelegate {
	func pauseGame()
	func sendScore()
	func addMyScore()
}

class HudLayer: SKNode, BasicLayer {
	
	var energyFrontBar = SKSpriteNode()
	var lifeFrontBar = SKSpriteNode()
	var size = CGSize()
	
	private var scoreLabel: SKLabelNode?
	
	var networkingEngine: MultiplayerNetworking?
	var matchEndDelegate: MatchEndDelegate?
	
	required init(size: CGSize) {
		super.init()
		//barra vida
		//barra do fundo
		self.size = size
		timerGame()
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
		
		if IS_ONLINE == true {
			self.createScoreLabel()
		}
		
	}
	
	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func animateBar(currentBar : CGFloat, bar : CGFloat, node : SKSpriteNode, scale : CGFloat) {
		let easeScale = SKAction.scaleXTo(((currentBar*100/bar)/100)*scale, duration: 0.1)
		easeScale.timingMode = SKActionTimingMode.EaseInEaseOut
		//self.lifeFrontBar.removeAllActions()
		node.runAction(easeScale)
	}
	
	func animateFullBar() {
		if (energyFrontBar.actionForKey("full") != nil) {
			energyFrontBar.removeActionForKey("full")
		}
		let changeToNormal = SKAction.setTexture(SKTexture(imageNamed:"UI_COLORBAR_BLUE"))
		let changeToFlash = SKAction.setTexture(SKTexture(imageNamed: "UI_COLORBAR_BLUE_FLASH"))
		let wait = SKAction.waitForDuration(0.15)
		
		let seq = SKAction.sequence([changeToFlash,wait,changeToNormal,wait])
		self.energyFrontBar.runAction(SKAction.repeatActionForever(seq),withKey: "full")
	}
	
	func timerGame() {
		var timer = 90
		let timerLabel = SKLabelNode(text: "")
		//		let clock = SKSpriteNode(imageNamed: "Clock")
		//		self.addNode(clock, name: "clock", position: CGPoint(x: (self.size?.width)!/2.3, y: (self.size?.height)!/1.16))
		timerLabel.name = "timerLabel"
		timerLabel.position =  CGPoint(x:0, y: self.size.height*0.4)
		self.addChild(timerLabel)
		let counter = SKAction.waitForDuration(1)
		
		let sequence = SKAction.sequence([counter, SKAction.runBlock({ () -> Void in
			timer--
			timerLabel.text = String(timer)
		})])
		
		let repeatAction = SKAction.repeatAction(sequence, count: timer)
		self.runAction(repeatAction) { () -> Void in
			print("Pausou")

			if self.networkingEngine?.isPlayer1 == false && IS_ONLINE == true {
				self.matchEndDelegate?.sendScore()
			} else if self.networkingEngine?.isPlayer1 == true && IS_ONLINE == true {
				self.matchEndDelegate?.addMyScore()
			}
			
			self.matchEndDelegate?.pauseGame()
		}
		//pause game
	}
	
	func createScoreLabel () {
		self.scoreLabel = SKLabelNode(text: "Score: 0")
		self.scoreLabel!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right

		self.scoreLabel!.name = "scoreLabel"
		self.scoreLabel!.position =  CGPoint(x:self.size.width / 2 - frame.width / 2 - 10, y: self.size.height*0.4)
		self.addChild(self.scoreLabel!)
	}
	
	func updateScoreLabel(withScore score: Int) {
		self.scoreLabel?.text = "Score: \(score)"
		self.scoreLabel!.position =  CGPoint(x:self.size.width / 2 - frame.width / 2 - 10, y: self.size.height*0.4)
	}

}
