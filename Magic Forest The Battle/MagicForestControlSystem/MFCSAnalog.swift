//
//  MFCSAnalog.swift
//  ControllersPrototype
//
//  Created by Pedro Henrique Goncalves Moreira on 22/10/15.
//  Copyright © 2015 pedrogmoreira93. All rights reserved.
//

import UIKit

class MFCSAnalog: UIView {
	
	var delegate: MFCSControllerDelegate?
	var controllerMode: MFCSControllerMode?
	var knobImageView: UIImageView
	var baseCenter: CGPoint
	var relativePosition: CGPoint
	var controlSize: CGFloat
	
	override init(frame: CGRect) {
		
		baseCenter = CGPoint(x: frame.size.width/2, y: frame.size.height/2)
		
		knobImageView = UIImageView(image: UIImage(named: "JoystickKnob"))
		
		knobImageView.center = baseCenter
		controlSize = CGFloat()
		relativePosition = CGPoint()
		super.init(frame: frame)
		userInteractionEnabled = false
		
		let baseImageView = UIImageView(frame: bounds)
		baseImageView.image = UIImage(named: "JoystickBase")
		addSubview(baseImageView)
		
		addSubview(knobImageView)
		
		assert(CGRectContainsRect(bounds, knobImageView.bounds), "Analog control should be larger than the knob in size")
		controlSize = self.frame.width/4 + self.knobImageView.frame.width/4
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func updateKnobWithPosition(position: CGPoint) {
		
		// Get distance to touch
		var positionToCenter = position - baseCenter
		var direction: CGPoint
		
		// if distance to touch is zero, do nothing.
		if positionToCenter == CGPointZero {
			direction = CGPointZero
		} else {
			direction = positionToCenter.normalized()
		}
		// check distance to touch and radius of analog.
		let radius = frame.size.width/2
		var length = positionToCenter.length()
		
		// if touch distance is greater than 1.5 points, update the whole analog, constraining him to half screen.
		if length - radius > 1.5{
			let offset = direction * (length - radius)
			self.center += CGPointMake(offset.x, offset.y)
			checkBounds()
		}
		
		if length > radius {
			length = radius
			positionToCenter = direction * radius
		}
		
		knobImageView.center = baseCenter + positionToCenter
		let relPosition = CGPoint(x: direction.x * (length/radius), y: -direction.y * (length/radius))
		relativePosition = relPosition.normalized()
		
		if controllerMode == MFCSControllerMode.JoystickAndButton {
			if relativePosition.y > 0.99 {
				delegate?.recieveCommand(MFCSCommandType.Jump)
			}
		}
		
		delegate?.analogUpdate(relativePosition: relativePosition)
	}
	
	func checkBounds(){
		// Uncomment if lefty mode is implemented
		if (lefty){
			if (self.center.x < controlSize){
				self.center.x = controlSize
			}
		} else {
			if (self.center.x > UIScreen.mainScreen().bounds.width/2 - controlSize){
				self.center.x = UIScreen.mainScreen().bounds.width/2 - controlSize
			}
		}
		
	}
	
	func touchBegan(touch: UITouch, withEvent event: UIEvent?) {
		let touchLocation = touch.locationInView(self)
		updateKnobWithPosition(touchLocation)
		self.alpha = 0.3
	}
	
	func touchMoved(touch: UITouch, withEvent event: UIEvent?) {
		let touchLocation = touch.locationInView(self)
		updateKnobWithPosition(touchLocation)
		self.alpha = 0.3
		
	}
	
	func end() {
		updateKnobWithPosition(baseCenter)
		self.alpha = 0
	}

}
