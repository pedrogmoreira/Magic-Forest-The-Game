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
	
	private let playButton = SKSpriteNode(imageNamed: "BotaoVazioJogar")
	private let playLabel = SKLabelNode(text: NSLocalizedString("Play", comment: "Play Button String"))
    private var isNotReady: Bool?
	
	var scenesDelegate: ScenesDelegate?
	
	//Selecionar personagens
	private let neithSelection = SKSpriteNode(imageNamed: "NeithIdle1")
	
	
	private let backUhongSelection = SKSpriteNode(imageNamed: "JogadorVazioSelectPlayer")
	private let frontUhongSelection = SKSpriteNode(imageNamed: "CogumeloParado1")
	private let backSalamangSelction = SKSpriteNode(imageNamed: "JogadorVazioSelectPlayer")
	private let frontSalamangSelction = SKSpriteNode(imageNamed: "SalamangParado1")
	private let dinakSelection = SKSpriteNode(imageNamed: "idle1")
	private let backRandomSelection = SKSpriteNode(imageNamed: "JogadorVazioSelectPlayer")
	private let frontRandomSelection = SKSpriteNode(imageNamed: "DuvidasButton")
	
	//Imagem personagens
	private let neithImage = SKSpriteNode(imageNamed: "archercute")
	private let uhongImage = SKSpriteNode(imageNamed: "mushroom")
	private let salamangImage = SKSpriteNode(imageNamed: "wizardcute")
	private let dinakImage = SKSpriteNode(imageNamed: "monkey")
	
	//Status dos personagens
    private let neithLabelStatus = SKLabelNode(text: "Neith")
	private let uhongLabelStatus = SKLabelNode(text: "UHONG")
	private let salamangLabelStatus = SKLabelNode(text: "SALAMANG")
	private let dinakLabelSatus = SKLabelNode(text: "Dinak")
	private let random = SKLabelNode(text: NSLocalizedString("RandomCharacter2", comment: "Random Chraracter Label String"))
	private let character = SKLabelNode(text:  NSLocalizedString("RandomCharacter1", comment: "Random Chraracter Label String"))
	
	
	//Sobre os personagens
	private let neithLabelAbout = SKLabelNode(text: "Eu sou uma arqueira")
	private let uhongLabelAbout = SKLabelNode(text: "Eu sou um lutador")
	private let salamangLabelAbout = SKLabelNode(text: "Eu sou um mago")
	private let dinakLabelAbout = SKLabelNode(text: "Eu sou um macaco louco")

	private let fundo = SKSpriteNode(imageNamed: "FundoSelectPlayer")
	
	//Status e caracteristicas
	private let barraQualidade1 = SKSpriteNode(imageNamed: "BarraQualidade1")
	private let barraQualidade2 = SKSpriteNode(imageNamed: "BarraQualidade2")
	private let barraQualidade3 = SKSpriteNode(imageNamed: "BarraQualidade3")
    private let barraQualidade3Segunda = SKSpriteNode(imageNamed: "BarraQualidade3")
	private let barraQualidade4 = SKSpriteNode(imageNamed: "BarraQualidade4")
	private let barraQualidade4Segunda = SKSpriteNode(imageNamed: "BarraQualidade4")
	private let barraQualidade5 = SKSpriteNode(imageNamed: "BarraQualidade5")
	
	private let ataque = SKLabelNode(text: NSLocalizedString("Attack", comment: "Attack Label String"))
	private let vida = SKLabelNode(text: NSLocalizedString("Life", comment: "Life Label String"))
	private let velocidade = SKLabelNode(text: NSLocalizedString("Speed", comment: "Speed Label String"))
    
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
		self.imageEdit()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
    
    // Add a button to the layer with a position
	private func addNode(node: SKSpriteNode, name: String, position: CGPoint, zPosition:CGFloat) {
		node.position = position
		node.name = name
		node.zPosition = zPosition
		self.addChild(node)
	}
	
	private func addLabelNode(node: SKLabelNode, name: String, position: CGPoint, zPosition:CGFloat, alpha: CGFloat, fontSize: CGFloat, fontName: String) {
		node.position = position
		node.name = name
		node.zPosition = zPosition
		node.alpha = alpha
		node.fontSize = fontSize
		node.fontName = fontName
		self.addChild(node)
	}
	
	func imageEdit () {
		self.backUhongSelection.setScale(1.8)
		self.frontUhongSelection.setScale(0.3)
		self.backSalamangSelction.setScale(1.8)
		self.frontSalamangSelction.setScale(0.5)
		self.backRandomSelection.setScale(1.8)
		self.frontRandomSelection.setScale(1.8)
		
		self.neithImage.setScale(0.2)
		self.uhongImage.setScale(0.2)
		self.salamangImage.setScale(0.2)
		self.dinakImage.setScale(0.05)
	}
    
	private func addToLayer () {
		
		//Adding background
		addNode(fundo, name: "fundo", position: CGPointMake(self.size!.width/2, self.size!.height/2), zPosition: -1)
        let xBackgroundScale = self.size!.width/self.fundo.size.width
        let yBackgroundScale = self.size!.height/self.fundo.size.height
		fundo.xScale = xBackgroundScale
        fundo.yScale = yBackgroundScale
		
		// Adding play Button
		self.playButton.setScale(1.5)
        let halfPlayButtonWidth = playButton.size.width/2
        let halfPlayButtonHeight = playButton.size.height/2
        let padding = CGFloat(17)
		let playButtonPosition = CGPoint(x: self.size!.width - halfPlayButtonWidth + padding, y: 0 + halfPlayButtonHeight - padding)
		addNode(self.playButton,name: "playbutton", position: playButtonPosition, zPosition: 1)
		addLabelNode(playLabel, name: "playbutton", position: CGPointMake(playButtonPosition.x, playButtonPosition.y/1.4), zPosition: 2, alpha: 0.8, fontSize: 50, fontName: "SnapHand")
		//Add selecionar personagens
		//Neith
		let uhongSelectionPosition = CGPoint(x: self.size!.width*0.15, y: self.size!.height/1.5)
		addNode(backUhongSelection, name: "uhongSelectionPosition", position: uhongSelectionPosition, zPosition:1)
//		addNode(frontUhongSelection, name: "uhongSelectionPosition", position: CGPointMake(uhongSelectionPosition.x, uhongSelectionPosition.y*1.08), zPosition:2)
        
        frontUhongSelection.name = "uhongSelectionPosition"
        frontUhongSelection.zPosition = 2
        frontUhongSelection.position.y = frontUhongSelection.position.y + 20
        
        backUhongSelection.addChild(frontUhongSelection)
        
        let salamangSelctionPosition = CGPoint(x: self.size!.width*0.35, y: self.size!.height/1.5)
		addNode(backSalamangSelction, name: "salamangSelctionPosition", position: salamangSelctionPosition, zPosition: 1)
		addNode(frontSalamangSelction, name: "salamangSelctionPosition", position: CGPointMake(salamangSelctionPosition.x, salamangSelctionPosition.y*1.05), zPosition: 2)
		addNode(backRandomSelection, name: "randomSelection", position: CGPoint(x: self.size!.width*0.25, y: self.size!.height/3), zPosition: 1)
		addNode(frontRandomSelection, name: "randomSelection", position: CGPoint(x: self.size!.width*0.25, y: self.size!.height/3), zPosition: 2)
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
    
	func statusCharacter (ataqueStatus: SKSpriteNode, vidaStatus: SKSpriteNode, velocidadeStatus: SKSpriteNode) {
		//ataque.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Right
		self.addLabelNode(ataque, name: "Ataque", position: CGPoint(x: self.size!.width*0.65, y: self.size!.height*0.70), zPosition: 2, alpha: 0.8, fontSize: 22, fontName: "SnapHand")
		ataqueStatus.setScale(2)
		self.addNode(ataqueStatus, name: "AtaqueStatus", position: CGPoint(x: self.size!.width*0.65, y: self.size!.height*0.65), zPosition: 1)
		
		self.addLabelNode(vida, name: "Vida", position: CGPoint(x: self.size!.width*0.65, y: self.size!.height*0.50), zPosition: 1, alpha: 0.8, fontSize: 22, fontName: "SnapHand")
		vidaStatus.setScale(2)
		self.addNode(vidaStatus, name: "LifeStatus", position: CGPoint(x: self.size!.width*0.65, y: self.size!.height*0.45), zPosition: 1)
		
		self.addLabelNode(velocidade, name: "Velocidade", position: CGPoint(x: self.size!.width*0.65, y: self.size!.height*0.30), zPosition: 1, alpha: 0.8, fontSize: 22, fontName: "SnapHand")
		velocidadeStatus.setScale(2)
		self.addNode(velocidadeStatus, name: "VelocidadeStatus", position: CGPoint(x: self.size!.width*0.65, y: self.size!.height*0.25), zPosition: 1)
		
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
			self.addLabelNode(neithLabelStatus, name: "neithLabelStatus", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.5), zPosition: 1,alpha:  0.8, fontSize: 40, fontName: "SnapHand")
			self.addLabelNode(neithLabelAbout, name: "neithLabelAbout", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.8),zPosition: 1,alpha:  0.8, fontSize: 40, fontName: "SnapHand")
			self.addNode(neithImage, name: "neithImage", position: CGPoint(x: self.size!.width/1.1, y: self.size!.height/1.5), zPosition: 1)
			print("Selected character: \(nodeName)")
		} else if nodeName == "uhongSelectionPosition" {
			playerSelected = "Uhong"
			self.selectPlayer(frontUhongSelection, normalScale: 0.3, bigScale: 0.4)
			self.addLabelNode(uhongLabelStatus, name: "uhongLabelStatus", position: CGPoint(x: self.size!.width*0.65, y: self.size!.height*0.80), zPosition: 1,alpha:  0.8, fontSize: 40, fontName: "SnapHand")
			self.statusCharacter(barraQualidade4, vidaStatus: barraQualidade4Segunda, velocidadeStatus: barraQualidade3)
            print("Selected character: \(nodeName)")
			
			
		} else if nodeName == "salamangSelctionPosition" {
			self.selectPlayer(frontSalamangSelction,normalScale: 0.5, bigScale: 0.65)
			playerSelected = "Salamang"

			self.addLabelNode(salamangLabelStatus, name: "salamangLabelStatus", position: CGPoint(x: self.size!.width*0.65, y: self.size!.height*0.80), zPosition: 1, alpha: 0.8, fontSize: 40, fontName: "SnapHand")
			self.statusCharacter(barraQualidade5, vidaStatus: barraQualidade3Segunda, velocidadeStatus: barraQualidade3)
            print("Selected character: \(nodeName)")
		} else if nodeName == "randomSelection"{
			self.playerSelected = ""
			addLabelNode(random, name: "random", position: CGPoint(x: self.size!.width*0.65, y: self.size!.height*0.50), zPosition: 1, alpha: 0.8, fontSize: 40, fontName: "SnapHand")
			addLabelNode(character, name: "character", position: CGPoint(x: self.size!.width*0.65, y: self.size!.height*0.70), zPosition: 1, alpha: 0.8, fontSize: 40, fontName: "SnapHand")
			self.selectPlayer(frontRandomSelection,normalScale: 1.8, bigScale: 2.2)
		} else if nodeName == "dinakSelectionPosition"{
//			self.addLabelNode(dinakLabelAbout, name: "dinakLabelAbout", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.8),zPosition: 1,alpha:  0.8, fontSize: 26, fontName: "SnapHand")
			self.addLabelNode(dinakLabelSatus, name: "dinakLabelSatus", position: CGPoint(x: self.size!.width/1.5, y: self.size!.height/1.5),zPosition: 1,alpha:  0.8, fontSize: 40, fontName: "SnapHand")
			self.addNode(dinakImage, name: "dinakImage", position: CGPoint(x: self.size!.width/1.1, y: self.size!.height/1.5), zPosition: 1)
			print("Selected character: \(nodeName)")
			playerSelected = "Dinak"
			
		} else if nodeName == "playbutton" {
			print("Touched play button")
            isNotReady = false
            
            if self.playerSelected == "" {
                self.playerSelected = self.randomCharacter()
            }
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
		let timerLabel = SKLabelNode(fontNamed: "SnapHand")
		self.addLabelNode(timerLabel, name: "timerLabel", position: CGPoint(x: (self.size?.width)!*0.48, y: (self.size?.height)!/1.1), zPosition: 1,alpha:  0.8, fontSize: 40, fontName: "SnapHand")
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
		
		self.backUhongSelection.removeAllActions()
		self.backSalamangSelction.removeAllActions()
		self.frontUhongSelection.removeAllActions()
		self.frontSalamangSelction.removeAllActions()
		self.backRandomSelection.removeAllActions()
		self.frontRandomSelection.removeAllActions()
		
		self.neithSelection.setScale(2)
		self.backUhongSelection.setScale(1.8)
		self.backSalamangSelction.setScale(1.8)
		self.frontUhongSelection.setScale(0.3)
		self.frontSalamangSelction.setScale(0.5)
		self.backRandomSelection.setScale(1.8)
		self.frontRandomSelection.setScale(1.8)
		
	}
    
	func removeAllStatus () {
		self.neithLabelStatus.removeFromParent()
		self.salamangLabelStatus.removeFromParent()
		self.uhongLabelStatus.removeFromParent()
		self.dinakLabelSatus.removeFromParent()
		self.ataque.removeFromParent()
		self.vida.removeFromParent()
		self.velocidade.removeFromParent()
		self.random.removeFromParent()
		self.character.removeFromParent()
	
	}
    
	func removeAllImages () {
		self.neithImage.removeFromParent()
		self.salamangImage.removeFromParent()
		self.uhongImage.removeFromParent()
		self.dinakImage.removeFromParent()
		self.barraQualidade1.removeFromParent()
		self.barraQualidade2.removeFromParent()
		self.barraQualidade3.removeFromParent()
		self.barraQualidade4.removeFromParent()
		self.barraQualidade5.removeFromParent()
		self.barraQualidade3Segunda.removeFromParent()
		self.barraQualidade4Segunda.removeFromParent()
	}
	
	func removeAllAbout () {
		self.neithLabelAbout.removeFromParent()
		self.uhongLabelAbout.removeFromParent()
		self.salamangLabelAbout.removeFromParent()
		self.dinakLabelAbout.removeFromParent()
	}
    
    // Select a random character
    func randomCharacter() -> String {
        var randomCharacter = ""
        let randomNumber = arc4random_uniform(2)
        
        switch (randomNumber) {
        case 0:
            randomCharacter = "Uhong"
            break
        case 1:
            randomCharacter = "Salamang"
        default:
            print("Error generating a random character")
        }
        
        print("Selected \(randomCharacter) randomly")
        
        return randomCharacter
    }
}
