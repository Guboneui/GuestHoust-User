//
//  ChatUseCaseInterface.swift
//  ChattingDomain
//
//  Created by 김동겸 on 3/1/24.
//

import Foundation

import ChattingEntity

import RxRelay
import RxSwift

public protocol ChatUseCaseInterface {
	var receivedChatMessageRelay: PublishRelay<ReceiveMessageData> { get set }
	
	func fetchTestToken(email: String, password: String) -> Single<TestTokenResponse>
	func saveTokenToKeyChain(token: String)
	
	func fetchChannelList() -> Single<ChannelListResponse>
	func fetchChannelMemberList(channelID: String) -> Single<ChannelMemberListResponse>
	func fetchChannelMessageHistory(
		channelID: String,
		before: String?,
		limit: String?
	) -> Single<MessageHistoryResponse>
	
	func enterChattingRoom()
	func disconnectSoket()
	func sendChatMessage(d: SendMessageData)
}
