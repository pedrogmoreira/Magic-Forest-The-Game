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
	case RandomNumber, GameBegin, GameOver, Move, Flip, Attack,Jump, GetDown, Special, Players, StartGameProperties, ChosenCharacter, LoseLife, Death
}

enum CharacterType: Int {
	case Uhong, Dinak, Salamang, Neith, Default
}

struct Message {
	let messageType: MessageType
}

struct MessageMove {
    let message = MessageType.Move
	let dx: Float
	let dy: Float
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
struct MessageDeath {
	let message = MessageType.Death
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

struct MessageString {
	let message = MessageType.String
	let text: String
	
	struct ArchivedPacket {
		let message = MessageType.String
		var textLength: Int64
	}
	
	func archive() -> NSData {
		var archivedPacket = ArchivedPacket(textLength: Int64(self.text.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)))
		
		let metadata = NSData(bytes: &archivedPacket, length: sizeof(ArchivedPacket))
		let archivedData = NSMutableData(data: metadata)
		archivedData.appendData(text.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)!)
		return archivedData
	}
	
	static func unarchive(data: NSData!) -> MessageString {
		var archivedPacket = ArchivedPacket(textLength: 0)
		let archivedStructLength = sizeof(ArchivedPacket)
		
		let archivedData = data.subdataWithRange(NSMakeRange(0, archivedStructLength))
		archivedData.getBytes(&archivedPacket, length: archivedStructLength)
		
		let textRange = NSMakeRange(archivedStructLength, Int(archivedPacket.textLength))
		let textData = data.subdataWithRange(textRange)
		
		let text = String(data: textData, encoding: NSUTF8StringEncoding)
		
		let messageString = MessageString(text: text!)
		
		return messageString
	}
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

struct MessageJump {
    let message = MessageType.Jump
}
