//
//  MenuScene.swift
//  Magic Forest The Battle
//
//  Created by Marcelo Cristiano Araujo Silva on 28/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene, MultiplayerProtocol {
    
    var mainMenu: MainMenuLayer?
    var networkingEngine: MultiplayerNetworking?
    
    /**
     Initializes the game scene
     - parameter size: A reference to the device's screen size
     */
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        self.mainMenu = MainMenuLayer(size: size, view: view)
        self.addChild(mainMenu!)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.mainMenu?.touchesBegan(touches, withEvent: event)
    }
    
    func matchEnded() {
        
    }
    
}
