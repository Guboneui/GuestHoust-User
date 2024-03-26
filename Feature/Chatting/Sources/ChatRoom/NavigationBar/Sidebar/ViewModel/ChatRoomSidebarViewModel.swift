//
//  ChatRoomSidebarViewModel.swift
//  Chatting
//
//  Created by 김동겸 on 3/15/24.
//

import Foundation
 
import ChattingDomain
import ChattingEntity

import RxRelay
import RxSwift

// MARK: - VIEWMODEL INTERFACE
public protocol ChatRoomSidebarViewModelInterface {
	var channelInfoDTO: ChannelInfoDTO { get }
	var channelInfoDTORelay: BehaviorRelay<ChannelInfoDTO> { get }
	var displayableMembers: BehaviorRelay<[MemberInfoDTO]> { get }
}

public final class ChatRoomSidebarViewModel: ChatRoomSidebarViewModelInterface {
	// MARK: - PUBLIC PROPERTY
	public var channelInfoDTO: ChannelInfoDTO
	public var channelInfoDTORelay: BehaviorRelay<ChannelInfoDTO>
	public var displayableMembers: BehaviorRelay<[MemberInfoDTO]>
	
	// MARK: - PRIVATE PROPERTY
	private let chatUseCase: ChatUseCaseInterface
	private let disposeBag: DisposeBag
	
	// MARK: - INITIALIZE
	public init(useCase: ChatUseCaseInterface, channelInfoDTO: ChannelInfoDTO) {
		self.chatUseCase = useCase
		self.channelInfoDTO = channelInfoDTO
		self.channelInfoDTORelay = .init(value: channelInfoDTO)
		self.displayableMembers = .init(value: channelInfoDTO.members ?? [])
		self.disposeBag = .init()
	}
}

// MARK: - PRIVATE METHOD
private extension ChatRoomSidebarViewModel { }
