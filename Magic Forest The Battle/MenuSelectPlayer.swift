//
//  MenuSelectPlayer.swift
//  Magic Forest The Battle
//
//  Created by Camila Ribeiro Rodrigues on 12/11/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit

class MenuSelectPlayer: SKNode {
    
    var playerSelected = ""

	private var label = SKLabelNode()
	private var size: CGSize?
	private var view: SKView?

	var controlUnit: MFCSControlUnit?
	var controllerMode: MFCSControllerMode?
	var networkDelegate: MultiplayerNetworking?
	
	private let timer = SKLabelNode(text: "")
	
	private let playButton = SKSpriteNode(imageNamed: "PlayButton.png")
    private var isNotReady: Bool?
	
	var scenesDelegate: ScenesDelegate?
	
	//Fundo
//	private let fundoLU = SKSpriteNode(imageNamed: "UI_WINDOW (8)")
//	private let fundoRU = SKSpriteNode(imageNamed: "UI_WINDOW (7)")
//	private let fundoLD = SKSpriteNode(imageNamed: "UI_WINDOW (2)")
//	private let fundoRD = SKSpriteNode(imageNamed: "UI_WINDOW (4)")
//	private let fundoUp = SKSpriteNode(imageNamed: "UI_WINDOW (9)")
//	private let fundoDown = SKSpriteNode(imageNamed: "UI_WINDOW (3)")
//	private let fundoML = SKSpriteNode(imageNamed: "UI_WINDOW (6)")
//	private let fundoMR = SKSpriteNode(imageNamed: "UI_WINDOW (5)")
//	private let fundoC = SKSpriteNode(imageNamed: "UI_WINDOW (1)")
	
	//Selecionar personagens
	private let neithSelection = SKSpriteNode(imageNamed: "NeithIdle1")
	private let uhongSelection = SKSpriteNode(imageNamed: "CogumeloParado1")
	private let salamangSelction = SKSpriteNode(imageNamed: "SalamangParado1")
	private let dinakSelection = SKSpriteNode(imageNamed: "idle1")
	
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
        self.isNotReady = true
		super.init()
		
		self.size = size
		self.view = view
				
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
		self.uhongSelection.setScale(0.3)
		self.salamangSelction.setScale(0.3)
		
		self.neithImage.setScale(0.2)
		self.uhongImage.setScale(0.2)
		self.salamangImage.setScale(0.2)
		self.dinakImage.setScale(0.05)
	}
    
	private func addToLayer () {
		// Adding play Button
		self.playButton.setScale(0.5)
		let playButtonPosition = CGPoint(x: self.size!.width/1.2 , y: self.size!.height/5)
		addNode(self.playButton,name: "playbutton", position: playButtonPosition)
		//Add selecionar personagens
		//Neith
//		let neithSelectionPosition = CGPoint(x: self.size!.width/5, y: self.size!.height/2.5)
//		addNode(neithSelection, name: "neithSelectionPosition", position: neithSelectionPosition)
		let uhongSelectionPosition = CGPoint(x: self.size!.width/5, y: self.size!.height/1.5)
		addNode(uhongSelection, name: "uhongSelectionPosition", position: uhongSelectionPosition)
		let salamangSelctionPosition = CGPoint(x: self.size!.width/2.5, y: self.size!.height/2.5)
		addNode(salamangSelction, name: "salamangSelctionPosition", position: salamangSelctionPosition)
//		let dinakSelectionPosition = CGPoint(x: self.size!.width/2.5, y: self.size!.height/1.5)
//		addNode(dinakSelection, name: "dinakSelectionPosition", position: dinakSelectionPosition)
	}
	
	// TODO: Refactor star game method.
	private func startGame() {
		if IS_ONLINE == false {
			let gameScene = GameScene(size: self.size!)
            gameScene.playerSelected = self.playerSelected
			scenesDelegate?.showGameScene(gameScene)
		} else {
			print("sending player: \(self.selectedCharacter())")
			networkDelegate?.sendChosenCharacter(self.selectedCharacter())
		}
	}
	
	func selectedCharacter() -> CharacterType {
        
        var selectedCharacterType = CharacterType.Uhong
        
		switch playerSelected {
		case "Neith":
			selectedCharacterType = CharacterType.Neith
		case "Uhong":
			selectedCharacterType = CharacterType.Uhong
		case "Salamang":
			selectedCharacterType = CharacterType.Salamang
		case "Dinak":
			selectedCharacterType = CharacterType.Dinak
		default:
            
			print("Invalid selected character")
		}
        
        return selectedCharacterType
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		// Getting a node in the touch location
        
        if self.isNotReady! == false {
            return
        }
        
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
			self.selectPlayer(neithSelection,normalScale: 1, bigScale: 1.5)
			self.addLabelNode(neithLabelStatus, name: "neithLabelStatus", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.5))
			self.addLabelNode(neithLabelAbout, name: "neithLabelAbout", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.8))
			self.addNode(neithImage, name: "neithImage", position: CGPoint(x: self.size!.width/1.1, y: self.size!.height/1.5))
			print("Selected character: \(nodeName)")
		} else if nodeName == "uhongSelectionPosition" {
			playerSelected = "Uhong"
			self.selectPlayer(uhongSelection, normalScale: 0.3, bigScale: 0.5)
//			self.addLabelNode(uhongLabelStatus, name: "uhongLabelStatus", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.5))
//			self.addLabelNode(uhongLabelAbout, name: "uhongLabelAbout", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.8))
//			self.addNode(uhongImage, name: "uhongImage", position: CGPoint(x: self.size!.width/1.1, y: self.size!.height/1.5))
            print("Selected character: \(nodeName)")
		} else if nodeName == "salamangSelctionPosition" {
			self.selectPlayer(salamangSelction,normalScale: 0.3, bigScale: 0.5)
			playerSelected = "Salamang"
			self.selectPlayer(salamangSelction,normalScale: 0.3, bigScale: 0.5)
//			self.addLabelNode(salamangLabelAbout, name: "salamangLabelAbout", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.8))
//			self.addLabelNode(salamangLabelStatus, name: "salamangLabelStatus", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.5))
//			self.addNode(salamangImage, name: "salamangImage", position: CGPoint(x: self.size!.width/1.1, y: self.size!.height/1.5))
            print("Selected character: \(nodeName)")
		} else if nodeName == "dinakSelectionPosition"{
			self.addLabelNode(dinakLabelAbout, name: "dinakLabelAbout", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.8))
			self.addLabelNode(dinakLabelSatus, name: "dinakLabelSatus", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.5))
			self.addNode(dinakImage, name: "dinakImage", position: CGPoint(x: self.size!.width/1.1, y: self.size!.height/1.5))
			print("Selected character: \(nodeName)")
			playerSelected = "Dinak"
			
		} else if nodeName == "playbutton" {
			print("Touched play button")
            isNotReady = false
			startGame()
		}
	}
	
	func selectPlayer (node : SKSpriteNode, normalScale: CGFloat, bigScale: CGFloat) {
		let normalScale = SKAction.scaleTo(normalScale, duration: 0.3)
		let bigScale = SKAction.scaleTo(bigScale, duration: 0.3)
		let sequence = SKAction.sequence([bigScale,normalScale])
		let repeatSequence = SKAction.repeatActionForever(sequence)
		node.runAction(repeatSequence)
	}
    
	func timerSelecPlayer () {
		var timer = 30
		let timerLabel = SKLabelNode(text: "")
//		let clock = SKSpriteNode(imageNamed: "Clock")
//		self.addNode(clock, name: "clock", position: CGPoint(x: (self.size?.width)!/2.3, y: (self.size?.height)!/1.16))
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
		self.uhongSelection.setScale(0.3)
		self.salamangSelction.setScale(0.3)
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
