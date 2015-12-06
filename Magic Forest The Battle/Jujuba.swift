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
			
		self.physicsBody = generatePhysicsBody()
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func generatePhysicsBody() -> SKPhysicsBody {
		let physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
		
		physicsBody.categoryBitMask = PhysicsCategory.Projectile.rawValue
		physicsBody.contactTestBitMask = PhysicsCategory.OtherPlayer.rawValue | BITMASK_THIRD_FLOOR
		physicsBody.collisionBitMask = PhysicsCategory.WorldBaseFloorPlatform.rawValue | BITMASK_THIRD_FLOOR 
		physicsBody.mass = 1
		physicsBody.affectedByGravity = true
		physicsBody.allowsRotation = true
		
		return physicsBody
	}
}
