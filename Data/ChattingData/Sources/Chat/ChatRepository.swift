//
//  ChatRepository.swift
//  ChattingData
//
//  Created by 김동겸 on 3/1/24.
//

import Foundation

import ChattingDomain
import ChattingEntity
import ChattingService
import NetworkHelper
import SecureStorageKit

import RxSwift
import SocketIO

public final class ChatRepository: NetworkRepository<ChatAPI>, ChatRepositoryInterface {
	public var receivedSoketDataSubject: PublishSubject = PublishSubject<ReceiveMessage>()

	public func fetchChannelListAPI() -> Single<ChannelListResponse> {
		request(endPoint: .channelList)
	}
	
	public func fetchChannelMemberListAPI(channelID: String) -> Single<ChannelMemberListResponse> {
		request(endPoint: .channelMemberList(channelID: channelID))
	}
	
	public func fetchChannelMessageHistoryAPI(
		channelID: String,
		before: String?,
		limit: String?
	) -> Single<MessageHistoryResponse> {
		request(endPoint: .channelMessageHistory(channelID: channelID, before: before, limit: limit))
	}

	public func connectSoket() {
		ChatSoketIOManager.shared.socket.connect()
	}
	
	public func disconnentSoket() {
		ChatSoketIOManager.shared.socket.disconnect()
	}
	
	public func sendToSoket(message: SendMessage) {
		ChatSoketIOManager.shared.socket.emit("event", message.makeDictionary())
	}
	
	public func receiveFromSoket() {
		ChatSoketIOManager.shared.socket.on("message") { dataArray, _ in
			guard let data = dataArray.first as? [String: Any],
						let op = data["op"] as? Int,
						let d = data["d"] as? [String: Any],
						let receivedMessageData = ReceiveMessageData(op: op, dic: d) else { return }
			
			let receivedMessage = ReceiveMessage(
				op: ReceiveOP(rawValue: op) ?? ReceiveOP.error,
				d: receivedMessageData
			)

			self.receivedSoketDataSubject.onNext(receivedMessage)
		}
	}
	
	public init() {
		super.init(networkProvider: NetworkProvider())
	}
}
