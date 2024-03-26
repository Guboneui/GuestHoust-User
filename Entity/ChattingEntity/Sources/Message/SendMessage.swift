//
//  SendMessage.swift
//  ChattingEntity
//
//  Created by 김동겸 on 3/1/24.
//

import Foundation

public enum SendOP: Int {
	case sendMessage
	case hello = 10
}

public struct SendMessage {
	public let op: SendOP
	public let d: SendMessageData
	
	public init(op: SendOP, d: SendMessageData) {
		self.op = op
		self.d = d
	}
	
	public func makeDictionary() -> [String: Any] {
		switch self.op {
		case .sendMessage:
			return [
				"op": op.rawValue,
				"d": [
					"cid": d.cid,
					"data": d.data
				]
			]
			
		case .hello:
			return  [
				"op": op.rawValue,
				"d": [
					"token": d.token
				]
			]
		}
	}
}

public struct SendMessageData {
	// sendMessage
	public var cid: String?
	public var data: String?
	
	// hello
	public var token: String?
	
	// sendMessage init
	public init(cid: String?, data: String?) {
		self.cid = cid
		self.data = data
	}
	
	// hello init
	public init(token: String?) {
		self.token = token
	}
}
