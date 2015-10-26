//
//  GameObject.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

@objc protocol GameObject {
	
	init(position: CGPoint)
	func generatePhysicsBody() -> SKPhysicsBody
    optional func setBasicAttributes()

}
