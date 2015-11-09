//
//  GameState.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 08/11/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class GameState: NSObject {
	
	private static var sharedGameState: GameState?
	
	var player: Player?
	
	override init() {
		NSException.raise( "Singleton", format: "Use GameState.sharedInstance() instead.", arguments: CVaListPointer(_fromUnsafeMutablePointer: nil))
	}
	
	private init(singleton: Bool) {
		super.init()
	}
	
	static func sharedInstance() -> GameState {
		if sharedGameState == nil {
			sharedGameState = GameState(singleton: true)
		}
		
		return sharedGameState!
	}
}
