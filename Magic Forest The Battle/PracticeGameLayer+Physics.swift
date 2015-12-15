//
//  PracticeGameLayer+Physics.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 11/12/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

extension PracticeGameLayer {
	
	func didBeginContact(contact: SKPhysicsContact) {
		let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		switch(contactMask) {
			
		case PhysicsCategory.Player.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue,
		PhysicsCategory.Player.rawValue | PhysicsCategory.WorldFirstFloorPlatform.rawValue,
		PhysicsCategory.Player.rawValue | PhysicsCategory.WorldSecondFloorPlatform.rawValue,
		PhysicsCategory.Player.rawValue | PhysicsCategory.WorldThirdFloorPlatform.rawValue:
			
			self.canPlayerJump = true
			
		case PhysicsCategory.MeleeBox.rawValue | PhysicsCategory.Enemy.rawValue:
			
			self.isOnMeleeCollision = true
			
		case PhysicsCategory.Projectile.rawValue | PhysicsCategory.Enemy.rawValue:
			
			var projectile: Projectile?
			
			if contact.bodyA.categoryBitMask == PhysicsCategory.Enemy.rawValue {
				projectile = contact.bodyB.node as? Projectile
			} else {
				projectile = contact.bodyA.node as? Projectile
			}
			
			projectile?.hitSound()
			projectile?.runAction(SKAction.removeFromParent())
			
			if projectile?.canDealDamage == true {
				projectile?.canDealDamage = false
				
				let damage = self.player.attackDamage
				
				if self.enemy!.currentLife! - damage! > 0 {
					
					self.enemy!.currentLife = self.enemy!.currentLife! - damage!
					
				} else {
					self.enemy!.currentLife = 0
				}
				
				
				self.animateBar(self.enemy!.currentLife!, bar: self.enemy!.life!, node: self.enemy!.lifeBar, scale: 0.01)
			}
			
		case PhysicsCategory.SpecialBox.rawValue | PhysicsCategory.Enemy.rawValue:

			self.isOnSpecialCollision = true
			
		case PhysicsCategory.Player.rawValue | PhysicsCategory.DeathBox.rawValue:
			if self.player.isDead == false {
				self.player.currentLife = 0
			}
			
		default:
			return
		}
	}
	
	func didEndContact(contact: SKPhysicsContact) {
		let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		switch(contactMask) {
			
		case PhysicsCategory.Player.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue,
		PhysicsCategory.Player.rawValue | PhysicsCategory.WorldFirstFloorPlatform.rawValue,
		PhysicsCategory.Player.rawValue | PhysicsCategory.WorldSecondFloorPlatform.rawValue,
		PhysicsCategory.Player.rawValue | PhysicsCategory.WorldThirdFloorPlatform.rawValue:
			
			self.canPlayerJump = false
			
		case PhysicsCategory.MeleeBox.rawValue | PhysicsCategory.Enemy.rawValue:
			
			self.isOnMeleeCollision = false
			
		case PhysicsCategory.SpecialBox.rawValue | PhysicsCategory.OtherPlayer.rawValue:
			
			self.isOnSpecialCollision = false
			
		default:
			return
		}
	}
	
}