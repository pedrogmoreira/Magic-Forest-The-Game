//
//  MenuSelectPlayerScene.swift
//  Magic Forest The Battle
//
//  Created by Camila Ribeiro Rodrigues on 12/11/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit
class MenuSelectPlayerScene: SKScene {
	var menu: MenuSelectPlayer?
	
	/**
	Initializes the game scene
	- parameter size: A reference to the device's screen size
	*/
	override init(size: CGSize) {
		super.init(size: size)
		
	}
	
	override func didMoveToView(view: SKView) {
		self.menu = MenuSelectPlayer(size: size, view: view)
		self.addChild(menu!)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		self.menu?.touchesBegan(touches, withEvent: event)
	}
}
