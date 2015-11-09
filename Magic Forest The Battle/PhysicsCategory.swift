//
//  PhysicsCategory.swift
//  Magic Forest The Battle
//
//  Created by Marcelo Cristiano Araujo Silva on 26/10/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit

enum PhysicsCategory: UInt32 {
	
	case Nothing = 0
    case Player = 2
	case WorldBox = 4
	case WorldBaseFloorPlatform = 8
	case WorldFirstFloorPlatform = 16
	case WorldSecondFloorPlatform = 32
	case WorldThirdFloorPlatform = 64
	
}