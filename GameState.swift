//
//  GameState.swift
//  Magic Forest The Battle
//
//  Created by Marcelo Cristiano Araujo Silva on 27/11/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit

let stateSingleton = GameState()

class GameState: NSObject {
    
    var controllerMode: MFCSControllerMode?
    
    class var sharedInstance: GameState {
        return stateSingleton
    }
    
    override init() {
        self.controllerMode = MFCSControllerMode.JoystickAndSwipe
        super.init()
    }
    
}
