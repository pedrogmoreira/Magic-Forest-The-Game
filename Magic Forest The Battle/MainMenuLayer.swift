//
//  MainMenuLayer.swift
//  Magic Forest The Battle
//
//  Created by Marcelo Cristiano Araujo Silva on 28/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class MainMenuLayer: SKNode, BasicLayer, UIGestureRecognizerDelegate {
    private var size: CGSize?
    private var view: SKView?
    
    private let configurationButton = SKSpriteNode(imageNamed: "configurationButton.png")
    private let gameCenterButton = SKSpriteNode(imageNamed: "gameCenterButton.png")
    private let practiceButton = SKSpriteNode(imageNamed: "practiceButton.png")
    private let playButton = SKSpriteNode(imageNamed: "playButton.gif")
    private let storeButton = SKSpriteNode(imageNamed: "storeButton.jpg")

    
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
        
        self.addButtonsToLayer()
        self.addSwipeGestureToLayer()
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        addButton(configurationButton, name: "configurationButton", position: configurationButtonPosition)
        
        // Adding gameCenter Button
        self.gameCenterButton.setScale(0.2)
        let halfGameCenterButtonWidth = self.gameCenterButton.size.width/2
        let halfGameCenterButtonHeight = self.gameCenterButton.size.height/2
        let gameCenterButtonPosition = CGPoint(x: 0 + halfGameCenterButtonWidth + padding, y: self.size!.height - halfGameCenterButtonHeight - padding)
        addButton(gameCenterButton, name: "gameCenterButton", position: gameCenterButtonPosition)
        
        // Adding play Button
        self.playButton.setScale(0.5)
        let playButtonPosition = CGPoint(x: self.size!.width/4 , y: self.size!.height/4)
        addButton(playButton, name: "playButton", position: playButtonPosition)
        
        // Adding practice Button
        self.practiceButton.setScale(0.5)
        let practiceButtonPosition = CGPoint(x: 3*self.size!.width/4 , y: self.size!.height/4)
        addButton(practiceButton, name: "practiceButton", position: practiceButtonPosition)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        // Getting a node in the touch location
        let touch = touches.first
        let touchLocation = touch?.locationInNode(self)
        let nodeTouched = self.nodeAtPoint(touchLocation!)
        
        let nodeName = nodeTouched.name
        
        if nodeName == "playButton" {
            print("playButton touched")
        } else if nodeName == "configurationButton" {
            print("configurationButton touched")
        } else if nodeName == "practiceButton" {
            print("practiceButton touched")
        } else if nodeName == "gameCenterButton" {
            print("gameCenterButton touched")
        }
    }
    
    // Add swipes gestures to the layer
    private func addSwipeGestureToLayer() {
        // Configuring right swipe gesture
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        rightSwipe.delegate = self
        rightSwipe.direction = .Right
        
        // Configuring left swipe gesture
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: "handleSwipe:")
        leftSwipe.delegate = self
        rightSwipe.direction = .Left
        
        // Adding gestures to the view
        self.view?.addGestureRecognizer(rightSwipe)
        self.view?.addGestureRecognizer(leftSwipe)
    }
    
    // Handle the given swipe
    func handleSwipe(sender: UISwipeGestureRecognizer) {
        if sender.direction == .Right {
            print("swipe to right")
        } else if sender.direction == .Left {
            print("swipe to left")
        }
    }
}
