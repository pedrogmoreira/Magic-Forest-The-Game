//
//  MainMenuLayer.swift
//  Magic Forest The Battle
//
//  Created by Marcelo Cristiano Araujo Silva on 28/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit
import GameKit

class MainMenuLayer: SKNode, BasicLayer, UIGestureRecognizerDelegate, StartGameProtocol, UIAlertViewDelegate, SettingsProcotol {
    
    private var size: CGSize?
    private var view: SKView?
    private var rightSwipe: UISwipeGestureRecognizer?
    private var leftSwipe: UISwipeGestureRecognizer?
    
    var networkingEngine: MultiplayerNetworking?
    var gameScene: GameScene?
	
	var scenesDelegate: ScenesDelegate?
	
    var controlUnit: MFCSControlUnit?
    var controllerMode: MFCSControllerMode?
    
    var numberOfPlayers: Int?
    
    var isSetting: Bool?
    var settingsMenu: SettingsLayer?
    
    private let configurationButton = SKSpriteNode(imageNamed: "SettingsButton.png")
    private let gameCenterButton = SKSpriteNode(imageNamed: "GameCenterButton.png")
    private let practiceButton = SKSpriteNode(imageNamed: "PlacaPraticar.png")
    //private let storeButton = SKSpriteNode(imageNamed: "storeButton.jpg")
    //private let skinButton = SKSpriteNode(imageNamed: "storeButton.jpg")
    private let playButton = SKSpriteNode(imageNamed: "PlacaJogar.png")
    //private let historyButton = SKSpriteNode(imageNamed: "storeButton.jpg")
    //private let statisticsButton = SKSpriteNode(imageNamed: "storeButton.jpg")
	private let fundo = SKSpriteNode(imageNamed: "FundoMenu.png")
	
    private let title = SKSpriteNode(imageNamed: "TituloJogo.png")
	private let jogarLabel = SKLabelNode(fontNamed: "SnapHand")
	private let praticarLabel = SKLabelNode(fontNamed: "SnapHand")
	
	
	
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
        
        self.isSetting = false
        
        self.size = size
        self.view = view
        self.addButtonsToLayer()
        
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
        
        if isSetting == false {
            if nodeName == "playButton" || nodeName == "lblJogar" {
                if IS_ONLINE == true {
                    self.showMatchMakerViewController(presentingViewController: viewController!)
                } else {
                    self.selectPlayer()
                }
            } else if nodeName == "configurationButton" {
                self.creteSettingsMenu()
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
        } else {
            self.settingsMenu?.touchesBegan(touches, withEvent: event)
        }
    }
    
    // Create the SettingsMenu
    private func creteSettingsMenu() {
        self.fundo.alpha = 0
        self.settingsMenu = SettingsLayer(size: self.size!, view: self.view!)
        self.settingsMenu?.delegate = self
        
        self.addChild(self.settingsMenu!)
        
        self.isSetting = true
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
        self.configurationButton.setScale(1.5)
        let halfConfigurationButtonWidth = self.configurationButton.size.width/2
        let halfConfigurationButtonHeight = self.configurationButton.size.height/2
		let configurationButtonPosition = CGPoint(x: 0 + halfConfigurationButtonWidth + padding, y: self.size!.height - padding - halfConfigurationButtonHeight)
		addButton(self.configurationButton, name: "configurationButton", position: configurationButtonPosition)
        
        // Adding gameCenter Button
        self.gameCenterButton.setScale(1.5)
        let halfGameCenterButtonWidth = self.gameCenterButton.size.width/2
        let halfGameCenterButtonHeight = self.gameCenterButton.size.height/2
        let gameCenterButtonPosition = CGPoint(x: 0 + halfGameCenterButtonWidth + padding, y: self.size!.height - ((2*halfConfigurationButtonHeight) + (4*padding) + halfGameCenterButtonHeight))
        addButton(self.gameCenterButton, name: "gameCenterButton", position: gameCenterButtonPosition)
        
        // Adding play Button
        self.playButton.setScale(2.5)
		self.playButton.zPosition = 0
        let halfPlayerButtonHeight = self.playButton.frame.height/2
        let playButtonPosition = CGPoint(x: self.size!.width*0.25 , y: 0 + halfPlayerButtonHeight)
        addButton(self.playButton, name: "playButton", position: playButtonPosition)
		
		let playString = NSLocalizedString("Play", comment: "Play Button String")
		self.jogarLabel.text = playString
		self.jogarLabel.position = CGPointMake(0, 0)
		self.jogarLabel.fontColor = SKColor.whiteColor()
		self.jogarLabel.fontSize = 22
		self.jogarLabel.zPosition = 1
		self.jogarLabel.alpha = 0.8
        self.jogarLabel.name = "playButton"
		self.playButton.addChild(jogarLabel)
		
        // Adding practice Button
        self.practiceButton.setScale(2.5)
		self.practiceButton.zPosition = 0
        let halfPracticeButtonHeight = self.practiceButton.size.height/2
        let practiceButtonPosition = CGPoint(x: 3*self.size!.width/4 , y: 0 + halfPracticeButtonHeight)
        addButton(practiceButton, name: "practiceButton", position: practiceButtonPosition)
		
		let practiceString = NSLocalizedString("Practice", comment: "Practice Button String")
		self.praticarLabel.text = practiceString
		self.praticarLabel.position = CGPointMake(0,3)
		self.praticarLabel.fontColor = SKColor.whiteColor()
		self.praticarLabel.fontSize = 15
		self.praticarLabel.zPosition = 1
		self.praticarLabel.alpha = 0.8
		self.practiceButton.addChild(praticarLabel)
		
		
		// Adding title
        // Verifying the device type
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.title.setScale(2.5)
        } else {
            if self.size?.width > 600 {
                self.title.setScale(1.9)
            } else {
                self.title.setScale(1.4)
            }
        }
		self.title.zPosition = 1
		self.title.position = CGPoint(x: (self.size?.width)!/2, y: (self.size?.height)!/1.4)
		self.addChild(self.title)
		
		//Adding fundo
        let xBackgroundRatio = self.size!.width / self.fundo.frame.width
        let yBackgroundRatio = self.size!.height / self.fundo.frame.height
		self.fundo.zPosition = -100
		self.fundo.xScale = xBackgroundRatio
        self.fundo.yScale = yBackgroundRatio
		self.fundo.position = CGPointMake((self.size?.width)!/2, (self.size?.height)!/2)
		self.addChild(fundo)
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
    }
    
    func finishSetting() {
        self.fundo.alpha = 1
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

}
