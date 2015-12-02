//
//  SpawnPoint.swift
//  Magic Forest The Battle
//
//  Created by Camila Ribeiro Rodrigues on 30/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit

class SpawnPoint: SKSpriteNode {
	
	var isBeingUsed = false
	
	init (position: CGPoint) {
		super.init(texture: SKTexture(), color: UIColor.clearColor(), size: CGSizeMake(5, 5))
		
		self.position = position
		self.colorBlendFactor = 1
	}
	
	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	/**
	Fechar Spawn Point
	- parameter: duration: Duração que o spawn point estará fechado
	*/
	func closeSpawnPoint (duration: NSTimeInterval) {
		let closeSpawnPoint = SKAction.runBlock { () -> Void in
			self.isBeingUsed = true
		}
		let waitForDuration = SKAction.waitForDuration(duration)
		let openSpawnPoint = SKAction.runBlock { () -> Void in
			self.isBeingUsed = false
		}
		let sequence = SKAction.sequence([closeSpawnPoint,waitForDuration,openSpawnPoint])
		
		runAction(sequence)
	}

}
