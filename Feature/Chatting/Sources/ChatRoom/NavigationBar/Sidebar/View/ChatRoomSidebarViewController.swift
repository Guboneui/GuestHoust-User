//
//  ChatRoomSidebarViewController.swift
//  Chatting
//
//  Created by 김동겸 on 3/14/24.
//

import UIKit

import DesignSystem

import RxSwift

public final class ChatRoomSidebarViewController: UIViewController, SideBarPresentable {
	// MARK: - METRIC
	public enum Metric {
		static let sideBarViewWidth: CGFloat = 320.0
	}
	// MARK: - UIProperty
	public var parentVC: UIViewController?
	public var backgroundView: UIView = UIView()
	public var sideBarView: UIView = ChatRoomSidebarView()
	public var sideBarViewWidth: CGFloat = Metric.sideBarViewWidth
	
	// MARK: - Property
	private let ChattingRoomSidebarViewModel: ChatRoomSidebarViewModelInterface
	private let disposeBag: DisposeBag = DisposeBag()
	
	// MARK: - INITIALIZE
	public init(ChattingRoomSidebarViewModel: ChatRoomSidebarViewModelInterface) {
		self.ChattingRoomSidebarViewModel = ChattingRoomSidebarViewModel
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	// MARK: - LifeCycle
	public override func viewDidLoad() {
		super.viewDidLoad()
		
		setupBinds()
		setupGestures()
	}
}

// MARK: - PRIVATE METHOD
private extension ChatRoomSidebarViewController {
	func setupBinds() {
		guard let baseView: ChatRoomSidebarView = sideBarView as? 
						ChatRoomSidebarView else { return }

		ChattingRoomSidebarViewModel.channelInfoDTORelay
			.subscribe(onNext: { [weak self] infoData in
				guard let self else { return }
				
				baseView.chatRoomNameLabel.text = infoData.name
				baseView.joinMemberCountLabel.text = "\(infoData.member_count)"
			}).disposed(by: disposeBag)
		
		ChattingRoomSidebarViewModel.displayableMembers
			.bind(to: baseView.joinMemberListCollectionView.rx.items) { _, row, element in
				let indexPath = IndexPath(row: row, section: 0)
				
				guard let cell = baseView.joinMemberListCollectionView.dequeueReusableCell(
					withReuseIdentifier: JoinMemberListCell.identifier, 
					for: indexPath
				) as? JoinMemberListCell else { return JoinMemberListCell() }
				
				cell.memberNameLabel.text = element.name
				return cell
			}.disposed(by: disposeBag)
	}
	
	func setupGestures() {
		backgroundView.rx.tapGesture()
			.when(.recognized)
			.bind { [weak self] _ in
				guard let self else { return }
				
				self.hideSideBar()
			}
			.disposed(by: disposeBag)
		}
}
