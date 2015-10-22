//
//  MFCSMovementView.swift
//  ControllersPrototype
//
//  Created by Pedro Henrique Goncalves Moreira on 22/10/15.
//  Copyright © 2015 pedrogmoreira93. All rights reserved.
//

import UIKit

class MFCSMovementView: UIView {
	
	var analog: MFCSAnalog?
	var firstTouch: Int?
	
	override init(var frame: CGRect) {
		
		//resize frame to half screen
		frame = CGRectMake(0, 0, frame.width/2, frame.height)
		
		let padSide: CGFloat =  128
		analog = MFCSAnalog(frame: CGRectMake(0, 0, padSide, padSide))
		
		super.init(frame: frame)
		updateCenter()

		analog!.alpha = 0
		self.addSubview(analog!)
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func updateCenter(){
		if (lefty){
			self.center.x = frame.width*3/2
		}
		else {
			self.center.x = frame.width/2
		}
	}
	
	override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		for touch in touches {
			
			if (firstTouch == nil){
				firstTouch = touch.hashValue
			}
			
			let location = touch.locationInView(self)
			if (touch.hashValue == firstTouch){
				if analog!.alpha == 0{
					analog!.center = location
					analog!.touchBegan(touch, withEvent: event)
				}
			}
		}
	}
	
	override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		for touch in touches {
			if (touch.hashValue == firstTouch){
				analog!.touchMoved(touch, withEvent: event)
			}
		}
	}
	
	override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		for touch in touches {
			if (touch.hashValue == firstTouch){
				if analog!.alpha != 0{
					analog!.end()
				}
				firstTouch = nil
			}
		}
	}
	
	override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		if analog!.alpha != 0{
			analog!.end()
		}
		firstTouch = nil
	}
}
