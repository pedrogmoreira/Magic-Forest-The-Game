//
//  SettingsLayer.swift
//  Magic Forest The Battle
//
//  Created by Marcelo Cristiano Araujo Silva on 27/11/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit

protocol SettingsProcotol {
    var isSetting: Bool? {get set}
}


class SettingsLayer: SKNode, BasicLayer {
    
    let size: CGSize!
    var settingsMenu: SKSpriteNode?
    var delegate: SettingsProcotol?
    
    var swipeMode: SKSpriteNode?
    var buttonMode: SKSpriteNode?
    
    /**
     Initializes the settings layer
     - parameter size: A reference to the device's screen size
     */
    required init(size: CGSize) {
        self.size = size
        super.init()
        
        self.zPosition = 100
        
        self.createBackgound()
        self.createBackButton()
        self.createButtonsToChooseControlType()
		self.createLabels()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Create the background of settings layer
	
	
    func createBackgound() {
        let settingsWidth = CGFloat(self.size.width/1.2)
        let settingsHeight = CGFloat(self.size.height/1.2)
        
        let settingsSize = CGSize(width: settingsWidth, height: settingsHeight)
        self.settingsMenu = SKSpriteNode(texture: SKTexture(imageNamed: "QuadroSettings"), size: settingsSize)
        //self.settingsMenu = SKSpriteNode(color: SKColor.brownColor(), size: settingsSize)
        self.settingsMenu!.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
		self.settingsMenu?.zPosition = 1
		
		let fundo = SKSpriteNode(imageNamed: "FundoSettings")
		fundo.position = CGPointMake(self.size.width/2, self.size.height/2)
		fundo.setScale(3)
		fundo.zPosition = 0
		self.addChild(fundo)
		
        self.addChild(settingsMenu!)
    }
    
    // Create backButton
    private func createBackButton() {
        let backWidth = CGFloat(self.settingsMenu!.size.width/10)
        let backHeight = CGFloat(self.settingsMenu!.size.height/10)
        
        let backSize = CGSize(width: backWidth, height: backHeight)
        
        let backButton = SKSpriteNode(texture: SKTexture(imageNamed: "VoltarButton"), size: backSize)
        
        let leftOfSettingsMenu = -self.settingsMenu!.size.width/1.8 + backButton.size.width/2;
        let topOfSettingsMenu = self.settingsMenu!.size.height/1.8 - backButton.size.height/2;
        backButton.position = CGPoint(x: leftOfSettingsMenu, y: topOfSettingsMenu)
        backButton.name = "backButton"
        
        self.settingsMenu!.addChild(backButton)
    }
	
	//Create labels
	private func createLabels () {
		let musicLabel = SKLabelNode(fontNamed: "SnapHand")
		let SFXLabel = SKLabelNode(fontNamed: "SnapHand")
		let controlsLabel = SKLabelNode(fontNamed: "SnapHand")
		
		//musicLabel
		musicLabel.text = "Música"
		musicLabel.fontColor = SKColor.orangeColor()
		musicLabel.fontSize = 30
		musicLabel.position = CGPointMake(-self.settingsMenu!.size.width*0.2, self.settingsMenu!.size.height*0.2)
		musicLabel.zPosition = 3
		self.settingsMenu?.addChild(musicLabel)
		
		//SFX
		SFXLabel.text = "SFX"
		SFXLabel.fontColor = SKColor.orangeColor()
		SFXLabel.fontSize = 30
		SFXLabel.position = CGPointMake(-self.settingsMenu!.size.width*0.2, 0)
		SFXLabel.zPosition = 3
		self.settingsMenu?.addChild(SFXLabel)
		
		//Controles
		controlsLabel.text = "Controles"
		controlsLabel.fontColor = SKColor.orangeColor()
		controlsLabel.fontSize = 30
		controlsLabel.position = CGPointMake(-self.settingsMenu!.size.width*0.2, -self.settingsMenu!.size.height*0.2)
		controlsLabel.zPosition = 3
		self.settingsMenu?.addChild(controlsLabel)
		
	}
	
    //Create the button to choose the control type
    private func createButtonsToChooseControlType() {
        let buttonsWidth = CGFloat(self.settingsMenu!.size.width/10)
        let buttonsHeight = CGFloat(self.settingsMenu!.size.height/10)
        
        let buttonsSize = CGSize(width: buttonsWidth, height: buttonsHeight)
        
        self.swipeMode = SKSpriteNode(texture: SKTexture(imageNamed: "BotoesSettings"), color: SKColor.greenColor(), size: buttonsSize)
        self.buttonMode = SKSpriteNode(texture: SKTexture(imageNamed: "BotoesSettings"), color: SKColor.redColor(), size: buttonsSize)
        
        swipeMode!.name = "swipeMode"
        buttonMode!.name = "buttonMode"
        
		swipeMode!.position = CGPoint(x: buttonsWidth, y: -self.settingsMenu!.size.height*0.2)
		buttonMode!.position = CGPoint(x: buttonsWidth + (swipeMode?.position.x)!, y: -self.settingsMenu!.size.height*0.2)
		
		swipeMode?.zPosition = 2
		buttonMode?.zPosition = 2
		
        self.settingsMenu!.addChild(swipeMode!)
        self.settingsMenu!.addChild(buttonMode!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let touchPosition = touch?.locationInNode(self)
        let node = self.nodeAtPoint(touchPosition!)
        
        if node.name == "backButton" {
            self.removeFromParent()
            self.delegate?.isSetting = false
        } else if node.name == "swipeMode" {
            print("SwipeMode activated")
            changeColor(node)
            GameState.sharedInstance.controllerMode = MFCSControllerMode.JoystickAndSwipe
        } else if node.name == "buttonMode" {
            print("ButtonMode activated")
            changeColor(node)
            GameState.sharedInstance.controllerMode = MFCSControllerMode.JoystickAndButton
        }
    }
    
    private func changeColor(node: SKNode) {
        if node.name == "swipeMode" {
            self.swipeMode?.color = SKColor.greenColor()
            self.buttonMode?.color = SKColor.redColor()
        } else {
            self.swipeMode?.color = SKColor.redColor()
            self.buttonMode?.color = SKColor.greenColor()
        }
    }
    
}
