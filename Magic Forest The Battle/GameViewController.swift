//
//  GameViewController.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright (c) 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit

protocol ScenesDelegate {
	func showMenu()
	func showMenuSelectPlayerScene(menuSelectPlayerScene: MenuSelectPlayerScene)
	func showGameScene(gameScene: GameScene)
	func addBackButton()
	
	func deinitControllersSystem()
	
	func removeBackButton()
	func removeMenuScene()
	func removeMenuSelectPlayerScene()
	func removeGameScene()
}

class GameViewController: UIViewController, ScenesDelegate {
	
	var mainSKView: SKView?
	var secondarySKView: SKView?
	
	var menuScene: MenuScene?
	var gameScene: GameScene?
	var menuSelectPlayerScene: MenuSelectPlayerScene?
	
	var controllerMode: MFCSControllerMode?
	var controlUnit: MFCSControlUnit?
	
	var backButtonView: PracticeBackView?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.showMenu()
		self.loadbackButton()
		
    }
	
	func loadbackButton() {
		let menuButton = SKSpriteNode(imageNamed: "MenuButton")
		let ratio = menuButton.size.width / menuButton.size.height
		let height = self.view.frame.size.height / 5
		let width = height * ratio
		
		self.backButtonView = PracticeBackView(frame: CGRect(x: 0, y: 0, width: width, height: height), scenesDelegate: self)
	}
	
    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Landscape
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
	
	func showMenu() {
		self.menuScene = MenuScene(size: self.view.frame.size)
		self.menuScene!.scenesDelegate = self
		
		// Configure the view.
		self.mainSKView = self.view as? SKView
		self.mainSKView!.showsFPS = false
		self.mainSKView!.showsNodeCount = false
		self.mainSKView!.showsPhysics = true
		
		/* Sprite Kit applies additional optimizations to improve rendering performance */
		self.mainSKView!.ignoresSiblingOrder = true
		
		self.mainSKView!.presentScene(self.menuScene!)
		
		//Musica
		DMTSoundPlayer.sharedPlayer().playSongIndexed(0, loops: true)
		//SFX
		//DMTSoundPlayer.sharedPlayer().playSoundEffect(DMTSoundPlayer.sharedPlayer().sounds[0])
	}
	
	func showMenuSelectPlayerScene(menuSelectPlayerScene: MenuSelectPlayerScene) {
		print("Scene Delegate: show character selection")
		menuSelectPlayerScene.scenesDelegate = self
		self.menuSelectPlayerScene = menuSelectPlayerScene
		
		self.mainSKView!.presentScene(menuSelectPlayerScene)
		
		menuSelectPlayerScene.menu?.networkDelegate = self.menuScene?.mainMenu?.networkingEngine
		
		self.removeMenuScene()
		//Musica
		DMTSoundPlayer.sharedPlayer().playSongIndexed(1, loops: true)
	}
	
	func showGameScene(gameScene: GameScene) {
		print("Scene Delegate: show game scene")
		gameScene.scenesDelegate = self
		self.gameScene = gameScene
		
        self.mainSKView!.presentScene(self.gameScene!, transition: SKTransition.flipHorizontalWithDuration(2))
		
        self.controllerMode = GameState.sharedInstance.controllerMode
		
		self.gameScene!.controlUnit = self.controlUnit
		
		if IS_ONLINE == true {
			self.controlUnit = MFCSControlUnit(frame: self.view!.frame, delegate: gameScene.onlineGameLayer!, controllerMode: controllerMode!)
			
			self.view?.addSubview(controlUnit!)
		} else {
			self.controlUnit = MFCSControlUnit(frame: self.view!.frame, delegate: gameScene.practiceGameLayer!, controllerMode: controllerMode!)
			
			self.view?.addSubview(controlUnit!)
		}
		
		
		//Musica
		DMTSoundPlayer.sharedPlayer().playSongIndexed(2, loops: true)
	}
	
	func addBackButton() {
		self.view.addSubview(self.backButtonView!)
	}
	
	func deinitControllersSystem() {
		self.controlUnit?.removeFromSuperview()
		self.controlUnit = nil
	}
	
	func removeBackButton() {
		self.backButtonView?.removeFromSuperview()
	}
	
	func removeMenuScene() {
		self.menuScene?.removeFromParent()
		self.menuScene = nil
	}
	
	func removeMenuSelectPlayerScene() {
		self.menuSelectPlayerScene?.removeFromParent()
	}
	
	func removeGameScene() {
		self.gameScene?.removeFromParent()
		self.gameScene = nil
	}
}
