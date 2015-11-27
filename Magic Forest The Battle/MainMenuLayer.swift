//
//  MainMenuLayer.swift
//  Magic Forest The Battle
//
//  Created by Marcelo Cristiano Araujo Silva on 28/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit
import GameKit

enum Screen {
    case middleScreen
    case leftScreen
    case rightScreen
}

class MainMenuLayer: SKNode, BasicLayer, UIGestureRecognizerDelegate, StartGameProtocol, UIAlertViewDelegate {
    private var size: CGSize?
    private var view: SKView?
    private var currentScreen: Screen?
    private var rightSwipe: UISwipeGestureRecognizer?
    private var leftSwipe: UISwipeGestureRecognizer?
    
    var networkingEngine: MultiplayerNetworking?
    var gameScene: GameScene?
	
	var scenesDelegate: ScenesDelegate?
	
    var controlUnit: MFCSControlUnit?
    var controllerMode: MFCSControllerMode?
    
    var numberOfPlayers: Int?
    
    private let configurationButton = SKSpriteNode(imageNamed: "configurationButton.png")
    private let gameCenterButton = SKSpriteNode(imageNamed: "gameCenterButton.png")
    private let practiceButton = SKSpriteNode(imageNamed: "practiceButton.png")
    private let storeButton = SKSpriteNode(imageNamed: "storeButton.jpg")
    private let skinButton = SKSpriteNode(imageNamed: "storeButton.jpg")
    private let playButton = SKSpriteNode(imageNamed: "playButton.gif")
    private let historyButton = SKSpriteNode(imageNamed: "storeButton.jpg")
    private let statisticsButton = SKSpriteNode(imageNamed: "storeButton.jpg")
    
    required init(size: CGSize) {
        super.init()
        
        assert(false, "Dont initialize main menu with size. Use init with size and view instend")
    }
    
    /**
     Initializes the main menu layer
     - parameter size: A reference to the device's screen size
     - parameter view: A reference to the current view
     */
    init(size: CGSize, view: SKView) {
        super.init()
        
        self.size = size
        self.view = view
        
        self.currentScreen = Screen.middleScreen
        
        self.addButtonsToLayer()
        self.addSwipeGestureToLayer()
        
        self.gameScene = GameScene(size: size)
        
        // Authenticate local player in game center
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showAuthenticationViewController", name: PresentAuthenticationViewController, object: nil)
        GameKitHelper.sharedInstance.authenticateLocalPlayer()

    }
    
    func showAuthenticationViewController() {
        let gameKitHelper = GameKitHelper.sharedInstance
        let viewController = self.scene?.view?.window?.rootViewController

        if let authenticationViewController = gameKitHelper.authenticationViewController {
            viewController!.presentViewController(authenticationViewController, animated: true, completion: nil)
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Getting a node in the touch location
        let touch = touches.first
        let touchLocation = touch?.locationInNode(self)
        let nodeTouched = self.nodeAtPoint(touchLocation!)
        
        let viewController = self.scene?.view?.window?.rootViewController
        let nodeName = nodeTouched.name
        
        if nodeName == "playButton" {
			if IS_ONLINE == true {
				self.showMatchMakerViewController(presentingViewController: viewController!)
			} else {
				self.selectPlayer()
			}
			
        } else if nodeName == "configurationButton" {
            let settingsMenu = SettingsLayer(size: self.size!)
            self.addChild(settingsMenu)
        } else if nodeName == "practiceButton" {
            print("PracticeButton touched")
        } else if nodeName == "gameCenterButton" {
            GameKitHelper.sharedInstance.showGKGameCenterViewController(viewController!)
            
        } else if nodeName == "storeButton" {
            print("StoreButton touched")
        } else if nodeName == "skinButton" {
            print("SkinButton touched")
        } else if nodeName == "statisticsButton" {
            print("StatisticsButton touched")
        } else if nodeName == "historyButton" {
            print("HistoryButton touched")
        }
    }
    
    // Show the match maker view controller
    private func showMatchMakerViewController(presentingViewController viewController: UIViewController) {
        
        if !GKLocalPlayer.localPlayer().authenticated {
            self.playerIsNotAuthenticated()
            return
        }
        
        self.networkingEngine = MultiplayerNetworking()
		
		gameScene?.scenesDelegate = self.scenesDelegate
		networkingEngine?.size = self.size!
        networkingEngine!.delegate = gameScene
        networkingEngine!.startGameDelegate = self
        gameScene!.networkingEngine = networkingEngine

        GameKitHelper.sharedInstance.findMatch(2, maxPlayers: 2, presentingViewController: viewController, delegate: networkingEngine!)
    }
    
    private func playerIsNotAuthenticated() {
        
        let messageOne = NSLocalizedString("GameCenterNotAuthenticated", comment: "GameCenterNotAuthenticated")
        
        let alertController = UIAlertController(title: "Game Center", message: messageOne, preferredStyle: UIAlertControllerStyle.Alert)
        
        let okAction = UIAlertAction(title: "OK", style: .Default) { (alert: UIAlertAction!) -> Void in
            alertController.dismissViewControllerAnimated(true, completion: nil)
        }
        alertController.addAction(okAction)

        
        let gameCenterAction = UIAlertAction(title: "Game Center", style: .Default) { (alert: UIAlertAction!) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: "gamecenter:")!)
        }
        
        alertController.addAction(gameCenterAction)
        
        let viewController = self.scene?.view?.window?.rootViewController
        
        viewController?.presentViewController(alertController, animated: true, completion: nil)
        
    }
    
    // Add a button to the layer with a name and position
    private func addButton(button: SKSpriteNode, name: String, position: CGPoint) {
        button.name = name
        button.position = position
        self.addChild(button)
    }
    
    // Add all buttons to the layer
    private func addButtonsToLayer() {
        let padding = CGFloat(10)
        
        // Adding configuration Button
        self.configurationButton.setScale(0.2)
        let halfConfigurationButtonWidth = self.configurationButton.size.width/2
        let halfConfigurationButtonHeight = self.configurationButton.size.height/2
        let configurationButtonPosition = CGPoint(x: self.size!.width - padding - halfConfigurationButtonWidth, y: self.size!.height - padding - halfConfigurationButtonHeight)
        addButton(self.configurationButton, name: "configurationButton", position: configurationButtonPosition)
        
        // Adding gameCenter Button
        self.gameCenterButton.setScale(0.2)
        let halfGameCenterButtonWidth = self.gameCenterButton.size.width/2
        let halfGameCenterButtonHeight = self.gameCenterButton.size.height/2
        let gameCenterButtonPosition = CGPoint(x: 0 + halfGameCenterButtonWidth + padding, y: self.size!.height - halfGameCenterButtonHeight - padding)
        addButton(self.gameCenterButton, name: "gameCenterButton", position: gameCenterButtonPosition)
        
        // Adding play Button
        self.playButton.setScale(0.5)
        let playButtonPosition = CGPoint(x: self.size!.width/4 , y: self.size!.height/4)
        addButton(self.playButton, name: "playButton", position: playButtonPosition)
        
        // Adding practice Button
        self.practiceButton.setScale(0.5)
        let practiceButtonPosition = CGPoint(x: 3*self.size!.width/4 , y: self.size!.height/4)
        addButton(practiceButton, name: "practiceButton", position: practiceButtonPosition)
        
        // Add store Button
        self.storeButton.setScale(0.3)
        let storeButtonPosition = CGPoint(x: self.size!.width/4 + self.size!.width, y: self.size!.height/4)
        addButton(self.storeButton, name: "storeButton", position: storeButtonPosition)
        
        // Add skins Button
        self.skinButton.setScale(0.3)
        let skinButtonPosition = CGPoint(x: 3*self.size!.width/4 + self.size!.width, y: self.size!.height/4)
        addButton(self.skinButton, name: "skinButton", position: skinButtonPosition)
        
        // Add history Button
        self.historyButton.setScale(0.3)
        let historyButtonPosition = CGPoint(x: self.size!.width/4 - self.size!.width, y: self.size!.height/4)
        addButton(self.historyButton, name: "historyButton", position: historyButtonPosition)
        
        // Add skins Button
        self.statisticsButton.setScale(0.3)
        let statisticsButtonPosition = CGPoint(x: 3*self.size!.width/4 - self.size!.width, y: self.size!.height/4)
        addButton(self.statisticsButton, name: "statisticsButton", position: statisticsButtonPosition)
        
        
    }
    
    private func selectPlayer () {
        let sceneSelectPlayer = MenuSelectPlayerScene(size: size!)
		self.scenesDelegate?.showMenuSelectPlayerScene(sceneSelectPlayer)
//        self.view?.presentScene(sceneSelectPlayer)
//		self.removeGesturesFromLayer()
    }
    
    // TODO: Refactor star game method.
    func startGame() {
		scenesDelegate?.showGameScene(gameScene!)
		
//        self.view?.presentScene(gameScene!, transition: SKTransition.flipHorizontalWithDuration(2))
//        
//        self.controllerMode = MFCSControllerMode.JoystickAndSwipe
//        
//        self.controlUnit = MFCSControlUnit(frame: self.view!.frame, delegate: gameScene!.gameLayer!, controllerMode: controllerMode!)
//        
//        self.view?.addSubview(self.controlUnit!)
//		
        self.removeGesturesFromLayer()
    }
    
    // Add swipe gestures to the layer
    private func addSwipeGestureToLayer() {
        // Configuring right swipe gesture
        self.rightSwipe = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        self.rightSwipe!.delegate = self
        self.rightSwipe!.direction = .Right
        
        // Configuring left swipe gesture
        self.leftSwipe = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        self.leftSwipe!.delegate = self
        self.leftSwipe!.direction = .Left
        
        // Adding gestures to the view
        self.view?.addGestureRecognizer(rightSwipe!)
        self.view?.addGestureRecognizer(leftSwipe!)
    }
    
    // Remove swipe gestures from layer
    private func removeGesturesFromLayer() {
        self.view?.removeGestureRecognizer(self.rightSwipe!)
        self.view?.removeGestureRecognizer(self.leftSwipe!)
    }
    
    // Handle the given swipe
    func handleSwipe(sender: UISwipeGestureRecognizer) {		
        if sender.direction == .Right && self.currentScreen == Screen.rightScreen {
            self.runAction(SKAction.moveByX(self.size!.width, y: 0, duration: 0.5))
            self.currentScreen = Screen.middleScreen
            
        } else if sender.direction == .Right && self.currentScreen == Screen.middleScreen {
            self.runAction(SKAction.moveByX(self.size!.width, y: 0, duration: 0.5))
            self.currentScreen = Screen.leftScreen
        } else if sender.direction == .Left && self.currentScreen == Screen.leftScreen {
            self.runAction(SKAction.moveByX(-self.size!.width, y: 0, duration: 0.5))
            self.currentScreen = Screen.middleScreen
        } else if sender.direction == .Left && self.currentScreen == Screen.middleScreen {
            self.runAction(SKAction.moveByX(-self.size!.width, y: 0, duration: 0.5))
            self.currentScreen = Screen.rightScreen
        }
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
		removeGesturesFromLayer()
    }

}
