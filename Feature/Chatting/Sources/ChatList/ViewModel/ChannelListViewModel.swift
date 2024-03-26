//
//  ChatListViewModel.swift
//  Chatting
//
//  Created by 김동겸 on 3/11/24.
//

import Foundation

import ChattingDomain
import ChattingEntity
import SecureStorageKit

import RxRelay
import RxSwift

// MARK: - VIEWMODEL INTERFACE
public protocol ChannelListViewModelInterface {
	var displayableChatListArray: BehaviorRelay<[ChannelInfo]> { get }
	
	func fetchTestToken()
	func fetchChannlList()
}

public final class ChannelListViewModel: ChannelListViewModelInterface {
	// MARK: - PUBLIC PROPERTY
	public var displayableChatListArray: BehaviorRelay<[ChannelInfo]> = .init(value: [])
	// MARK: - PRIVATE PROPERTY
	private let chatUseCase: ChatUseCaseInterface
	private let disposeBag: DisposeBag
	
	// MARK: - INITIALIZE
	public init(useCase: ChatUseCaseInterface) {
		self.chatUseCase = useCase
		self.disposeBag = .init()
	}
	
	// MARK: - PUBLIC METHOD
	public func fetchTestToken() {
		chatUseCase.fetchTestToken(
			email: "alice@example.com",
			password: "test"
		)
		.subscribe(onSuccess: { [weak self] responseData in
			guard let self else { return }
			
			self.chatUseCase.saveTokenToKeyChain(token: responseData.accessToken)
		}).disposed(by: disposeBag)
	}
	
	public func fetchChannlList() {
		chatUseCase.fetchChannelList()
			.subscribe(onSuccess: { [weak self] responseData in
				guard let self else { return }

				self.displayableChatListArray.accept(responseData.channels)
			}).disposed(by: disposeBag)
	}
}
