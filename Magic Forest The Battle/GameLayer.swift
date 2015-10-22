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
	
	// MARK: MFCSContrllerDelegate Methods
	func recieveCommand(command: MFCSCommandType) {
		if command == MFCSCommandType.Attack {
			print("attack")
		} else if command == MFCSCommandType.Jump {
			print("jump")
		}
	}
	
	func analogUpdate(relativePosition position: CGPoint) {
		player?.movementVelocity = CGVector(dx: position.x, dy: 0)
	}
}
