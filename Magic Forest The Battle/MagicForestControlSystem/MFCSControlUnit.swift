//
//  MFCSControlUnit.swift
//  ControllersPrototype
//
//  Created by Pedro Henrique Goncalves Moreira on 22/10/15.
//  Copyright © 2015 pedrogmoreira93. All rights reserved.
//

import UIKit

class MFCSControlUnit: UIView {
	
	// MARK: Atributes
	
	var movementView: MFCSMovementView?
	var commandView: MFCSCommandView?
	
	// MARK: Init
	
	/**
	Initializes the control unit for the controllers
	- parameter frame: The view CGRect
	- parameter delegate: The class that implements delegate functions
	- parameter controllerMode: The type of controller
	*/
	init(frame: CGRect, delegate: MFCSControllerDelegate, controllerMode: MFCSControllerMode) {
		super.init(frame: frame)
		
		movementView = MFCSMovementView(frame: frame)
		commandView = MFCSCommandView(frame: frame, controllerMode: controllerMode)
		
		self.addSubview(commandView!)
		self.addSubview(movementView!)
		
		commandView?.delegate = delegate
		movementView?.analog?.delegate = delegate
		
		movementView?.analog?.controllerMode = controllerMode
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: View Positioning
	
	/**
	Check all views position
	*/
	func updateCenters(){
		movementView!.updateCenter()
		commandView!.updateCenter()
	}

}
