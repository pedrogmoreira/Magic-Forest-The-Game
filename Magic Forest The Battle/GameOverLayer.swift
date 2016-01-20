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
	var size: CGSize?
	
	required init(size: CGSize) {
		self.size = CGSize(width: size.width, height: size.height)
		
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
	
	func showTwoPlayerScores(scores: [Int], players: [String], characters: [Int]) {
		var x = CGFloat(0)
		var y = CGFloat(0)
		
		var width = CGFloat(0)
		var height = CGFloat(0)
		var ratio = CGFloat(0)
		
		let background = SKSpriteNode(color: UIColor.blackColor(), size: self.size!)
		background.zPosition = 0
		background.position = CGPoint.zero
		background.alpha = 0.7
		self.addChild(background)
		
		let gameOverMessage = SKSpriteNode(imageNamed: "GameOver")
		gameOverMessage.zPosition = 3
		ratio = gameOverMessage.size.width / gameOverMessage.size.height
		height = (self.size?.height)! / 4
		width = height * ratio
		gameOverMessage.size = CGSize(width: width, height: height)
		x = 0
		y = (self.size?.height)! / 2 - gameOverMessage.size.height
		gameOverMessage.position = CGPoint(x: x, y: y)
		self.addChild(gameOverMessage)
		
		let podiumLoser = SKSpriteNode(imageNamed: "PodiumPerdedor")
		podiumLoser.zPosition = 3
        podiumLoser.setScale(3)
		x = (self.size?.width)! / 2 - podiumLoser.size.width * 1.2
		y = -(self.size?.height)! / 2 + podiumLoser.size.height
		podiumLoser.position = CGPoint(x: x, y: y)
		self.addChild(podiumLoser)
		
		let podiumWinners = SKSpriteNode(imageNamed: "PodiumVencedores")
		podiumWinners.zPosition = 3
        podiumWinners.setScale(3)
		x = -(self.size?.width)! / 2 + podiumWinners.size.width * 0.75
//		y = -(self.size?.height)! / 2 + podiumWinners.size.height
		podiumWinners.position = CGPoint(x: x, y: y)
		self.addChild(podiumWinners)
		
		let winnersLight = SKSpriteNode(imageNamed: "LuzPodiumVencedores")
		winnersLight.alpha = 0.9
		winnersLight.zPosition = 2
		ratio = winnersLight.size.width / winnersLight.size.height
		height = (self.size?.height)! * 0.9
		width = height * ratio
		winnersLight.size = CGSize(width: width, height: height)
		x = podiumWinners.position.x
		y = (self.size?.height)! / 2 - winnersLight.size.height * 0.45
		winnersLight.position = CGPoint(x: x, y: y)
		self.addChild(winnersLight)
		
		let loserLight = SKSpriteNode(imageNamed: "LuzPodiumPerdedor")
		loserLight.alpha = 0.9
		loserLight.zPosition = 2
		ratio = loserLight.size.width / loserLight.size.height
		height = (self.size?.height)! * 0.85
		width = height * ratio
		loserLight.size = CGSize(width: width, height: height)
		x = podiumLoser.position.x
		y = (self.size?.height)! / 2 - loserLight.size.height * 0.45
		loserLight.position = CGPoint(x: x, y: y)
		self.addChild(loserLight)
		
		let menuButton = SKSpriteNode(imageNamed: "MenuButton")
		menuButton.name = "menu_button"
		menuButton.zPosition = 3
		ratio = menuButton.size.width / menuButton.size.height
		height = (self.size?.height)! / 5
		width = height * ratio
		menuButton.size = CGSize(width: width, height: height)
		x = -(self.size?.width)! / 2 + menuButton.size.width / 2
		y = (self.size?.height)! / 2 - menuButton.size.height / 2
		menuButton.position = CGPoint(x: x, y: y)
		self.addChild(menuButton)
		
		let menuLabel = SKLabelNode(fontNamed: "SnapHand")
		menuLabel.name = "menu_button_label"
		menuLabel.text = "Menu"
		menuLabel.alpha = 0.6
		menuLabel.zPosition = 4
		menuButton.addChild(menuLabel)
		
		let scoresDetails = ScoreDetails.generateDetails(characters, scores: scores, aliases: players)
		let playersImages = generateImagesTwoPlayer(scoresDetails)
		
		var percent = CGFloat(0.5)
		
		let player1 = playersImages.first
		player1?.zPosition = 7
		player1?.setScale(0.5)
		if characters.first == CharacterType.Uhong.rawValue {
			percent = 0.4
		} else if characters.first == CharacterType.Salamang.rawValue {
			percent = 0.2
		}
		x = podiumWinners.position.x
		y = podiumWinners.position.y + podiumWinners.size.height / 2 + (player1?.size.height)! * percent
		player1?.position = CGPoint(x: x, y: y)
		self.addChild(player1!)
		
		percent = 0.5
		
		let player2 = playersImages.last
		player2?.xScale = -(player2?.xScale)!
		player2?.zPosition = 7
		player2?.setScale(0.5)
		if characters.last == CharacterType.Uhong.rawValue {
			percent = 0.3
		} else if characters.last == CharacterType.Salamang.rawValue {
			percent = 0.2
		}
		x = podiumLoser.position.x
		y = podiumLoser.position.y + podiumLoser.size.height / 2 + (player2?.size.height)! * percent
		player2?.position = CGPoint(x: x, y: y)
		self.addChild(player2!)
		
		let firstLabel = SKLabelNode(fontNamed: "SnapHand")
		firstLabel.text = "1"
		firstLabel.fontSize = 24 * (self.size?.width)! / (self.size?.height)!
		x = podiumWinners.position.x
		y = podiumWinners.position.y + podiumWinners.size.height / 2 - firstLabel.frame.height * 1.7
		firstLabel.position = CGPoint(x: x, y: y)
		firstLabel.zPosition = 6
		self.addChild(firstLabel)
		
		let firstScoreLabel = SKLabelNode(fontNamed: "SnapHand")
		firstScoreLabel.text = "score \(scoresDetails.first!.score)"
		firstScoreLabel.fontSize = 10 * (self.size?.width)! / (self.size?.height)!
		x = podiumWinners.position.x
		y = podiumWinners.position.y - podiumWinners.size.height / 2 + firstScoreLabel.frame.height
		firstScoreLabel.position = CGPoint(x: x, y: y)
		firstScoreLabel.zPosition = 6
		self.addChild(firstScoreLabel)
		
		let secondLabel = SKLabelNode(fontNamed: "SnapHand")
		secondLabel.text = "2"
		secondLabel.fontSize = 20 * (self.size?.width)! / (self.size?.height)!
		x = podiumLoser.position.x
		y = podiumLoser.position.y + podiumLoser.size.height / 2 - secondLabel.frame.height * 2.5
		secondLabel.position = CGPoint(x: x, y: y)
		secondLabel.zPosition = 6
		self.addChild(secondLabel)
		
		let secondScoreLabel = SKLabelNode(fontNamed: "SnapHand")
		secondScoreLabel.text = "score \(scoresDetails.last!.score)"
		secondScoreLabel.fontSize = 10 * (self.size?.width)! / (self.size?.height)!
		x = podiumLoser.position.x
		y = podiumLoser.position.y - podiumLoser.size.height / 2 + secondScoreLabel.frame.height * 0.1
		secondScoreLabel.position = CGPoint(x: x, y: y)
		secondScoreLabel.zPosition = 6
		self.addChild(secondScoreLabel)
		
	}
	
	class ScoreDetails: NSObject {
		let character: Int
		let score: Int
		let name: String
		
		init(character: Int, score: Int, name: String) {
			self.character = character
			self.score = score
			self.name = name
			super.init()
		}
		
		static func generateDetails(characters: [Int], scores: [Int], aliases: [String]) -> [ScoreDetails]{
			var details = [ScoreDetails]()
			
			for index in 0...scores.count - 1 {
				let detail = ScoreDetails(character: characters[index], score: scores[index], name: aliases[index])
				
				details.append(detail)
			}
			
			let multableArray = NSMutableArray(array: details)
			let sortByIndex = NSSortDescriptor(key: "score", ascending: false)
			let sortDescriptiors = [sortByIndex]
			multableArray.sortUsingDescriptors(sortDescriptiors)
			details = NSArray(array: multableArray) as! [ScoreDetails]
			
			return details
		}
	}
	
	func generateImagesTwoPlayer(details: [ScoreDetails]) -> [SKSpriteNode]{
		var players = [SKSpriteNode]()
		for index in 0...details.count - 1 {
			if index == 0 {
				if details[index].character == CharacterType.Uhong.rawValue {
					let player = SKSpriteNode(imageNamed: "CogumeloSubindo1.png")
					players.append(player)
				} else if details[index].character == CharacterType.Salamang.rawValue {
					let player = SKSpriteNode(imageNamed: "SalamangCaindo1.png")
					players.append(player)
				}
			} else {
				if details[index].character == CharacterType.Uhong.rawValue {
					let player = SKSpriteNode(imageNamed: "CogumeloParado1.png")
					players.append(player)
				} else if details[index].character == CharacterType.Salamang.rawValue {
					let player = SKSpriteNode(imageNamed: "SalamangParado4.png")
					players.append(player)
				}
			}
		}
		
		return players
	}
	
	
}
