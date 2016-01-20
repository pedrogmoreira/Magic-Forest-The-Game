//
//  PacticeBackView.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 16/12/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import UIKit

class PracticeBackView: UIView {
	
	var scenesDelegate: ScenesDelegate?
	
	init(frame: CGRect, scenesDelegate: ScenesDelegate?) {
		super.init(frame: frame)
		
		self.scenesDelegate = scenesDelegate
		
		self.backgroundColor = UIColor.clearColor()
		let button = UIButton(frame: frame)
		button.backgroundColor = UIColor.clearColor()
		button.setBackgroundImage(UIImage(named: "MenuButton"), forState: UIControlState.Normal)
		button.setTitle(NSLocalizedString("Back", comment: ""), forState: UIControlState.Normal)
		button.titleLabel?.font = UIFont(name: "SnapHand", size: 28)
		button.addTarget(self, action: "backToMenu", forControlEvents: UIControlEvents.TouchUpInside)
		button.translatesAutoresizingMaskIntoConstraints = false
		self.addSubview(button)
		button.imageView?.contentMode = UIViewContentMode.ScaleToFill

		let views = ["back_button" : button]
		
		let vertical = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[back_button]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
		let horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[back_button]-0-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
		
		NSLayoutConstraint.activateConstraints(vertical)
		NSLayoutConstraint.activateConstraints(horizontal)
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func backToMenu() {
		scenesDelegate?.deinitControllersSystem()
		scenesDelegate?.showMenu()
		scenesDelegate?.removeMenuSelectPlayerScene()
		scenesDelegate?.removeGameScene()
		scenesDelegate?.removeBackButton()
	}
}
