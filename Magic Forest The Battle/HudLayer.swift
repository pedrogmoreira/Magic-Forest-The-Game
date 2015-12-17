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
	
	private var scoreLabel = SKLabelNode(fontNamed: "SnapHand")
	
	var networkingEngine: MultiplayerNetworking?
	var matchEndDelegate: MatchEndDelegate?
	
	required init(size: CGSize) {
		super.init()
		//barra vida
		//barra do fundo
		self.size = size
        let padding = CGFloat(2)
		
		let backBars = SKSpriteNode(texture: SKTexture(imageNamed: "Barras"))
		backBars.position = CGPointMake(-size.width*0.48, size.height*0.42)
		backBars.zPosition = -1
		backBars.alpha = 0.8
		backBars.setScale(1.6)
		backBars.anchorPoint = CGPointMake(0, backBars.anchorPoint.y)
		self.addChild(backBars)
		
		
		let lifeBackBar = SKSpriteNode(texture: SKTexture(imageNamed: "GradeVida"))
        let halfLifeBackBarHeight = lifeBackBar.size.height/2
        lifeBackBar.position = CGPoint(x: 20, y: 0 + halfLifeBackBarHeight + padding)
		//lifeBackBar.setScale(0.3)
		lifeBackBar.zPosition = 0
		//lifeBackBar.alpha = 0.5
		lifeBackBar.anchorPoint = CGPointMake(0, lifeBackBar.anchorPoint.y)
        lifeBackBar.setScale(0.7)
		backBars.addChild(lifeBackBar)

		//coracao
//		let heart = SKSpriteNode(texture: SKTexture(imageNamed: "UI_HEART"))
//		heart.position = CGPointMake(33, 0)
//		heart.setScale(0.3)
//		heart.zPosition = 1
//		lifeBackBar.addChild(heart)
		
		//barra da frente
		lifeFrontBar = SKSpriteNode(texture: SKTexture(imageNamed: "PreenchimentoVida"))
		lifeFrontBar.position = CGPointMake(0, 0)
		//lifeFrontBar.xScale = 0.24
		lifeFrontBar.anchorPoint = CGPointMake(0, lifeFrontBar.anchorPoint.y)
		lifeFrontBar.zPosition = 1
		lifeBackBar.addChild(lifeFrontBar)
		
		//barra energia
		//barra do fundo
		let energyBackBar = SKSpriteNode(texture: SKTexture(imageNamed: "GradeEspecial"))
        let halfEnergyBackBarHeight = energyBackBar.size.height/2
        energyBackBar.position = CGPoint(x: 20, y: 0 - halfEnergyBackBarHeight - padding)
		//energyBackBar.setScale(0.3)
		energyBackBar.zPosition = 0
        energyBackBar.setScale(0.7)
		//energyBackBar.alpha = 0.5
		energyBackBar.anchorPoint = CGPointMake(0, lifeBackBar.anchorPoint.y)
		backBars.addChild(energyBackBar)
		
		//coracao
//		let energy = SKSpriteNode(texture: SKTexture(imageNamed: "UI_BOLT"))
//		energy.position = CGPointMake(33, 0)
//		energy.setScale(0.3)
//		energy.zPosition = 1
//		energyBackBar.addChild(energy)
		
		//barra da frente
		energyFrontBar = SKSpriteNode(texture: SKTexture(imageNamed: "PreenchimentoEspecial"))
		energyFrontBar.position = CGPointMake(0, 0)
		//energyFrontBar.xScale = 0.24
		energyFrontBar.zPosition = 1
		energyFrontBar.alpha = 0.5
		energyFrontBar.anchorPoint = CGPointMake(0, lifeFrontBar.anchorPoint.y)
		energyBackBar.addChild(energyFrontBar)
		
		if IS_ONLINE == true {
			self.createScoreLabel()
			self.timerGame()
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
		let changeToNormal = SKAction.setTexture(SKTexture(imageNamed:"PreenchimentoEspecial"))
		let changeToFlash = SKAction.setTexture(SKTexture(imageNamed: "barraEnergiaAtivada"))
		let wait = SKAction.waitForDuration(0.15)
		
		let seq = SKAction.sequence([changeToFlash,wait,changeToNormal,wait])
		self.energyFrontBar.runAction(SKAction.repeatActionForever(seq),withKey: "full")
	}
	
	func timerGame() {
		var timer = 2
		let timerLabel = SKLabelNode(text: "")
		//		let clock = SKSpriteNode(imageNamed: "Clock")
		//		self.addNode(clock, name: "clock", position: CGPoint(x: (self.size?.width)!/2.3, y: (self.size?.height)!/1.16))
		timerLabel.name = "timerLabel"
		timerLabel.fontName = "SnapHand"
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
	}
	
	func createScoreLabel () {
		self.scoreLabel = SKLabelNode(text: "Score: 0")
		self.scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right

		self.scoreLabel.name = "scoreLabel"
		self.scoreLabel.position =  CGPoint(x:self.size.width / 2 - frame.width / 2 - 10, y: self.size.height*0.4)
		self.addChild(self.scoreLabel)
	}
	
	func updateScoreLabel(withScore score: Int) {
		self.scoreLabel.text = "Score: \(score)"
		self.scoreLabel.position =  CGPoint(x:self.size.width / 2 - frame.width / 2 - 10, y: self.size.height*0.4)
	}

}
