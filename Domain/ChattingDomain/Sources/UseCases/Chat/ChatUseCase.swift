//
//  ChatUseCase.swift
//  ChattingDomain
//
//  Created by 김동겸 on 3/1/24.
//

import Foundation

import ChattingEntity

import RxRelay
import RxSwift

public final class ChatUseCase: ChatUseCaseInterface {
	public var receivedChatMessageRelay: PublishRelay<ReceiveMessageData>
	
	private let chatRepository: ChatRepositoryInterface
	private let testTokenRespository: TestTokenRespositoryInterface
	private let disposeBag: DisposeBag
	
	public init(
		chatRepository: ChatRepositoryInterface,
		testTokenRespository: TestTokenRespositoryInterface
	) {
		self.chatRepository = chatRepository
		self.testTokenRespository = testTokenRespository
		self.receivedChatMessageRelay = .init()
		self.disposeBag = .init()
	}
	
	public func fetchTestToken(email: String, password: String) -> Single<TestTokenResponse> {
		return testTokenRespository.fetchTestTokenAPI(email: email, password: password)
	}
	
	public func saveTokenToKeyChain(token: String) {
		testTokenRespository.saveTokenToKeyChain(token: token)
	}

	public func fetchChannelList() -> Single<ChannelListResponse> {
		chatRepository.fetchChannelListAPI()
	}
	
	public func fetchChannelMemberList(channelID: String) -> Single<ChannelMemberListResponse> {
		chatRepository.fetchChannelMemberListAPI(channelID: channelID)
	}
	
	public func fetchChannelMessageHistory(
		channelID: String,
		before: String?,
		limit: String?
	) -> Single<MessageHistoryResponse> {
		chatRepository.fetchChannelMessageHistoryAPI(channelID: channelID, before: before, limit: limit)
	}

	public func enterChattingRoom() {
		chatRepository.connectSoket()
		chatRepository.receiveFromSoket()
		
		chatRepository.receivedSoketDataSubject
			.subscribe(onNext: { [weak self] receivedData in
				guard let self else { return }
				
				let d = receivedData.d
				switch receivedData.op {
				case .dispatchMessage:
					let receivedMessageData = ReceiveMessageData(
						cid: d.cid ?? "",
						mid: d.mid ?? "",
						ctype: d.ctype ?? 0,
						data: d.data ?? "",
						time: d.time ?? "",
						uid: d.uid ?? ""
					)
					self.receivedChatMessageRelay.accept(receivedMessageData)
					
				case .hello:
					let receivedMessageData = ReceiveMessageData(
						id: d.id ?? ""
					)
					
				case .error:
					let receivedMessageData = ReceiveMessageData(
						code: d.code ?? 0,
						message: d.message ?? ""
					)
					
				case .updateChannel, .dispatchImage, .dispatchFiles:
					break
				}
			}).disposed(by: disposeBag)
	}
	
	public func disconnectSoket() {
		chatRepository.disconnentSoket()
	}
	
	public func sendChatMessage(d: SendMessageData) {
		let snedMessage = SendMessage(op: .sendMessage, d: d)
		chatRepository.sendToSoket(message: snedMessage)
	}
}
