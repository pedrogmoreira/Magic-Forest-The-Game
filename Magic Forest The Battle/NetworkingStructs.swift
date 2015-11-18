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
	case RandomNumber, GameBegin, GameOver, Move, String, Attack, Jump, Players, StartGameProperties
}

struct Message {
	let messageType: MessageType
}


struct MessageMove {
    let message = MessageType.Move
	let dx: Float
	let dy: Float
}
struct MessageRandomNumber {
	let message: Message
	let randomNumber: UInt32
}

struct MessageGameBegin {
	let message: Message
}

struct MessageGameOver {
	let message: Message
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
	
	struct ArchivedPacket {
		let message = MessageType.StartGameProperties
		var spawnPointsIndexesLength: Int64
	}
	
	func archive() -> NSData {
		var archivedPacket = ArchivedPacket(spawnPointsIndexesLength: Int64(self.spawnPointsIndexes!.length))
		
		let metadata = NSData(bytes: &archivedPacket, length: sizeof(ArchivedPacket))
		let archivedData = NSMutableData(data: metadata)
		archivedData.appendData(spawnPointsIndexes!)
		return archivedData
	}
	
	static func unarchive(data: NSData!) -> MessageStartGameProperties {
		var archivedPacket = ArchivedPacket(spawnPointsIndexesLength: 0)
		let archivedStructLength = sizeof(ArchivedPacket)
		
		let archivedData = data.subdataWithRange(NSMakeRange(0, archivedStructLength))
		archivedData.getBytes(&archivedPacket, length: archivedStructLength)
		
		let spawnPointsIndexesRange = NSMakeRange(archivedStructLength, Int(archivedPacket.spawnPointsIndexesLength))
		let spawnPointsIndexesData = data.subdataWithRange(spawnPointsIndexesRange)
		
		
		let startGameProperties = MessageStartGameProperties(spawnPointsIndexes: spawnPointsIndexesData)
		
		return startGameProperties
	}
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
