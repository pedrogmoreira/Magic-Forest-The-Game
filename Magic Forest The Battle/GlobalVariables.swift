//
//  GlobalVariables.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 09/12/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import Foundation

// Check if is online game
var IS_ONLINE = true

// Default screen size
let DEFAULT_WIDTH = CGFloat(667)
let DEFAULT_HEIGHT = CGFloat(375)

// Lefty controllers configuration
var LEFTY = false

// Bitmask values, made for avoid code repetition
let BITMASK_BASE_FLOOR = PhysicsCategory.WorldBox.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue
let BITMASK_FIRST_FLOOR = PhysicsCategory.WorldBox.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue | PhysicsCategory.WorldFirstFloorPlatform.rawValue
let BITMASK_SECOND_FLOOR = PhysicsCategory.WorldBox.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue | PhysicsCategory.WorldFirstFloorPlatform.rawValue | PhysicsCategory.WorldSecondFloorPlatform.rawValue
let BITMASK_THIRD_FLOOR = PhysicsCategory.WorldBox.rawValue | PhysicsCategory.WorldBaseFloorPlatform.rawValue | PhysicsCategory.WorldFirstFloorPlatform.rawValue | PhysicsCategory.WorldSecondFloorPlatform.rawValue | PhysicsCategory.WorldThirdFloorPlatform.rawValue