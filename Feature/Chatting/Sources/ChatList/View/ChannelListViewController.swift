//
//  ChannelListViewController.swift
//  Chatting
//
//  Created by 김동겸 on 3/11/24.
//

import UIKit

import ChattingData
import ChattingDomain
import ChattingEntity

import RxSwift

public final class ChannelListViewController: UIViewController {
	// MARK: - UI Property
	private let rootView: ChannelListView = ChannelListView()
	
	// MARK: - Property
	private let channelListViewModel: ChannelListViewModelInterface
	private let disposeBag: DisposeBag = DisposeBag()
	
	// MARK: - INITIALIZE
	public init(channelListViewModel: ChannelListViewModelInterface) {
		self.channelListViewModel = channelListViewModel
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
		
		channelListViewModel.fetchTestToken()
		channelListViewModel.fetchChannlList()
	}
}

// MARK: - PRIVATE METHOD
private extension ChannelListViewController {
	func setupBinds() {
		channelListViewModel.displayableChatListArray
			.bind(to: rootView.channelListCollectionView.rx.items) { _, row, element in
				let indexPath = IndexPath(row: row, section: 0)
				
				guard let cell = self.rootView.channelListCollectionView.dequeueReusableCell(
					withReuseIdentifier: ChannelListCell.identifier, for: indexPath
				) as? ChannelListCell else { return ChannelListCell() }
				
				cell.channelNameLabel.text = element.name
				return cell
			}.disposed(by: disposeBag)
		
		//cell 터치
		Observable.zip(
			rootView.channelListCollectionView.rx.itemSelected,
			rootView.channelListCollectionView.rx.modelSelected(ChannelInfo.self)
		).subscribe(onNext: { indexPath, model in
			
			let repository: ChatRepositoryInterface = ChatRepository()
			let trepository: TestTokenRespositoryInterface = TestTokenRespository()
			let useCase: ChatUseCaseInterface = ChatUseCase(
				chatRepository: repository,
				testTokenRespository: trepository
			)
			
			let channelInfoDTO: ChannelInfoDTO = ChannelInfoDTO(
				id: model.id,
				name: model.name,
				icon_url: model.icon_url,
				member_count: model.member_count
			)
			
			let viewModel: ChatRoomViewModelInterface = ChatRoomViewModel(
				useCase: useCase,
				channelInfoDTO: channelInfoDTO
			)
			
			let chattingViewController: ChatRoomViewController =
			ChatRoomViewController(chatRoomViewModel: viewModel)
			
			chattingViewController.modalPresentationStyle = .overFullScreen
			self.present(chattingViewController, animated: true)
		}).disposed(by: disposeBag)
	}
}
