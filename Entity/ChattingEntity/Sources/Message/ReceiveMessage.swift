//
//  ReceiveMessage.swift
//  ChattingEntity
//
//  Created by 김동겸 on 3/1/24.
//

import Foundation

public enum ReceiveOP: Int {
	case dispatchMessage
	case dispatchImage
	case dispatchFiles
	case updateChannel
	case hello = 10
	case error
}

public struct ReceiveMessage {
	public let op: ReceiveOP
	public let d: ReceiveMessageData
	
	public init(op: ReceiveOP, d: ReceiveMessageData) {
		self.op = op
		self.d = d
	}
}

public struct ReceiveMessageData: Codable {
	// dispatchMessage
	public var cid: String?
	public var mid: String?
	public var ctype: Int?
	public var data: String?
	public var time: String?
	public var uid: String?
	
	// hello
	public var id: String?
	
	// error
	public var code: Int?
	public var message: String?
	
	public init?(op: Int, dic: [String: Any]) {
		switch op {
		case 0:
			let cid = dic["cid"] as? String
			let mid = dic["mid"] as? String
			let ctype = dic["ctype"] as? Int
			let data = dic["data"] as? String
			let time = dic["time"] as? String
			let uid = dic["uid"] as? String
			
			self.cid = cid
			self.mid = mid
			self.ctype = ctype
			self.data = data
			self.time = time
			self.uid = uid
			
		case 10:
			let id = dic["id"] as? String
			
			self.id = id
			
		case 11:
			let code = dic["code"] as? Int
			let message = dic["message"] as? String
			
			self.code = code
			self.message = message
			
		default:
			break
		}
	}
	
	// dispatchMessage init
	public init(
		cid: String, 
		mid: String,
		ctype: Int,
		data: String,
		time: String,
		uid: String
	) {
		self.cid = cid
		self.mid = mid
		self.ctype = ctype
		self.data = data
		self.time = time
		self.uid = uid
	}
	
	// hello init
	public init(id: String) {
		self.id = id
	}
	
	//error init
	public init(code: Int, message: String) {
		self.code = code
		self.message = message
	}
}
