//
//  MenuSelectPlayer.swift
//  Magic Forest The Battle
//
//  Created by Camila Ribeiro Rodrigues on 12/11/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit
	var playerSelected = ""
class MenuSelectPlayer: SKNode, UIGestureRecognizerDelegate {

	private var label = SKLabelNode()
	private var size: CGSize?
	private var view: SKView?
	private var currentScreen: Screen?
	
	var controlUnit: MFCSControlUnit?
	var controllerMode: MFCSControllerMode?
	
	private let timer = SKLabelNode(text: "")
	
	private let playButton = SKSpriteNode(imageNamed: "playButton.gif")
	//Selecionar personagens
	private let neithSelection = SKSpriteNode(imageNamed: "NeithIdle1")
	private let uhongSelection = SKSpriteNode(imageNamed: "idle1")
	private let salamangSelction = SKSpriteNode(imageNamed: "SalamangIdlee1")
	
	//Imagem personagens
	private let neithImage = SKSpriteNode(imageNamed: "archercute")
	private let uhongImage = SKSpriteNode(imageNamed: "mushroom")
	private let salamangImage = SKSpriteNode(imageNamed: "wizardcute")
	private let dinakImage = SKSpriteNode(imageNamed: "monkey")
	
	//Status dos personagens
	
	private let neithLabelStatus = SKLabelNode(text: "Neith Status")
	private let uhongLabelStatus = SKLabelNode(text: "Uhong Status")
	private let salamangLabelStatus = SKLabelNode(text: "Salamang Status")
	private let dinakLabelSatus = SKLabelNode(text: "Dinak Status")
	
	
	//Sobre os personagens
	private let neithLabelAbout = SKLabelNode(text: "Eu sou uma arqueira")
	private let uhongLabelAbout = SKLabelNode(text: "Eu sou um lutador")
	private let salamangLabelAbout = SKLabelNode(text: "Eu sou um mago")
	private let dinakLabelAbout = SKLabelNode(text: "Eu sou um macaco louco")

	/**
	Initializes the menu select Player
	- parameter size: A reference to the device's screen size
	- parameter view: A reference to the current view
	*/
	init(size: CGSize, view: SKView) {
		super.init()
		
		self.size = size
		self.view = view
		
		self.currentScreen = Screen.middleScreen
		
		self.addToLayer()
		self.timerSelecPlayer()
		self.fontEdit()
		self.imageEdit()

	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	 // Add a button to the layer with a position
	private func addNode(node: SKSpriteNode, name: String, position: CGPoint) {
		node.position = position
		node.name = name
		self.addChild(node)
	}
	private func addLabelNode(node: SKLabelNode, name: String, position: CGPoint) {
		node.position = position
		node.name = name
		self.addChild(node)
	}
	func fontEdit () {
		//Label Status
		self.neithLabelStatus.fontSize = 12
		self.uhongLabelStatus.fontSize = 12
		self.dinakLabelSatus.fontSize = 12
		self.salamangLabelStatus.fontSize = 12
		
		//About Status
		self.neithLabelAbout.fontSize = 12
		self.uhongLabelAbout.fontSize = 12
		self.dinakLabelAbout.fontSize = 12
		self.salamangLabelAbout.fontSize = 12
		
	
	}
	func imageEdit () {
		self.neithImage.setScale(0.2)
		self.uhongImage.setScale(0.2)
		self.salamangImage.setScale(0.2)
		self.dinakImage.setScale(0.2)
	}
	private func addToLayer () {
		// Adding play Button
		self.playButton.setScale(0.5)
		let playButtonPosition = CGPoint(x: self.size!.width/1.2 , y: self.size!.height/5)
		addNode(self.playButton,name: "playbutton", position: playButtonPosition)
		//Add selecionar personagens
		//Neith
		let neithSelectionPosition = CGPoint(x: self.size!.width/5, y: self.size!.height/2.5)
		addNode(neithSelection, name: "neithSelectionPosition", position: neithSelectionPosition)
		let uhongSelectionPosition = CGPoint(x: self.size!.width/5, y: self.size!.height/1.5)
		addNode(uhongSelection, name: "uhongSelectionPosition", position: uhongSelectionPosition)
		let salamangSelctionPosition = CGPoint(x: self.size!.width/2.5, y: self.size!.height/2.5)
		addNode(salamangSelction, name: "salamangSelctionPosition", position: salamangSelctionPosition)
	}
	// TODO: Refactor star game method.
	private func startGame() {
		let gameScene = GameScene(size: self.size!)
		self.view?.presentScene(gameScene, transition: SKTransition.flipHorizontalWithDuration(2))
		
		self.controllerMode = MFCSControllerMode.JoystickAndSwipe
		
		self.controlUnit = MFCSControlUnit(frame: self.view!.frame, delegate: gameScene.gameLayer!, controllerMode: controllerMode!)
		
		self.view?.addSubview(self.controlUnit!)
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		// Getting a node in the touch location
		let touch = touches.first
		let touchLocation = touch?.locationInNode(self)
		let nodeTouched = self.nodeAtPoint(touchLocation!)
		let nodeName = nodeTouched.name
	//	let shape = SKShapeNode(rectOfSize: size!)
		self.removeActionsPlayers()
		self.removeAllStatus()
		self.removeAllImages()
		self.removeAllAbout()
		if nodeName == "neithSelectionPosition" {
			playerSelected = "Neith"
			self.selectPlayer(neithSelection)
			self.addLabelNode(neithLabelStatus, name: "neithLabelStatus", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.5))
			self.addLabelNode(neithLabelAbout, name: "neithLabelAbout", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.8))
			self.addNode(neithImage, name: "neithImage", position: CGPoint(x: self.size!.width/1.1, y: self.size!.height/1.5))
			print(nodeName)
		} else if nodeName == "uhongSelectionPosition" {
			print(nodeName)
			playerSelected = "Uhong"
			self.selectPlayer(uhongSelection)
			self.addLabelNode(uhongLabelStatus, name: "uhongLabelStatus", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.5))
			self.addLabelNode(uhongLabelAbout, name: "uhongLabelAbout", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.8))
			self.addNode(uhongImage, name: "uhongImage", position: CGPoint(x: self.size!.width/1.1, y: self.size!.height/1.5))
		} else if nodeName == "salamangSelctionPosition" {
			print(nodeName)
			self.selectPlayer(salamangSelction)
			playerSelected = "Salamang"
			self.addLabelNode(salamangLabelAbout, name: "salamangLabelAbout", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.8))
			self.addLabelNode(salamangLabelStatus, name: "salamangLabelStatus", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.5))
			self.addNode(salamangImage, name: "salamangImage", position: CGPoint(x: self.size!.width/1.1, y: self.size!.height/1.5))
		} else if nodeName == "dinakSelecionPosition"{
			self.addLabelNode(dinakLabelAbout, name: "dinakLabelAbout", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.8))
			self.addLabelNode(dinakLabelSatus, name: "dinakLabelSatus", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.5))
			self.addNode(dinakImage, name: "dinakImage", position: CGPoint(x: self.size!.width/1.1, y: self.size!.height/1.5))
			print(nodeName)
			playerSelected = "Dinak"
			
		} else if nodeName == "playbutton" {
			print("play")
			startGame()
			
		}
	}
	
	func selectPlayer (node : SKSpriteNode) {
		let normalScale = SKAction.scaleTo(1, duration: 0.5)
		let bigScale = SKAction.scaleTo(1.5, duration: 0.5)
		let sequence = SKAction.sequence([bigScale,normalScale])
		let repeatSequence = SKAction.repeatActionForever(sequence)
		node.runAction(repeatSequence)
	}
	
	func timerSelecPlayer () {
		var timer = 30
		let timerLabel = SKLabelNode(text: "")
		self.addLabelNode(timerLabel, name: "timerLabel", position: CGPoint(x: (self.size?.width)!/2, y: (self.size?.height)!/1.2))
		let counter = SKAction.waitForDuration(1)
		let sequence = SKAction.sequence([counter, SKAction.runBlock({ () -> Void in
			timer--
			timerLabel.text = String(timer)
			
		})])
		let repeatAction = SKAction.repeatAction(sequence, count: 30)
		runAction(repeatAction) { () -> Void in
			self.startGame()
		}
	}
	func removeActionsPlayers () {
		self.neithSelection.removeAllActions()
		self.uhongSelection.removeAllActions()
		self.salamangSelction.removeAllActions()
		self.neithSelection.setScale(1)
		self.uhongSelection.setScale(1)
		self.salamangSelction.setScale(1)
	}
	func removeAllStatus () {
		self.neithLabelStatus.removeFromParent()
		self.salamangLabelStatus.removeFromParent()
		self.uhongLabelStatus.removeFromParent()
		self.dinakLabelSatus.removeFromParent()
	}
	func removeAllImages () {
		self.neithImage.removeFromParent()
		self.salamangImage.removeFromParent()
		self.uhongImage.removeFromParent()
		self.dinakImage.removeFromParent()
		
	}
	
	func removeAllAbout () {
		self.neithLabelAbout.removeFromParent()
		self.uhongLabelAbout.removeFromParent()
		self.salamangLabelAbout.removeFromParent()
		self.dinakLabelAbout.removeFromParent()
	}

	
}