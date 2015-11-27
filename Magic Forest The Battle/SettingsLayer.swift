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
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // Create the background of settings layer
    func createBackgound() {
        let settingsWidth = CGFloat(self.size.width/1.2)
        let settingsHeight = CGFloat(self.size.height/1.2)
        
        let settingsSize = CGSize(width: settingsWidth, height: settingsHeight)
        
        self.settingsMenu = SKSpriteNode(color: SKColor.brownColor(), size: settingsSize)
        self.settingsMenu!.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        
        self.addChild(settingsMenu!)
    }
    
    // Create backButton
    private func createBackButton() {
        let backWidth = CGFloat(self.settingsMenu!.size.width/10)
        let backHeight = CGFloat(self.settingsMenu!.size.height/10)
        
        let backSize = CGSize(width: backWidth, height: backHeight)
        
        let backButton = SKSpriteNode(color: SKColor.yellowColor(), size: backSize)
        
        let leftOfSettingsMenu = -self.settingsMenu!.size.width/2 + backButton.size.width/2;
        let topOfSettingsMenu = self.settingsMenu!.size.height/2 - backButton.size.height/2;
        backButton.position = CGPoint(x: leftOfSettingsMenu, y: topOfSettingsMenu)
        backButton.name = "backButton"
        
        self.settingsMenu!.addChild(backButton)
    }
    
    //Create the button to choose the control type
    private func createButtonsToChooseControlType() {
        let buttonsWidth = CGFloat(self.settingsMenu!.size.width/10)
        let buttonsHeight = CGFloat(self.settingsMenu!.size.height/10)
        
        let buttonsSize = CGSize(width: buttonsWidth, height: buttonsHeight)
        
        self.swipeMode = SKSpriteNode(color: SKColor.greenColor(), size: buttonsSize)
        self.buttonMode = SKSpriteNode(color: SKColor.redColor(), size: buttonsSize)
        
        swipeMode!.name = "swipeMode"
        buttonMode!.name = "buttonMode"
        
        swipeMode!.position = CGPoint(x: -100, y: -200)
        buttonMode!.position = CGPoint(x: 100, y: -200)
        
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
        } else if node.name == "buttonMode" {
            print("ButtonMode activated")
            changeColor(node)
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
