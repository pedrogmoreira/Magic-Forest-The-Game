//
//  GameViewController.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 19/10/15.
//  Copyright (c) 2015 Team Magic Forest. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
	
    override func viewDidLoad() {
        super.viewDidLoad()

		let scene = MenuScene(size: self.view.frame.size)
        
		// Configure the view.
		let skView = self.view as! SKView
		skView.showsFPS = true
		skView.showsNodeCount = true
        skView.showsPhysics = true
		
		/* Sprite Kit applies additional optimizations to improve rendering performance */
		skView.ignoresSiblingOrder = true
		
		/* Set the scale mode to scale to fit the window */
		scene.scaleMode = .AspectFill
		
		skView.presentScene(scene)
        
        
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
