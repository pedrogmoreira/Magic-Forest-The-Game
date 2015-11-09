//
//  Salamang.swift
//  Magic Forest The Battle
//
//  Created by Camila Ribeiro Rodrigues on 26/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit

class Salamang: Player {
	required init(position: CGPoint, screenSize: CGSize) {
		super.init(position: position, screenSize: screenSize)
		
		self.position = position
		
		self.life = 1_000
		self.energy = 100
		self.attackDamage = 150
		self.specialDamage = 200
		self.movementVelocity = CGVector(dx: 0, dy: 0)
		self.movementSpeed = 10
		self.jumpForce = 100_000
		self.defesa = 20 //Defende 20% do dano
		self.attackSpeed = 1
		self.doubleJump = false
		//Porcentagem 10% e 1%
		self.regEnergy = 10
		self.regEnergy = 1
		self.getDownForce = -50_000
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
