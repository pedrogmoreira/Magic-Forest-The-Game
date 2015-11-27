//
//  SettingsLayer.swift
//  Magic Forest The Battle
//
//  Created by Marcelo Cristiano Araujo Silva on 27/11/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit

class SettingsLayer: SKNode, BasicLayer {
    
    let size: CGSize!
    var settingsMenu: SKSpriteNode?
    
    
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
    func createBackButton() {
        let backWidth = CGFloat(self.settingsMenu!.size.width/10)
        let backHeight = CGFloat(self.settingsMenu!.size.height/10)
        
        let backSize = CGSize(width: backWidth, height: backHeight)
        
        let backButton = SKSpriteNode(color: SKColor.yellowColor(), size: backSize)
        
        let leftOfSettingsMenu = -self.settingsMenu!.size.width/2 + backButton.size.width/2;
        let topOfSettingsMenu = self.settingsMenu!.size.height/2 - backButton.size.height/2;
        backButton.position = CGPoint(x: leftOfSettingsMenu, y: topOfSettingsMenu)
        
        self.settingsMenu!.addChild(backButton)
    }
    
}
