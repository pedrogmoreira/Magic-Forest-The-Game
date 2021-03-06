//
//  NetworkingStructs.swift
//  Magic Forest The Battle
//
//  Created by Pedro Henrique Goncalves Moreira on 17/11/15.
//  Copyright © 2015 Team Magic Forest. All rights reserved.
//

import SpriteKit

// Define the types of menssages
// Each structure represents a type of message the game will send to the other device
enum MessageType: Int {
	case RandomNumber, GameBegin, GameOver, Move, Flip, Attack, GetDown, Special, Players, StartGameProperties, ChosenCharacter, LoseLife, MyScore, Scores, Hit
}

enum CharacterType: Int {
	case Uhong, Dinak, Salamang, Neith
}

struct Message {
	let messageType: MessageType
}

struct MessageMove {
    let message = MessageType.Move
	let dx: Float
	let dy: Float
    let justRebirth: Bool
}

struct MessageHit {
    let message = MessageType.Hit
    let attackedPlayerIndex: Int
}

struct MessageFlip {
    let message = MessageType.Flip
    let x: Float
}

struct MessageRandomNumber {
	let message: Message
	let randomNumber: UInt32
}

struct MessageGameBegin {
	let message: Message
}

struct MessageLoseLife {
	let message = MessageType.LoseLife
	let currentLife: Float
	let playerIndex: Int
}

struct MessageSpecialAttack {
    let message = MessageType.Special
}

struct MessageGameOver {
	let message: Message
}

struct MessageGetDown {
    let message = MessageType.GetDown
}

struct MessageStartGameProperties {
	let message = MessageType.StartGameProperties
	let spawnPointsIndexes: NSData?
	let chosenCharacters: NSData?
	
	struct ArchivedPacket {
		let message = MessageType.StartGameProperties
		var spawnPointsIndexesLength: Int64
		var chosenCharactersLength: Int64
	}
	
	func archive() -> NSData {
		var archivedPacket = ArchivedPacket(spawnPointsIndexesLength: Int64(self.spawnPointsIndexes!.length), chosenCharactersLength: Int64(self.chosenCharacters!.length))
		
		let metadata = NSData(bytes: &archivedPacket, length: sizeof(ArchivedPacket))
		let archivedData = NSMutableData(data: metadata)
		archivedData.appendData(self.spawnPointsIndexes!)
		archivedData.appendData(self.chosenCharacters!)
		return archivedData
	}
	
	static func unarchive(data: NSData!) -> MessageStartGameProperties {
		var archivedPacket = ArchivedPacket(spawnPointsIndexesLength: 0, chosenCharactersLength: 0)
		let archivedStructLength = sizeof(ArchivedPacket)
		
		let archivedData = data.subdataWithRange(NSMakeRange(0, archivedStructLength))
		archivedData.getBytes(&archivedPacket, length: archivedStructLength)
		
		let spawnPointsIndexesRange = NSMakeRange(archivedStructLength, Int(archivedPacket.spawnPointsIndexesLength))
		let spawnPointsIndexesData = data.subdataWithRange(spawnPointsIndexesRange)
		
		let chosenCharactersRange = NSMakeRange(archivedStructLength + Int(archivedPacket.spawnPointsIndexesLength), Int(archivedPacket.chosenCharactersLength))
		let chosenCharactersData = data.subdataWithRange(chosenCharactersRange)
		
		let startGameProperties = MessageStartGameProperties(spawnPointsIndexes: spawnPointsIndexesData, chosenCharacters: chosenCharactersData)
		
		return startGameProperties
	}
}

struct MessageCharacterChosen {
	let message: Message
	let character: CharacterType
}

struct MessageAttack {
	let message: Message
}

struct MessagePlayers {
	let message: Message
	var players: [Player]
}

struct MessageMyScore {
	let message = MessageType.MyScore
	let score: Int
}

struct MessageScores {
	let message = MessageType.Scores
	let scores: NSData?
	
	struct ArchivedPacket {
		let message = MessageType.Scores
		var scoresLength: Int64
	}
	
	func archive() -> NSData {
		var archivedPacket = ArchivedPacket(scoresLength: Int64(self.scores!.length))
		
		let metadata = NSData(bytes: &archivedPacket, length: sizeof(ArchivedPacket))
		let archivedData = NSMutableData(data: metadata)
		archivedData.appendData(self.scores!)
		return archivedData
	}
	
	static func unarchive(data: NSData!) -> MessageScores {
		var archivedPacket = ArchivedPacket(scoresLength: 0)
		let archivedStructLength = sizeof(ArchivedPacket)
		
		let archivedData = data.subdataWithRange(NSMakeRange(0, archivedStructLength))
		archivedData.getBytes(&archivedPacket, length: archivedStructLength)
		
		let scoresRange = NSMakeRange(archivedStructLength, Int(archivedPacket.scoresLength))
		let scoresData = data.subdataWithRange(scoresRange)
		
		let scores = MessageScores(scores: scoresData)
		
		return scores
	}
}