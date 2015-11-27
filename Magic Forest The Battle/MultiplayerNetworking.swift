//
//  MultiplayerNetworking.swift
//  Magic Forest The Battle
//
//  Created by Marcelo Cristiano Araujo Silva on 11/11/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import Foundation
import GameKit

protocol MultiplayerProtocol {
    // All messages we need to receive to in gameScene
    func setCurrentPlayerIndex(index: Int)
    func matchEnded()
	func createPlayer(indexes: [Int], chosenCharacters: [CharacterType.RawValue])
	func receiveChosenCharacter(chosenCharacter: CharacterType, playerIndex: Int)
    func attack(indext: Int)
    func performGetDown(index: Int)
    func performSpecial(index: Int)
	func performLoseLife(index: Int, currentLife: Float)
	func performDeath(index: Int)
    func movePlayer(index: Int, dx: Float, dy: Float)
	func chooseCharacter()
    
//    func performJump(index: Int)

}

protocol StartGameProtocol {
    // Message to start the game
    func startGame()
}

// Define the states of the game
enum GameStates: Int {
    case WaintingForMatch, WaintingForRandomNumber, WaitingForStart, Playing, Done
}

class MultiplayerNetworking: NSObject, GameKitHelperDelegate {
    var delegate: MultiplayerProtocol?
    var startGameDelegate: StartGameProtocol?
    
    /* These variables keep track of the random number for the local device and the
        ones received from the other player(s)
        You’ll use these numbers to sort all of the players in the game and determine playing order */
    var ourRandomNumber: UInt32 = 0
    var gameState: GameStates
    var isPlayer1: Bool
    var receivedAllRandomNumber: Bool
    var orderOfPlayers: [RandomNumberDetails]
	var scenesDelegate: ScenesDelegate?
	var size: CGSize!
	
    override init() {
        ourRandomNumber = arc4random()
        gameState = GameStates.WaintingForMatch
        isPlayer1 = false
        receivedAllRandomNumber = false
        
        orderOfPlayers = [RandomNumberDetails]()
        
        orderOfPlayers.append(RandomNumberDetails(playerId: GKLocalPlayer.localPlayer().playerID!, player: GKLocalPlayer.localPlayer(), randomNumber: ourRandomNumber))
        
        super.init()
    }
	
	// MARK: Match
    
    func matchStarted() {
        print("Match has started successfuly")
        if receivedAllRandomNumber {
            gameState = GameStates.WaitingForStart
        } else {
            gameState = GameStates.WaintingForRandomNumber
        }
        
        sendRandomNumber()
		
		let sceneSelectPlayer = MenuSelectPlayerScene(size: size!)
		self.scenesDelegate?.showMenuSelectPlayerScene(sceneSelectPlayer)
    }
    
    func matchEnded() {
        delegate?.matchEnded()
    }
	
	func tryStartGame() {
		if isPlayer1 && gameState == GameStates.WaitingForStart {
			print("Im player 1 >> STARTING GAME")
			gameState = GameStates.Playing
			sendBeginGame()
			delegate?.setCurrentPlayerIndex(0)
			startGameDelegate?.startGame()
			//			sendStartGameProperties()
		}
	}
	
	// MARK: Data Sending and Receiving
	
    // Try to send Reliable data to all players
    func sendData(data: NSData) {
        let gameKitHelper = GameKitHelper.sharedInstance
        
        if let multiplayerMatch = gameKitHelper.multiplayerMatch {
            do {
                // .Rekuabke means that the data you send is guaranteed to arrive at its destination
                try multiplayerMatch.sendDataToAllPlayers(data, withDataMode: .Reliable)
            } catch let error as NSError {
                print("Error:\(error.localizedDescription)")
                matchEnded()
            }
        }
    }
    
    func sendUnreliableData(data: NSData) {
        let gameKitHelper = GameKitHelper.sharedInstance
        
        if let multiplayerMatch = gameKitHelper.multiplayerMatch {
            do {
                // .Rekuabke means that the data you send is guaranteed to arrive at its destination
                try multiplayerMatch.sendDataToAllPlayers(data, withDataMode: .Unreliable)
            } catch let error as NSError {
                print("Error:\(error.localizedDescription)")
                matchEnded()
            }
        }
    }

    // Process the received data from player
    func matchReceivedData(match: GKMatch, data: NSData, fromPlayer player: GKPlayer) {
        let message = UnsafePointer<Message>(data.bytes).memory
        
        if message.messageType == MessageType.RandomNumber {
            let messageRandomNumber = UnsafePointer<MessageRandomNumber>(data.bytes).memory
            
            print("Received random number:\(messageRandomNumber.randomNumber)")
            
            var tie = false
            if messageRandomNumber.randomNumber == ourRandomNumber {
                print("Tie")
                tie = true
                
                var idx: Int?
                
                for (index, randomNumberDetails) in orderOfPlayers.enumerate() {
                    if randomNumberDetails.randomNumber == ourRandomNumber {
                        idx = index
                        break
                    }
                }
                
                if let validIndex = idx {
                    ourRandomNumber = arc4random()
                    orderOfPlayers.removeAtIndex(validIndex)
                    orderOfPlayers.append(RandomNumberDetails(playerId: GKLocalPlayer.localPlayer().playerID!, player: GKLocalPlayer.localPlayer(), randomNumber: ourRandomNumber))
                }
                
                sendRandomNumber()
            } else {
                processReceivedRandomNumber(RandomNumberDetails(playerId: player.playerID!, player: GKLocalPlayer.localPlayer(), randomNumber: messageRandomNumber.randomNumber))
            }
            
            if receivedAllRandomNumber {
                isPlayer1 = isLocalPlayer1()
				delegate?.chooseCharacter()
            }
            
            if !tie && receivedAllRandomNumber {
                if gameState == GameStates.WaintingForRandomNumber {
                    gameState = GameStates.WaitingForStart
                }
//                tryStartGame()
            }
        } else if message.messageType == MessageType.GameBegin {
			
            if let localPlayerIndex = indexForLocalPlayer() {
                delegate?.setCurrentPlayerIndex(localPlayerIndex)
            }
            
            startGameDelegate?.startGame()
            gameState = GameStates.Playing
        } else if message.messageType == MessageType.Move {
            
            let messageMove = UnsafePointer<MessageMove>(data.bytes).memory
            delegate?.movePlayer(indexForPlayer(player.playerID!)!, dx: messageMove.dx, dy: messageMove.dy)
        } else if message.messageType == MessageType.Attack {
            
            delegate?.attack(indexForPlayer(player.playerID!)!)
		} else if message.messageType == MessageType.StartGameProperties {
            
			let messageStartGameProperties = MessageStartGameProperties.unarchive(data)
			let indexes = NSKeyedUnarchiver.unarchiveObjectWithData(messageStartGameProperties.spawnPointsIndexes!) as! [Int]

			let chosenCharacters = NSKeyedUnarchiver.unarchiveObjectWithData(messageStartGameProperties.chosenCharacters!) as! [CharacterType.RawValue]
			
			delegate?.createPlayer(indexes, chosenCharacters: chosenCharacters)
		} else if message.messageType == MessageType.ChosenCharacter {
			if self.isPlayer1 == true {
				let messageChosenCharacter = UnsafePointer<MessageCharacterChosen>(data.bytes).memory
				
				print("Player << \(player.alias) >> chosed to play with [ \(messageChosenCharacter.character) ]")
				
				delegate?.receiveChosenCharacter(messageChosenCharacter.character, playerIndex: self.indexForPlayer(player.playerID!)!)
			}
        } else if message.messageType == MessageType.GetDown {
            delegate?.performGetDown(indexForPlayer(player.playerID!)!)
        } else if message.messageType == MessageType.Special {
            delegate?.performSpecial(indexForPlayer(player.playerID!)!)
		} else if message.messageType == MessageType.LoseLife {
			let messageLoseLife = UnsafePointer<MessageLoseLife>(data.bytes).memory
			let currentLife = messageLoseLife.currentLife
			let playerIndex = messageLoseLife.playerIndex
			
			delegate?.performLoseLife(playerIndex, currentLife: currentLife)
		}
    }
	
	// MARK: Index For Player
	
    func indexForLocalPlayer() -> Int? {
        return indexForPlayer(GKLocalPlayer.localPlayer().playerID!)
    }
    
    func indexForPlayer(playerId: String) -> Int? {
        var idx: Int?
        
        for (index, playerDetail) in orderOfPlayers.enumerate() {
            let pId = playerDetail.playerId
            
            if pId == playerId {
                idx = index
                break
            }
        }
        return idx!
    }
	
	// MARK: Random Number Handling
	
	// The RandomNumberDetails class keeps track of the playerId and the randomNumber generated by that player’s device.
	class RandomNumberDetails: NSObject {
		let playerId: String
		let player: GKPlayer
		let randomNumber: UInt32
		
		init(playerId: String, player: GKPlayer, randomNumber: UInt32) {
			self.playerId = playerId
			self.player = player
			self.randomNumber = randomNumber
			super.init()
		}
		
		override func isEqual(object: AnyObject?) -> Bool {
			let randomNumberDetails = object as? RandomNumberDetails
			return randomNumberDetails?.playerId == self.playerId
		}
	}
	
    func processReceivedRandomNumber(randomNumberDetails: RandomNumberDetails) {
        let multableArray = NSMutableArray(array: orderOfPlayers)
        multableArray.addObject(randomNumberDetails)
        
        let sortByRandomNumber = NSSortDescriptor(key: "randomNumber", ascending: false)
        let sortDescriptiors = [sortByRandomNumber]
        multableArray.sortUsingDescriptors(sortDescriptiors)
        
        orderOfPlayers = NSArray(array: multableArray) as! [RandomNumberDetails]
        
        if allRandomNumbersAreReceived() {
            receivedAllRandomNumber = true
			
        }
    }
	
	func allRandomNumbersAreReceived() -> Bool {
		var receivedRandomNumbers = Set<UInt32>()
		
		for playerDetail in orderOfPlayers {
			receivedRandomNumbers.insert(playerDetail.randomNumber)
		}
		
		if let multiplayerMatch = GameKitHelper.sharedInstance.multiplayerMatch {
			if receivedRandomNumbers.count == (multiplayerMatch.players.count + 1) {
				return true
			}
		}
		
		return false
	}
	
    func isLocalPlayer1() -> Bool {
        let playerDetail = orderOfPlayers[0]
        if playerDetail.playerId == GKLocalPlayer.localPlayer().playerID {
            print("I'm player 1.. w00t :]")
            return true
        }
        return false
    }
	
	// MARK: Send Message
    
    // Send to all devices a message of type MessageRandomNumber
    func sendRandomNumber() {
        var message = MessageRandomNumber(message: Message(messageType: MessageType.RandomNumber), randomNumber: ourRandomNumber)
        
        let data = NSData(bytes: &message, length: sizeof(MessageRandomNumber))
        sendData(data)
    }
    
    // Send to all devices a message of type MessageGameBegin
    func sendBeginGame() {
        var message = MessageGameBegin(message: Message(messageType: MessageType.GameBegin))
        let data = NSData(bytes: &message, length: sizeof(MessageGameBegin))
        sendData(data)
    }
    
    // Send to all devices a message of type MessageAttack
    func sendAttack() {
        var message = MessageAttack(message: Message(messageType: MessageType.Attack))
        
        let data = NSData(bytes: &message, length: sizeof(MessageAttack))
        sendData(data)
    }
    
    // Send to all devices a message of type MessageMove
    func sendMove(dx: Float, dy: Float) {
        var message = MessageMove(dx: dx, dy: dy)
        
        let data = NSData(bytes: &message, length: sizeof(MessageMove))
        sendUnreliableData(data)
    }
    
    // Send to all devices a message of type MessageGetDown
    func sendGetDown() {
        var message = MessageGetDown()
        
        let data = NSData(bytes: &message, length: sizeof(MessageGetDown))
        sendData(data)
    }

    // Send to all devices a message of type MessageSpecialAttack
    func sendSpecialAttack() {
        var message = MessageSpecialAttack()
        
        let data = NSData(bytes: &message, length: sizeof(MessageSpecialAttack))
        sendData(data)
    }
    
	// Send to all devices a message of type MessageLoseLife
	func sendLoseLife(currentLife: CGFloat, playerIndex: Int) {
		var message = MessageLoseLife(currentLife: Float(currentLife), playerIndex: playerIndex)
		
		let data = NSData(bytes: &message, length: sizeof(MessageLoseLife))
		sendData(data)
	}

	// Send to all devices the necessary variables to set-up the game
	func sendStartGameProperties(indexes: [Int], chosenCharacters: [CharacterType.RawValue]) {
		let indexesData = NSKeyedArchiver.archivedDataWithRootObject(indexes)
		let chosenCharactersData = NSKeyedArchiver.archivedDataWithRootObject(chosenCharacters)
		
		let msg = MessageStartGameProperties(spawnPointsIndexes: indexesData, chosenCharacters: chosenCharactersData)
		let msgData = msg.archive()
		
		sendData(msgData)
	}
	
	// Send to the host my character selection
	func sendChosenCharacter(characterType: CharacterType) {
		print("Sending player")
		if self.isPlayer1 == false {
			
			print("Im not the host, send him a message")
			
			var message = MessageCharacterChosen(message: Message(messageType: MessageType.ChosenCharacter), character: characterType)
			
			let data = NSData(bytes: &message, length: sizeof(MessageCharacterChosen))

			sendData(data)
		} else {
			delegate?.receiveChosenCharacter(characterType, playerIndex: 0)
		}
	}

}
