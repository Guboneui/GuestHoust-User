//
//  ChatSoketIOManager.swift
//  ChattingNetwork
//
//  Created by 김동겸 on 3/1/24.
//

import Foundation

import ChattingEntity
import SecureStorageKit

import SocketIO

public class ChatSoketIOManager: NSObject {
	public static let shared = ChatSoketIOManager()
	public static let token: String = "Bearer " + (KeyChainManager.read(key: .accessToken) ?? "")
	
	public var socket: SocketIOClient!
	
	private var manager = SocketManager(
		socketURL: URL(string: "ws://144.24.95.47:80") ?? URL(fileURLWithPath: ""),
		config: [
			.log(true),
			.compress,
			.extraHeaders(["authorization": token]),
			.forceWebsockets(true)
		]
	)
	
	private override init() {
		super.init()
		self.socket = self.manager.socket(forNamespace: "/v2/channel")

		socket.on(clientEvent: .connect) { _, _ in
			print("연결 됐냐?\(self.socket.status.active)")
		}
		
		socket.on(clientEvent: .disconnect) { _, _ in
			print("연결 끊겼냐?\(self.socket.status.active)")
		}
	}
}
