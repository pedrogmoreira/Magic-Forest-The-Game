//
//  MFCSControllerDelegate.swift
//  ControllersPrototype
//
//  Created by Pedro Henrique Goncalves Moreira on 22/10/15.
//  Copyright © 2015 pedrogmoreira93. All rights reserved.
//

import UIKit

protocol MFCSControllerDelegate {

	func recieveCommand(command: MFCSCommandType)
	func analogUpdate(relativePosition position: CGPoint)
	
}
