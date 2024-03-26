//
//  ChatRoomViewController.swift
//  ChattingDemoApp
//
//  Created by 구본의 on 2023/12/28.
//

import UIKit

import ChattingData
import ChattingDomain

import RxSwift

public final class ChatRoomViewController: UIViewController {
	// MARK: - UI Property
	private let rootView: ChatRoomView = ChatRoomView()
	
	// MARK: - Property
	private let chatRoomViewModel: ChatRoomViewModelInterface
	private let disposeBag: DisposeBag = DisposeBag()
	
	// MARK: - INITIALIZE
	public init(chatRoomViewModel: ChatRoomViewModelInterface) {
		self.chatRoomViewModel = chatRoomViewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - LifeCycle
	public override func loadView() {
		view = rootView
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		setupBinds()
		setupGestures()
		
		chatRoomViewModel.enteredChattingRoom()
	}
}

// MARK: - PRIVATE METHOD
private extension ChatRoomViewController {
	func setupBinds() {
		chatRoomViewModel.isMenuOpen
			.subscribe(onNext: { [weak self] isMenuOpen in
				guard let self else { return }
				
				self.rootView.addPhotoMenuButtonAnimation(with: isMenuOpen)
			}).disposed(by: disposeBag)
		
		rootView.rx.inputMessageTextViewCurrentText
			.map { $0 ?? "" }
			.subscribe(onNext: { [weak self] chattingText in
				guard let self else { return }
				
				self.chatRoomViewModel.chattingCurrentText.accept(chattingText)
				self.rootView.sendMessageButtonAnimation(with: chattingText.isEmpty)
			}).disposed(by: disposeBag)
		
		rootView.rx.didChangeInputMessageTextView
			.subscribe(onNext: { [weak self] in
				guard let self else { return }
				
				self.rootView.setSizingInputMessageTextView()
			}).disposed(by: disposeBag)
		
		chatRoomViewModel.displayableMessagesRelay
			.bind(to: rootView.chatListCollectionView.rx.items) { _, row, element in
				let indexPath = IndexPath(row: row, section: 0)
				let uid = element.uid
				
				switch uid {
				case "22962131007717376":
					guard let cell = self.rootView.chatListCollectionView.dequeueReusableCell(
						withReuseIdentifier: ChatByOwnerCell.identifier, for: indexPath
					) as? ChatByOwnerCell else { return ChatByOwnerCell() }
					
					cell.messageLabel.text = element.data
					cell.timeLabel.text = element.convertTime
					cell.timeLabel.isHidden = element.isHiddenTime
					
					return cell
					
				default:
					if element.isContinuousUid {
						guard	let cell = self.rootView.chatListCollectionView.dequeueReusableCell(
							withReuseIdentifier: ChatByFriendCell.identifier, for: indexPath
						) as? ChatByFriendCell else { return ChatByFriendCell() }
						
						cell.messageLabel.text = element.data
						cell.timeLabel.text = element.convertTime
						cell.timeLabel.isHidden = element.isHiddenTime

						return cell
					}
					
					guard let cell = self.rootView.chatListCollectionView.dequeueReusableCell(
						withReuseIdentifier: ChatByFriendWithProfileImageCell.identifier, for: indexPath
					) as? ChatByFriendWithProfileImageCell else { return ChatByFriendWithProfileImageCell() }
					
					cell.userNameLabel.text = self.chatRoomViewModel.membersDictionary[element.uid]
					cell.messageLabel.text = element.data
					cell.timeLabel.text = element.convertTime
					cell.timeLabel.isHidden = element.isHiddenTime
					
					return cell
				}
			}.disposed(by: disposeBag)
	}
	
	func setupGestures() {
		chatRoomViewModel.channelInfoDTORelay
			.subscribe(onNext: { [weak self] infoData in
				guard let self else { return }
				
				self.rootView.navigationBarView.titleLabel.text = infoData.name
				self.rootView.navigationBarView.memberCountLabel.text = "\(infoData.member_count)"
			}).disposed(by: disposeBag)
		
		rootView.navigationBarView.rx.didTapBackButton
			.bind(onNext: { [weak self] in
				guard let self else { return }
				
				self.dismiss(animated: false)
			}).disposed(by: disposeBag)
		
		rootView.navigationBarView.rx.didTapSideBarButton
			.bind(onNext: { [weak self] in
				guard let self else { return }
				self.view.endEditing(true)

				let trepository: TestTokenRespositoryInterface = TestTokenRespository()
				let repository: ChatRepositoryInterface = ChatRepository()
				let useCase: ChatUseCaseInterface = ChatUseCase(
					chatRepository: repository,
					testTokenRespository: trepository
				)
				let viewiewModel: ChatRoomSidebarViewModelInterface = ChatRoomSidebarViewModel(
					useCase: useCase,
					channelInfoDTO: self.chatRoomViewModel.channelInfoDTO
				)
				
				let viewController = ChatRoomSidebarViewController(
					ChattingRoomSidebarViewModel: viewiewModel
				)
				viewController.parentVC = self
				viewController.showSideBar()
			}).disposed(by: disposeBag)
		
		rootView.rx.didTapAddPhotoMenuButton
			.bind(onNext: { [weak self] in
				guard let self else { return }
				
				self.chatRoomViewModel.isMenuOpen
					.accept(!self.chatRoomViewModel.isMenuOpen.value)
			}).disposed(by: disposeBag)
		
		rootView.rx.didTapCameraButton
			.bind(onNext: { [weak self] in
				guard let self else { return }
				
				print("카메라 버튼 클릭")
			}).disposed(by: disposeBag)
		
		rootView.rx.didTapGalleryButton //임시 채팅방 연결종료 버튼
			.bind(onNext: { [weak self] in
				guard let self else { return }
				
				print("갤러리 버튼 클릭")
				self.chatRoomViewModel.leavedChattingRoom()
			}).disposed(by: disposeBag)
		
		rootView.rx.didTapSendMessageButton
			.bind(onNext: { [weak self] in
				guard let self else { return }
				
				self.chatRoomViewModel.sentMessage()
				self.rootView.sendMessageButtonAnimation(with: true)
				self.rootView.setOriginalSizingInputMessageTextView()
			}).disposed(by: disposeBag)
		
		rootView.rx.didTapChatListCollectionView
			.bind(onNext: { [weak self] _ in
				guard let self else { return }
				
				self.view.endEditing(true)
			}).disposed(by: disposeBag)
	}
}
