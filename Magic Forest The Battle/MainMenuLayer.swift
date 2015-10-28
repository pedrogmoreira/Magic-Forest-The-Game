//
//  MainMenuLayer.swift
//  Magic Forest The Battle
//
//  Created by Marcelo Cristiano Araujo Silva on 28/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class MainMenuLayer: SKNode, BasicLayer {
    private var size: CGSize?
    
    required init(size: CGSize) {
        super.init()
        
        self.size = size
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
