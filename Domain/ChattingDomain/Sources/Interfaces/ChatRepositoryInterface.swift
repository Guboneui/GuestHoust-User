//
//  ChatRepositoryInterface.swift
//  ChattingDomain
//
//  Created by 김동겸 on 3/1/24.
//

import Foundation

import ChattingEntity

import RxSwift

public protocol ChatRepositoryInterface {
	var receivedSoketDataSubject: PublishSubject<ReceiveMessage> { get set }
	
	func fetchChannelListAPI() -> Single<ChannelListResponse>
	func fetchChannelMemberListAPI(channelID: String) -> Single<ChannelMemberListResponse>
	func fetchChannelMessageHistoryAPI(
		channelID: String,
		before: String?,
		limit: String?
	) -> Single<MessageHistoryResponse>
	
	func connectSoket()
	func disconnentSoket()
	func sendToSoket(message: SendMessage)
	func receiveFromSoket()
}
