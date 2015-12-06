//
//  GameOverLayer.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 27/11/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

class GameOverLayer: SKNode, BasicLayer {
	
	var loadNode: SKSpriteNode?
	
	required init(size: CGSize) {
		super.init()
		
		self.waitForScores()
	}

	required init?(coder aDecoder: NSCoder) {
	    fatalError("init(coder:) has not been implemented")
	}
	
	func waitForScores() {
		let message = NSLocalizedString("WaitingForScores", comment: "Waiting for other players to send their scores")
		let waitingLabel = SKLabelNode(text: message)
		let loadImage = SKSpriteNode(imageNamed: "loading.png")

		let widthLabel = waitingLabel.frame.width
		let heightLabel = waitingLabel.frame.height
		
		let sideImage = waitingLabel.frame.height
		
		loadImage.size = CGSize(width: sideImage, height: sideImage)
		
		let totalWidth = waitingLabel.frame.width + sideImage + 10
		
		self.loadNode = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: totalWidth, height: heightLabel))
		
		self.addChild(self.loadNode!)
		self.loadNode!.anchorPoint = CGPoint.zero
		self.loadNode!.position.x -= self.loadNode!.size.width / 2
		self.loadNode!.position.y -= self.loadNode!.size.height / 2
		
		self.loadNode!.addChild(waitingLabel)
		self.loadNode!.addChild(loadImage)
		
		waitingLabel.position = CGPoint(x: widthLabel / 2, y: heightLabel / 8)
		loadImage.position.x = self.loadNode!.size.width - loadImage.size.width / 2
		loadImage.position.y += self.loadNode!.size.height / 2
		
		loadImage.runAction(SKAction.repeatActionForever(SKAction.rotateByAngle(CGFloat(M_PI / 4), duration: 0.5)))
	}
	
	func removeLoad() {
		self.loadNode?.runAction(SKAction.fadeAlphaTo(0, duration: 0.2), completion: {
			
			self.loadNode?.removeFromParent()
			self.loadNode = nil
		})
	}
	
	func showTwoPlayerScores(scores: [Int], players: [String]) {
		let scoresLabel = SKLabelNode(text: "Scores:")
		scoresLabel.position = CGPoint(x: scoresLabel.frame.width / 2, y: -scoresLabel.frame.height)
//		scoresLabel.fontSize = 14
		
		var y = CGFloat(0)
		
		let playerOneScore = SKLabelNode(text: "\(players[0]): \(scores[0])")
		y = scoresLabel.position.y - playerOneScore.frame.height * 2
		playerOneScore.position = CGPoint(x: playerOneScore.frame.width / 2, y: y)
//		playerOneScore.fontSize = 12
		
		let playerTwoScore = SKLabelNode(text: "\(players[1]): \(scores[1])")
		y = playerOneScore.position.y - playerTwoScore.frame.height * 2
		playerTwoScore.position = CGPoint(x: playerTwoScore.frame.width / 2, y: y)
//		playerTwoScore.fontSize = 12
		
		let totalWidth = self.getHightestWidth([playerOneScore, playerTwoScore])
		let totalHeight = -playerTwoScore.position.y
		
		let scoresNode = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: totalWidth, height: totalHeight))
		scoresNode.anchorPoint = CGPoint(x: 0, y: 1)
		self.addChild(scoresNode)
		
		scoresNode.addChild(scoresLabel)
		scoresNode.addChild(playerOneScore)
		scoresNode.addChild(playerTwoScore)
		
		scoresNode.position = CGPoint(x: -scoresNode.size.width / 2, y: scoresNode.size.height / 2)
		
		let touchToContinueMessage = NSLocalizedString("TouchToContinue", comment: "Touch anywhere to go to main menu screen")
		let touchToContinueLabel = SKLabelNode(text: touchToContinueMessage)
		
		y = scoresNode.position.y - scoresNode.size.height - touchToContinueLabel.frame.height * 2
		
		touchToContinueLabel.position = CGPoint(x: 0, y: y)
		
		self.addChild(touchToContinueLabel)
		
	}
	
	func getHightestWidth(nodes: [SKLabelNode]) -> CGFloat {
		var highestIndex = 0
		for index in 0...nodes.count - 1 {
			if index != nodes.count - 1 {
				if nodes[index].frame.width > nodes[index + 1].frame.width {
					highestIndex = index
				} else {
					highestIndex = index + 1
				}
			}
		}
		
		return nodes[highestIndex].frame.width
	}
	
	
}
