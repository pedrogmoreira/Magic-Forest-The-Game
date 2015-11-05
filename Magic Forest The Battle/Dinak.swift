//
//  Dinak.swift
//  Magic Forest The Battle
//
//  Created by Camila Ribeiro Rodrigues on 26/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit

class Dinak: Player {
	required init(position: CGPoint, screenSize: CGSize) {
		super.init(position: position, screenSize: screenSize)
		
		self.position = position
		
		self.life = 100
		self.energy = 100
		self.movementVelocity = CGVector(dx: 0, dy: 0)
		self.movementSpeed = 2
		self.jumpForce = 400
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
