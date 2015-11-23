//
//  GameViewController.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright (c) 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit

// TODO: SET IS ONLINE TO FALSE TO START A SINGLE GAME
let IS_ONLINE = true

protocol ScenesDelegate {
	func showMenuSelectPlayerScene(menuSelectPlayerScene: MenuSelectPlayerScene)
	func showGameOverScene()
	func showGameScene(gameScene: GameScene)
	
	func removeMenuScene()
	func removeMenuSelectPlayerScene()
	func removeGameScene()
	func removeGameOverScene()
}

class GameViewController: UIViewController, ScenesDelegate {
	
	var mainSKView: SKView?
	var secondarySKView: SKView?
	
	var menuScene: MenuScene?
	var gameScene: GameScene?
	var menuSelectPlayerScene: MenuSelectPlayerScene?
	
	var controllerMode: MFCSControllerMode?
	var controlUnit: MFCSControlUnit?
	
    override func viewDidLoad() {
        super.viewDidLoad()

		self.menuScene = MenuScene(size: self.view.frame.size)
		self.menuScene!.scenesDelegate = self
        
		// Configure the view.
		self.mainSKView = self.view as? SKView
		self.mainSKView!.showsFPS = true
		self.mainSKView!.showsNodeCount = true
        self.mainSKView!.showsPhysics = true
		
		/* Sprite Kit applies additional optimizations to improve rendering performance */
		self.mainSKView!.ignoresSiblingOrder = true
		
		self.mainSKView!.presentScene(self.menuScene!)
		
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
	
	func showMenuSelectPlayerScene(menuSelectPlayerScene: MenuSelectPlayerScene) {
		print("Scene Delegate: show character selection")
		menuSelectPlayerScene.scenesDelegate = self
		self.menuSelectPlayerScene = menuSelectPlayerScene
		
		self.mainSKView!.presentScene(menuSelectPlayerScene)
		
		menuSelectPlayerScene.menu?.networkDelegate = self.menuScene?.mainMenu?.networkingEngine
		
		self.removeMenuScene()
	}
	
	func showGameOverScene() {
		
	}
	
	func showGameScene(gameScene: GameScene) {
		print("Scene Delegate: show game scene")
		gameScene.scenesDelegate = self
		self.gameScene = gameScene
		
        self.mainSKView!.presentScene(self.gameScene!, transition: SKTransition.flipHorizontalWithDuration(2))

        self.controllerMode = MFCSControllerMode.JoystickAndSwipe

		self.controlUnit = MFCSControlUnit(frame: self.view!.frame, delegate: gameScene.gameLayer!, controllerMode: controllerMode!)

        self.view?.addSubview(controlUnit!)
	}
	
	func removeMenuScene() {
		self.menuScene?.mainMenu?.removeFromParent()
		self.menuScene?.view?.removeFromSuperview()
		self.menuScene?.removeFromParent()
		self.menuScene = nil
	}
	
	func removeMenuSelectPlayerScene() {
		self.menuSelectPlayerScene?.view?.removeFromSuperview()
		self.menuSelectPlayerScene?.removeFromParent()
		self.menuSelectPlayerScene = nil
	}
	
	func removeGameScene() {
		self.controlUnit!.removeFromSuperview()
	}
	
	func removeGameOverScene() {
		
	}
    
}
