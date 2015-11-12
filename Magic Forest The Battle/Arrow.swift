//
//  Arrow.swift
//  Magic Forest The Battle
//
//  Created by Camila Ribeiro Rodrigues on 11/11/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit
class Arrow: Projectile {
	

	override init(position: CGPoint) {
		let texture = SKTexture(imageNamed: "arrow")
		
		super.init(texture: texture, color: UIColor.clearColor(), size: texture.size())
		self.position = position
		self.physicsBody = generatePhysicsBody()
	}
	
	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func generatePhysicsBody() -> SKPhysicsBody {
		let physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
		
		physicsBody.categoryBitMask = PhysicsCategory.Projectile.rawValue
		physicsBody.contactTestBitMask = PhysicsCategory.OtherPlayer.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue | PhysicsCategory.WorldBox.rawValue | PhysicsCategory.WorldFirstFloorPlatform.rawValue | PhysicsCategory.WorldSecondFloorPlatform.rawValue | PhysicsCategory.WorldThirdFloorPlatform.rawValue
		physicsBody.collisionBitMask = PhysicsCategory.WorldBaseFloorPlatform.rawValue | PhysicsCategory.WorldBox.rawValue | PhysicsCategory.WorldFirstFloorPlatform.rawValue | PhysicsCategory.WorldSecondFloorPlatform.rawValue | PhysicsCategory.WorldThirdFloorPlatform.rawValue
		physicsBody.mass = 1
		physicsBody.affectedByGravity = true
		physicsBody.allowsRotation = false
		
		return physicsBody
	}
}
