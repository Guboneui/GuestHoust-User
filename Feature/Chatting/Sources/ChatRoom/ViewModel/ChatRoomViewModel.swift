//
//  ChatRoomViewModel.swift
//  Chatting
//
//  Created by 김동겸 on 1/16/24.
//

import Foundation

import ChattingDomain
import ChattingEntity

import RxRelay
import RxSwift

public struct DisplayableMessageModel {
	public let data: String
	public let time: String
	public let convertTime: String
	public let uid: String
	
	public var isContinuousUid: Bool
	public var isHiddenTime: Bool
	
	init(
		data: String,
		time: String,
		convertTime: String,
		uid: String,
		isHiddenTime: Bool,
		isContinuousUid: Bool
	) {
		self.data = data
		self.time = time
		self.convertTime = convertTime
		self.uid = uid
		self.isHiddenTime = isHiddenTime
		self.isContinuousUid = isContinuousUid
	}
}

// MARK: - VIEWMODEL INTERFACE
public protocol ChatRoomViewModelInterface {
	var isMenuOpen: BehaviorRelay<Bool> { get }
	var chattingCurrentText: BehaviorRelay<String> { get }
	var displayableMessagesRelay: BehaviorRelay<[DisplayableMessageModel]> { get }
	var channelInfoDTO: ChannelInfoDTO { get set }
	var channelInfoDTORelay: BehaviorRelay<ChannelInfoDTO> { get }
	var membersDictionary: [String: String] { get }
	
	func enteredChattingRoom()
	func leavedChattingRoom()
	func sentMessage()
}

public final class ChatRoomViewModel: ChatRoomViewModelInterface {
	// MARK: - PUBLIC PROPERTY
	public var isMenuOpen: BehaviorRelay<Bool> = .init(value: true)
	public var chattingCurrentText: BehaviorRelay<String> = .init(value: "")
	public var displayableMessagesRelay: BehaviorRelay<[DisplayableMessageModel]>
	public var channelInfoDTO: ChannelInfoDTO
	public var channelInfoDTORelay: BehaviorRelay<ChannelInfoDTO>
	public var membersDictionary: [String: String] = [:]
	
	// MARK: - PRIVATE PROPERTY
	private let chatUseCase: ChatUseCaseInterface
	private let disposeBag: DisposeBag
	private var displayableMessageArray: [DisplayableMessageModel] = []
	
	// MARK: - INITIALIZE
	public init(useCase: ChatUseCaseInterface, channelInfoDTO: ChannelInfoDTO) {
		self.chatUseCase = useCase
		self.channelInfoDTO = channelInfoDTO
		self.disposeBag = .init()
		self.channelInfoDTORelay = .init(value: channelInfoDTO)
		self.displayableMessagesRelay = .init(value: displayableMessageArray)
	}
	
	// MARK: - PUBLIC METHOD
	public func leavedChattingRoom() {
		chatUseCase.disconnectSoket()
	}
	
	public func sentMessage() {
		let cid = channelInfoDTO.id
		let sentMessageData: SendMessageData = SendMessageData(
			cid: cid,
			data: chattingCurrentText.value
		)
		
		chatUseCase.sendChatMessage(d: sentMessageData)
	}
	
	public func enteredChattingRoom() {
		chatUseCase.enterChattingRoom()
		messageBinding()
		channelMembersList()
		fetchChannelMessageHistory(before_mid: nil, limit_cnt: "20")
	}
}

// MARK: - PRIVATE METHOD
private extension ChatRoomViewModel {
	func messageBinding() {
		chatUseCase.receivedChatMessageRelay
			.filter { $0.cid == self.channelInfoDTO.id } //채널 아이디 체크
			.subscribe(onNext: { [weak self] messageData in
				guard let self else { return }
				
				let mappeddata = self.mappingToDisplayableMessageModel(with: messageData)
				self.displayableMessageArray.append(mappeddata)
				
				if mappeddata.time < self.displayableMessageArray.last?.time ?? "" {
					self.displayableMessageArray.sort(by: { $0.time < $1.time })
				}
				
				self.displayableMessageArray = self.searchForMatchingPreviousEntry(
					with: self.displayableMessageArray
				)
				self.displayableMessagesRelay.accept(self.displayableMessageArray)
			}).disposed(by: disposeBag)
	}
	
	func channelMembersList() {
		chatUseCase.fetchChannelMemberList(channelID: channelInfoDTO.id)
			.subscribe(onSuccess: { [weak self] responseData in
				guard let self else { return }
				
				membersDictionary =	self.makeMembersDictionary(with: responseData.members)
				self.channelInfoDTO.members = mappingArrayToMembersInfoDTO(
					with: responseData.members
				)
				self.channelInfoDTORelay.accept(channelInfoDTO)
			}).disposed(by: disposeBag)
	}
	
	func fetchChannelMessageHistory(before_mid: String?, limit_cnt: String?) {
		chatUseCase.fetchChannelMessageHistory(
			channelID: channelInfoDTO.id,
			before: before_mid,
			limit: limit_cnt)
		.subscribe(onSuccess: { [weak self] responseData in
			guard let self else { return }
			
			self.displayableMessageArray = makeDisplayableMessageModels(
				with: responseData.messages
			)
			
			self.displayableMessagesRelay.accept(self.displayableMessageArray)
		}).disposed(by: disposeBag)
	}
	
	func makeMembersDictionary(with baseArray: [ChannelMemberInfo]) -> [String: String] {
		var tempDic: [String: String] = [:]
		
		baseArray.forEach({
			tempDic[$0.id] = $0.name
		})
		
		return tempDic
	}
	
	func makeDisplayableMessageModels(
		with baseArray: [ReceiveMessageData]
	) -> [DisplayableMessageModel] {
		var mappedArray: [DisplayableMessageModel] = []
		
		baseArray.forEach({
			let mappedData = mappingToDisplayableMessageModel(with: $0)
			mappedArray.append(mappedData)
		})
		
		mappedArray.sort(by: { $0.time < $1.time })
		mappedArray = searchForMatchingPreviousEntry(with: mappedArray)
		return mappedArray
	}
	
	func mappingToDisplayableMessageModel(
		with data: ReceiveMessageData
	) -> DisplayableMessageModel {
		let mappedData: DisplayableMessageModel = .init(
			data: data.data ?? "",
			time: data.time ?? "",
			convertTime: stringConvertToDateTime(utcTime: data.time ?? ""),
			uid: data.uid ?? "",
			isHiddenTime: false,
			isContinuousUid: false
		)
		
		return mappedData
	}
	
	func mappingArrayToMembersInfoDTO(
		with baseArray: [ChannelMemberInfo]
	) -> [MemberInfoDTO] {
		var mappedArray: [MemberInfoDTO] = []
		
		baseArray.forEach({
			let temp: MemberInfoDTO = .init(
				id: $0.id,
				role: $0.role,
				name: $0.name,
				avatar_url: $0.avatar_url
			)
			mappedArray.append(temp)
		})
		
		return mappedArray
	}
	
	func searchForMatchingPreviousEntry(
		with baseArray: [DisplayableMessageModel]
	) -> [DisplayableMessageModel] {
		var tempArray: [DisplayableMessageModel] = baseArray
		
		baseArray.enumerated().forEach({
			if $0.offset != 0 {
				if $0.element.uid == baseArray[$0.offset - 1].uid {
					tempArray[$0.offset].isContinuousUid = true
					if $0.element.convertTime == baseArray[$0.offset - 1].convertTime {
						tempArray[$0.offset - 1].isHiddenTime = true
					} else {
						tempArray[$0.offset].isContinuousUid = false
					}
				}
			}
		})
		
		return tempArray
	}
	
	func stringConvertToDateTime(utcTime: String) -> String {
		let stringFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
		let formatter = DateFormatter()
		formatter.dateFormat = stringFormat
		formatter.locale = Locale(identifier: "ko")
		guard let tempDate = formatter.date(from: utcTime) else {
			return ""
		}
		formatter.dateFormat = "HH:mm"
		
		return formatter.string(from: tempDate)
	}
}
