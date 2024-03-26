//
//  ChatRoomSidebarView.swift
//  Chatting
//
//  Created by 김동겸 on 3/14/24.
//

import UIKit

import ResourceKit
import UtilityKit

import SnapKit
import Then

final class ChatRoomSidebarView: UIView {
	// MARK: - METRIC
	private enum Metric {
		static let topContainerViewHegiht: CGFloat = 122
		static let chatRoomNameLabelBottomMargin: CGFloat = -4
		static let joinMemberStackViewLeftMargin: CGFloat = 16
		static let joinMemberStackViewBottomMargin: CGFloat = 16
		
		static let dividingLineViewHeght: CGFloat = 8
		
		static let middleContainerViewHegiht: CGFloat = 43
		static let joinMemberListLabelLeftMargin: CGFloat = 16
		
		static let bottomContainerViewHegiht: CGFloat = 90
		static let exitChattingRoomButtonTopMargin: CGFloat = 16
		static let exitChattingRoomButtonLeftMargin: CGFloat = 12
		static let exitChattingRoomButtonSize: CGFloat = 24
		static let exitScheduleStackViewLeftMargin: CGFloat = 12

		static let joinMemberStackViewSpacing: CGFloat = 2
		static let exitScheduleStackViewSpacing: CGFloat = 2
	}
	
	// MARK: - TEXTSET
	private enum TextSet {
		static let joinMemberLabelText: String = "명 참여중"
		static let joinMemberListLabelText: String = "참여자 목록"
		static let exitScheduleLabelText: String = "채팅방 자동 퇴장 예정일 |"
	}
	// MARK: - PROPERTY
	private let topContainerView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.white
	}
	
	public let chatRoomNameLabel: UILabel = UILabel().then {
		$0.font = AppTheme.Font.Bold_18
		$0.textColor = AppTheme.Color.neutral900
	}
		
	public let joinMemberCountLabel: UILabel = UILabel().then {
		$0.font = AppTheme.Font.Bold_14
		$0.textColor = AppTheme.Color.neutral300
	}
	
	private let joinMemberLabel: UILabel = UILabel().then {
		$0.text = TextSet.joinMemberLabelText
		$0.font = AppTheme.Font.Bold_14
		$0.textColor = AppTheme.Color.neutral300
	}
	
	private lazy var joinMemberStackView: UIStackView = UIStackView(
		arrangedSubviews: [
			joinMemberCountLabel,
			joinMemberLabel
		]
	).then {
		$0.axis = .horizontal
		$0.distribution = .fill
		$0.spacing = Metric.joinMemberStackViewSpacing
	}
	
	private let dividingLineView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.neutral50
	}
	
	private let middleContainerView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.white
	}
	
	private let joinMemberListLabel: UILabel = UILabel().then {
		$0.text = TextSet.joinMemberListLabelText
		$0.font = AppTheme.Font.Bold_16
		$0.textColor = AppTheme.Color.neutral900
	}
	
	private let compositionalLayout: UICollectionViewCompositionalLayout = {
		var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
		listConfiguration.showsSeparators = false
		listConfiguration.backgroundColor = AppTheme.Color.white
		let compositionalLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
		return compositionalLayout
	}()
	
	public lazy var joinMemberListCollectionView: UICollectionView = UICollectionView(
		frame: .zero,
		collectionViewLayout: compositionalLayout
	).then {
		$0.backgroundColor = AppTheme.Color.white
		$0.register(
			JoinMemberListCell.self,
			forCellWithReuseIdentifier: JoinMemberListCell.identifier
		)
	}
	
	private let bottomContainerView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.neutral50
	}
	
	private let exitChattingRoomButton: UIButton = UIButton().then {
		$0.setImage(AppTheme.Image.exit.withRenderingMode(.alwaysTemplate), for: .normal)
		$0.tintColor = AppTheme.Color.neutral300
	}
	
	private let exitScheduleLabel: UILabel = UILabel().then {
		$0.text = TextSet.exitScheduleLabelText
		$0.font = AppTheme.Font.Regular_14
		$0.textColor = AppTheme.Color.neutral300
	}
	
	private let exitScheduleDateLabel: UILabel = UILabel().then {
		$0.text = "2023.12.12"
		$0.font = AppTheme.Font.Bold_14
		$0.textColor = AppTheme.Color.neutral300
	}
	
	private lazy var exitScheduleStackView: UIStackView = UIStackView(
		arrangedSubviews: [
			exitScheduleLabel,
			exitScheduleDateLabel
		]
	).then {
		$0.axis = .horizontal
		$0.distribution = .fill
		$0.spacing = Metric.exitScheduleStackViewSpacing
	}
	
	// MARK: - Iitialize
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupConfigures()
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Viewable METHOD
extension ChatRoomSidebarView: Viewable {
	func setupConfigures() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupViews() {
		addSubview(topContainerView)
		topContainerView.addSubview(chatRoomNameLabel)
		topContainerView.addSubview(joinMemberStackView)
		topContainerView.addSubview(dividingLineView)
		
		addSubview(middleContainerView)
		middleContainerView.addSubview(joinMemberListLabel)
		
		addSubview(joinMemberListCollectionView)
		
		addSubview(bottomContainerView)
		bottomContainerView.addSubview(exitChattingRoomButton)
		bottomContainerView.addSubview(exitScheduleStackView)
		
		setupConstraints()
	}
	
	func setupConstraints() {
		topContainerView.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.horizontalEdges.equalToSuperview()
			make.height.equalTo(Metric.topContainerViewHegiht)
		}
		
		chatRoomNameLabel.snp.makeConstraints { make in
			make.bottom.equalTo(joinMemberStackView.snp.top)
				.offset(Metric.chatRoomNameLabelBottomMargin)
			make.leading.equalTo(joinMemberStackView.snp.leading)
		}
		
		joinMemberStackView.snp.makeConstraints { make in
			make.bottom.equalToSuperview().inset(Metric.joinMemberStackViewBottomMargin)
			make.leading.equalToSuperview().inset(Metric.joinMemberStackViewLeftMargin)
		}
		
		dividingLineView.snp.makeConstraints { make in
			make.top.equalTo(topContainerView.snp.bottom)
			make.horizontalEdges.equalToSuperview()
			make.height.equalTo(Metric.dividingLineViewHeght)
		}
		
		middleContainerView.snp.makeConstraints { make in
			make.top.equalTo(dividingLineView.snp.bottom)
			make.horizontalEdges.equalToSuperview()
			make.height.equalTo(Metric.middleContainerViewHegiht)
		}
		
		joinMemberListLabel.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.leading.equalToSuperview().inset(Metric.joinMemberListLabelLeftMargin)
		}
		
		joinMemberListCollectionView.snp.makeConstraints { make in
			make.top.equalTo(middleContainerView.snp.bottom)
			make.horizontalEdges.equalToSuperview()
		}
		
		bottomContainerView.snp.makeConstraints { make in
			make.top.equalTo(joinMemberListCollectionView.snp.bottom)
			make.horizontalEdges.equalToSuperview()
			make.bottom.equalToSuperview()
			make.height.equalTo(Metric.bottomContainerViewHegiht)
		}
		
		exitChattingRoomButton.snp.makeConstraints { make in
			make.top.equalToSuperview().inset(Metric.exitChattingRoomButtonTopMargin)
			make.leading.equalToSuperview().inset(Metric.exitChattingRoomButtonLeftMargin)
			make.size.equalTo(Metric.exitChattingRoomButtonSize)
		}
		
		exitScheduleStackView.snp.makeConstraints { make in
			make.centerY.equalTo(exitChattingRoomButton)
			make.leading.equalTo(exitChattingRoomButton.snp.trailing)
				.offset(Metric.exitScheduleStackViewLeftMargin)
		}
	}
	
	func setupBinds() { }
}
