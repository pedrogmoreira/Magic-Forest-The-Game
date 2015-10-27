//
//  GameLayer.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class GameLayer: SKNode, BasicLayer, MFCSControllerDelegate {

	var player: Player?
	
	/**
	Initializes the game layer
	- parameter size: A reference to the device's screen size
	*/
	required init(size: CGSize) {
		super.init()
		
		self.player = Player(position: CGPoint(x: 100, y: 150))
		
		self.addChild(self.player!)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func update(currentTime: CFTimeInterval) {
		/* Called before each frame is rendered */
		self.player?.update(currentTime)
	}

	
	// MARK: MFCSContrllerDelegate Methods
	func recieveCommand(command: MFCSCommandType) {
		if command == MFCSCommandType.Attack {
			print("attack")
		} else if command == MFCSCommandType.Jump {
//			self.player?.removeActionForKey("moveAction")
//			runAction(self.player!.loadJumpAnimation())
			print("jump")
		}
	}
	
	func analogUpdate(relativePosition position: CGPoint) {
		self.player?.removeActionForKey("moveAction")
		self.setFlip(position)
//		let movement = SKAction.moveToX(position.x, duration: 1)
//		self.player?.runAction((self.player?.run())!, withKey: "correr")
//		let completion = SKAction.runBlock { () -> Void in
//			self.player?.removeActionForKey("correr")
//			self.player?.runAction((self.player?.idle())!)
//		}
//		let sequence = SKAction.sequence([movement,completion])
//		self.player?.runAction(sequence, withKey: "moveAction")
		player?.movementVelocity = CGVector(dx: position.x, dy: 0)
	}
	
	
	func setFlip (flipX : CGPoint) {
		if flipX.x < 0 {
			self.player?.xScale = -fabs((self.player?.xScale)!)
		} else {
			self.player?.xScale = fabs((self.player?.xScale)!)
		}
	}
	
	
}
