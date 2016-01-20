//
//  Jujuba.swift
//  Magic Forest The Battle
//
//  Created by Camila Ribeiro Rodrigues on 12/11/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit

class Jujuba: Projectile {
	override init(position: CGPoint) {
		
		let index = Int.random(min: 1, max: 3)
		
		let texture = SKTexture(imageNamed: "Jububa\(index)")
		
		super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
		self.position = position
		
		self.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_PI / 4), duration: 0.5)))
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func generatePhysicsBody(isMainPlayer: Bool, ownerIndex: Int) -> SKPhysicsBody {
		
		let physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
		
		if isMainPlayer == true {
			physicsBody.categoryBitMask = PhysicsCategory.Projectile.rawValue
			physicsBody.contactTestBitMask = PhysicsCategory.OtherPlayer.rawValue | PhysicsCategory.Enemy.rawValue
			physicsBody.collisionBitMask = PhysicsCategory.WorldBox.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue | PhysicsCategory.WorldSecondFloorPlatform.rawValue | PhysicsCategory.WorldThirdFloorPlatform.rawValue
			physicsBody.mass = 1
			physicsBody.affectedByGravity = true
			physicsBody.allowsRotation = true
		} else {
			physicsBody.categoryBitMask = PhysicsCategory.Projectile.rawValue
			physicsBody.contactTestBitMask = PhysicsCategory.Player.rawValue | PhysicsCategory.OtherPlayer.rawValue
			physicsBody.collisionBitMask = PhysicsCategory.WorldBox.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue | PhysicsCategory.WorldSecondFloorPlatform.rawValue | PhysicsCategory.WorldThirdFloorPlatform.rawValue
			physicsBody.mass = 1
			physicsBody.affectedByGravity = true
			physicsBody.allowsRotation = true
		}
		return physicsBody
	}
}
