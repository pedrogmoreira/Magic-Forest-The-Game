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
		
		self.life = 1_000
		self.energy = 100
		self.attackDamage = 100
		self.specialDamage = 200
		self.movementVelocity = CGVector(dx: 0, dy: 0)
		self.movementSpeed = 20
		self.jumpForce = 100_000
		self.defesa = 20 //defende 20% do dano
		self.attackSpeed = 2
		self.doubleJump = true
		//Porcentagem 10% e 1%
		self.regEnergy = 10
		self.regEnergy = 1
		self.getDownForce = -50_000

	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
