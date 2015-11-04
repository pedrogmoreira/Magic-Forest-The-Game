//
//  Dinak.swift
//  Magic Forest The Battle
//
//  Created by Camila Ribeiro Rodrigues on 26/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit

class Dinak: Player {
	required init(position: CGPoint) {
		super.init(position: position)
		
		self.position = position
		
		self.life = 1000
		self.energy = 100
		self.attackDamage = 100
		self.specialDamage = 200
		self.movementVelocity = CGVector(dx: 0, dy: 0)
		self.movementSpeed = 20
		self.jumpForce = 100000
		self.defesa = 20 //defende 20% do dano
		self.attackSpeed = 2
		self.doubleJump = true
		//Porcentagem 10% e 1%
		self.regEnergy = 10
		self.regEnergy = 1
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
