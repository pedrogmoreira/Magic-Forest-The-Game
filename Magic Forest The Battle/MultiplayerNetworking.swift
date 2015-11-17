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
    func setCurrentPlayerIndex(index: Int)
    func matchEnded()
    func attack()
	func createPlayer(indexes: [Int])
	
//    var gameLayer: GameLayer? {get set}
//    var players: [Player] {get set}
}

protocol StartGameProtocol {
    func startGame()
}

// Define the states of the game
enum GameState: Int {
    case WaintingForMatch, WaintingForRandomNumber, WaitingForStart, Playing, Done
}

class MultiplayerNetworking: NSObject, GameKitHelperDelegate {
    var delegate: MultiplayerProtocol?
    var startGameDelegate: StartGameProtocol?
    
    /* These variables keep track of the random number for the local device and the
        ones received from the other player(s)
        You’ll use these numbers to sort all of the players in the game and determine playing order */
    var ourRandomNumber: UInt32 = 0
    var gameState: GameState
    var isPlayer1: Bool
    var receivedAllRandomNumber: Bool
    var orderOfPlayers: [RandomNumberDetails]
    
    
    override init() {
        ourRandomNumber = arc4random()
        gameState = GameState.WaintingForMatch
        isPlayer1 = false
        receivedAllRandomNumber = false
        
        orderOfPlayers = [RandomNumberDetails]()
        
        orderOfPlayers.append(RandomNumberDetails(playerId: GKLocalPlayer.localPlayer().playerID!, randomNumber: ourRandomNumber))
        
        super.init()
    }
    
    
    // The RandomNumberDetails class keeps track of the playerId and the randomNumber generated by that player’s device.
    class RandomNumberDetails: NSObject {
        let playerId: String
        let randomNumber: UInt32
        
        init(playerId: String, randomNumber: UInt32) {
            self.playerId = playerId
            self.randomNumber = randomNumber
            super.init()
        }
        
        override func isEqual(object: AnyObject?) -> Bool {
            let randomNumberDetails = object as? RandomNumberDetails
            return randomNumberDetails?.playerId == self.playerId
        }
    }
    
    func matchStarted() {
        print("Match has started successfuly")
        if receivedAllRandomNumber {
            gameState = GameState.WaitingForStart
        } else {
            gameState = GameState.WaintingForRandomNumber
        }
        
        sendRandomNumber()
        tryStartGame()
    }
    
    func matchEnded() {
        delegate?.matchEnded()
    }
    
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
                    orderOfPlayers.append(RandomNumberDetails(playerId: GKLocalPlayer.localPlayer().playerID!, randomNumber: ourRandomNumber))
                }
                
                sendRandomNumber()
            } else {
                processReceivedRandomNumber(RandomNumberDetails(playerId: player.playerID!, randomNumber: messageRandomNumber.randomNumber))
            }
            
            if receivedAllRandomNumber {
                isPlayer1 = isLocalPlayer1()
            }
            
            if !tie && receivedAllRandomNumber {
                if gameState == GameState.WaintingForRandomNumber {
                    gameState = GameState.WaitingForStart
                }
                tryStartGame()
            }
        } else if message.messageType == MessageType.GameBegin {
			
            if let localPlayerIndex = indexForLocalPlayer() {
                delegate?.setCurrentPlayerIndex(localPlayerIndex)
            }
            
            startGameDelegate?.startGame()
            gameState = GameState.Playing
        } else if message.messageType == MessageType.Move {
            let messageMove = UnsafePointer<MessageMove>(data.bytes).memory
            
            print("Dx: \(messageMove.dx) Dy: \(messageMove.dy)")
        } else if message.messageType == MessageType.String {
            let messageString = MessageString.unarchive(data)
            
            print(messageString.text)
        } else if message.messageType == MessageType.Attack && isPlayer1 {
            delegate?.attack()
		} else if message.messageType == MessageType.StartGameProperties {
			let messageStartGameProperties = MessageStartGameProperties.unarchive(data)
			let indexes = NSKeyedUnarchiver.unarchiveObjectWithData(messageStartGameProperties.spawnPointsIndexes!) as! [Int]
			delegate?.createPlayer(indexes)
			print(indexes)
		}
//        } else if message.messageType == MessageType.Players {
//            let messagePlayers = UnsafePointer<MessagePlayers>(data.bytes).memory
//            
//            delegate?.gameLayer?.player = messagePlayers.players.first!
//        }
    }
    
    func tryStartGame() {
        if isPlayer1 && gameState == GameState.WaitingForStart {
            gameState = GameState.Playing
            sendBeginGame()
            delegate?.setCurrentPlayerIndex(0)
            startGameDelegate?.startGame()
//			sendStartGameProperties()
        }
    }
    
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
    
    func isLocalPlayer1() -> Bool {
        let playerDetail = orderOfPlayers[0]
        if playerDetail.playerId == GKLocalPlayer.localPlayer().playerID {
            print("I'm player 1.. w00t :]")
            return true
        }
        return false
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

    // Send to all devices a message of type MessageString
    func sendString() {
        let message = MessageString(text: "Oi cueio")
        let messageStringData = message.archive()
        
        sendData(messageStringData)
    }
    
    // Send to all devices a message of type MessageAttack
    func sendAttack() {
        var message = MessageAttack(message: Message(messageType: MessageType.Attack))
        
        let data = NSData(bytes: &message, length: sizeof(MessageAttack))
        sendData(data)
    }
	
	func sendStartGameProperties(indexes: [Int]) {
		let indexesData = NSKeyedArchiver.archivedDataWithRootObject(indexes)
		
		let msg = MessageStartGameProperties(spawnPointsIndexes: indexesData)
		let msgData = msg.archive()
		print("sending")
		sendData(msgData)
	}
    
//    func createPlayers() {
//        if isPlayer1 {
//            self.delegate?.createPlayer()
//            
//            delegate?.gameLayer?.player = delegate?.players.first
//            
//            self.sendPlayers()
//        }
//    }
//    
//    func sendPlayers() {
//        var message = MessagePlayers(message: Message(messageType: MessageType.Players), players: delegate!.players)
//        
//        let data = NSData(bytes: &message, length: sizeof(MessagePlayers))
//        sendData(data)
//    }
}
