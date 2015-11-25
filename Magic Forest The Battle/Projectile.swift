//
//  Projectile.swift
//  Magic Forest The Battle
//
//  Created by Camila Ribeiro Rodrigues on 11/11/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit

class Projectile: SKSpriteNode {
	var isLeft : Bool = false
	var damage : Double = 0.0
	var speedProje : Double = 0.0

	
	init(position : CGPoint) {
		let projectileTexture = SKTexture(imageNamed: "95")
		super.init(texture: projectileTexture, color: UIColor.clearColor(), size: projectileTexture.size())
		self.colorBlendFactor = 0
	}
	override init(texture: SKTexture?, color: UIColor, size: CGSize) {
		super.init(texture: texture, color: color, size: size)
		self.colorBlendFactor = 0
	}
	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	func removeProjectile () -> SKAction {
		return SKAction.sequence([SKAction.waitForDuration(2),SKAction.removeFromParent()])
	}
	
	func hitSound () {
		
	}
	
}
