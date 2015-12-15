//
//  File.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 09/12/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

extension OnlineGameLayer {

	func didBeginContact(contact: SKPhysicsContact) {
		let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		switch(contactMask) {
			
		case PhysicsCategory.Player.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue,
		PhysicsCategory.Player.rawValue | PhysicsCategory.WorldFirstFloorPlatform.rawValue,
		PhysicsCategory.Player.rawValue | PhysicsCategory.WorldSecondFloorPlatform.rawValue,
		PhysicsCategory.Player.rawValue | PhysicsCategory.WorldThirdFloorPlatform.rawValue:
			
			self.canPlayerJump = true
			
		case PhysicsCategory.MeleeBox.rawValue | PhysicsCategory.OtherPlayer.rawValue:
			if contact.bodyA.categoryBitMask == PhysicsCategory.MeleeBox.rawValue {
				
				let index = self.players.indexOf(contact.bodyB.node as! Player)!
				
				print(self.checkIndex(index, atArray: self.normalAreaPlayersIndex))
				
				if self.checkIndex(index, atArray: self.normalAreaPlayersIndex) == false {
					self.normalAreaPlayersIndex.append(index)
				}
			} else {
				let index = self.players.indexOf(contact.bodyA.node as! Player)!
				
				print(self.checkIndex(index, atArray: self.normalAreaPlayersIndex))
				
				if self.checkIndex(index, atArray: self.normalAreaPlayersIndex) == false {
					self.normalAreaPlayersIndex.append(index)
				}
			}
			
		case PhysicsCategory.Projectile.rawValue | PhysicsCategory.Player.rawValue:
			var projectile: Projectile?
			
			print("projetil me acertou")
			
			if contact.bodyA.categoryBitMask == PhysicsCategory.Projectile.rawValue {
				projectile = contact.bodyA.node as? Projectile
			} else {
				projectile = contact.bodyB.node as? Projectile
			}
			
			projectile?.hitSound()
			projectile?.runAction(SKAction.removeFromParent())
			
		case PhysicsCategory.Projectile.rawValue | PhysicsCategory.OtherPlayer.rawValue:
			var player: Player?
			var projectile: Projectile?
			
			if contact.bodyA.categoryBitMask == PhysicsCategory.OtherPlayer.rawValue {
				player = (contact.bodyA.node as! Player)
				projectile = contact.bodyB.node as? Projectile
			} else {
				player = (contact.bodyB.node as? Player)
				projectile = contact.bodyA.node as? Projectile
			}
			
			print("projectile: \(projectile?.ownerIndex)")
			print("self: \(self.currentIndex)")
			
			if (projectile?.ownerIndex)! != self.players.indexOf(player!)! {
				projectile?.hitSound()
				projectile?.runAction(SKAction.removeFromParent())
				
				if projectile?.canDealDamage == true {
					projectile?.canDealDamage = false
					
					
					let damage = self.player.attackDamage
					
					if player!.currentLife! - damage! > 0 {
						
						player!.currentLife = player!.currentLife! - damage!
						
						self.networkingEngine?.sendLoseLife(player!.currentLife!, playerIndex: self.players.indexOf(player!)!)
						
					} else {
						player!.currentLife = 0
						
						if player!.isDead == false {
							self.score++
							self.hudLayer?.updateScoreLabel(withScore: self.score)
							self.networkingEngine?.sendLoseLife(player!.currentLife!, playerIndex: self.players.indexOf(player!)!)
						}
					}
					
					
					hudLayer?.animateBar(player!.currentLife!, bar: player!.life!, node: player!.lifeBar, scale: 0.01)
				}
			}
		case PhysicsCategory.SpecialBox.rawValue | PhysicsCategory.OtherPlayer.rawValue:
			if contact.bodyA.categoryBitMask == PhysicsCategory.SpecialBox.rawValue {
				let index = self.players.indexOf(contact.bodyB.node as! Player)!
				
				if self.checkIndex(index, atArray: self.specialAreaPlayersIndex) == false {
					self.specialAreaPlayersIndex.append(index)
				}
			} else {
				let index = self.players.indexOf(contact.bodyA.node as! Player)!
				
				if self.checkIndex(index, atArray: self.specialAreaPlayersIndex) == false {
					self.specialAreaPlayersIndex.append(index)
				}
			}
		case PhysicsCategory.Player.rawValue | PhysicsCategory.DeathBox.rawValue:
			if self.player.isDead == false {
				self.player.currentLife = 0
				if IS_ONLINE == true {
					self.score--
					self.hudLayer?.updateScoreLabel(withScore: self.score)
					self.networkingEngine?.sendLoseLife(self.player!.currentLife!, playerIndex: self.players.indexOf(self.player!)!)
				}
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
			
			// If player began the contact with floor and he is not jumping, he can jump again
			//            if self.player.isJumping == false {
			//                self.player.jumpCount = 0
			//            }
			self.canPlayerJump = false
		case PhysicsCategory.MeleeBox.rawValue | PhysicsCategory.OtherPlayer.rawValue:
			if self.normalAreaPlayersIndex.count > 0 {
				if contact.bodyA.categoryBitMask == PhysicsCategory.OtherPlayer.rawValue {
					let player = (contact.bodyA.node as! Player)
					let playerIndex = self.players.indexOf(player)
					
					if checkIndex(playerIndex!, atArray: self.normalAreaPlayersIndex) == true {
						print("removing player index: \(playerIndex)")
						self.normalAreaPlayersIndex.removeAtIndex(self.normalAreaPlayersIndex.indexOf(playerIndex!)!)
					}
				} else {
					let player = (contact.bodyB.node as! Player)
					let playerIndex = self.players.indexOf(player)
					
					if checkIndex(playerIndex!, atArray: self.normalAreaPlayersIndex) == true {
						print("removing player index: \(playerIndex)")
						self.normalAreaPlayersIndex.removeAtIndex(self.normalAreaPlayersIndex.indexOf(playerIndex!)!)
					}
				}
			}
		case PhysicsCategory.SpecialBox.rawValue | PhysicsCategory.OtherPlayer.rawValue:
			if self.specialAreaPlayersIndex.count > 0 {
				if contact.bodyA.categoryBitMask == PhysicsCategory.SpecialBox.rawValue {
					self.specialAreaPlayersIndex.removeAtIndex(self.specialAreaPlayersIndex.indexOf((self.players.indexOf(contact.bodyB.node as! Player)!))!)
				} else {
					self.specialAreaPlayersIndex.removeAtIndex(self.specialAreaPlayersIndex.indexOf((self.players.indexOf(contact.bodyA.node as! Player)!))!)
				}
				
			}
		default:
			return
		}
	}
}