//
//  MFCSCommandView.swift
//  ControllersPrototype
//
//  Created by Pedro Henrique Goncalves Moreira on 22/10/15.
//  Copyright © 2015 pedrogmoreira93. All rights reserved.
//

import UIKit

class MFCSCommandView: UIView {
	
	// MARK: Atributes
	
	var delegate: MFCSControllerDelegate?
	
	// MARK: Init
	
	/**
	Initializes the command view
	- parameter frame: The view CGRect
	- parameter controllerMode: The type of controller to be used
	*/
	init(var frame: CGRect, controllerMode: MFCSControllerMode) {
		frame = CGRectMake(frame.width/2, 0, frame.width/2, frame.height)
		super.init(frame: frame)
		self.userInteractionEnabled = true
		
		updateCenter()
		
		if controllerMode == MFCSControllerMode.JoystickAndButton {
			
			let ratio = frame.size.width / frame.size.height
			
			let imageAttack = UIImage(named: "AttackButton.png")
			let width = (imageAttack?.size.width)! * ratio * 0.7
			let height = (imageAttack?.size.height)! * ratio * 0.7
			
			let buttonAttack = UIButton(frame: CGRect(x: frame.size.width - width - 20, y: frame.size.height - height - 20, width: width, height: height))
			buttonAttack.setImage(imageAttack, forState: UIControlState.Normal)
			buttonAttack.addTarget(self, action: "attack", forControlEvents: UIControlEvents.TouchUpInside)
			self.addSubview(buttonAttack)
			
			let imageSpecialAttack = UIImage(named: "SpecialButton.png")
			
			let buttonSpecialAttack = UIButton(frame: CGRect(x: frame.size.width - width * 2 - 40, y: frame.size.height - height - 20, width: width, height: height))
			buttonSpecialAttack.setImage(imageSpecialAttack, forState: UIControlState.Normal)
			buttonSpecialAttack.addTarget(self, action: "specialAttack", forControlEvents: UIControlEvents.TouchUpInside)
			self.addSubview(buttonSpecialAttack)
			
		} else if controllerMode == MFCSControllerMode.JoystickAndSwipe {
			let tapTest = UITapGestureRecognizer(target: self, action: "attack")
			self.addGestureRecognizer(tapTest)
			
			let swipeUp = UISwipeGestureRecognizer(target: self, action: "jump")
			swipeUp.direction = UISwipeGestureRecognizerDirection.Up
			self.addGestureRecognizer(swipeUp)
			
			let swipeRight = UISwipeGestureRecognizer(target: self, action: "specialAttack")
			swipeRight.direction = UISwipeGestureRecognizerDirection.Right
			self.addGestureRecognizer(swipeRight)
			
			let swipeDown = UISwipeGestureRecognizer(target: self, action: "getDown")
			swipeDown.direction = UISwipeGestureRecognizerDirection.Down
			self.addGestureRecognizer(swipeDown)

		}
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: View Positioning
	
	/**
	Check if view is in the correct place, based on lefty configuration
	*/
	func updateCenter(){
		if (LEFTY == true){
			self.center.x = frame.width/2
		}
		else {
			self.center.x = frame.width*3/2
		}
	}
	
	// MARK: Command Message Sender
	
	/**
	Sends the attack command to delegate
	*/
	func attack(){
		delegate?.recieveCommand(MFCSCommandType.Attack)
	}
	
	/**
	Sends the special attack command to delegate
	*/
	func specialAttack(){
		delegate?.recieveCommand(MFCSCommandType.SpecialAttack)
	}
	
	/**
	Sends the jump commando to delegate
	*/
	func jump(){
		delegate?.recieveCommand(MFCSCommandType.Jump)
	}
	
	func getDown() {
		delegate?.recieveCommand(MFCSCommandType.GetDown)
	}
	
}
