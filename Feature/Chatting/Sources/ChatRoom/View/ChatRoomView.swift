//
//  ChatRoomView.swift
//  ChattingDemoApp
//
//  Created by 구본의 on 2023/12/28.
//

import UIKit

import ResourceKit
import UtilityKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class ChatRoomView: UIView {
	// MARK: - METRIC
	private enum Metric {
		static let animateWithDuration: TimeInterval = 0.5
		
		static let bottomStackViewSpcing: CGFloat = 12
		static let bottomStackViewVerticalMargin: CGFloat = 8
		static let bottomStackViewHorizontalMargin: CGFloat = 12
		
		static let addPhotoMenuButtonViewWidth: CGFloat = 24
		static let addPhotoMenuButtonBottomMargin: CGFloat = 11
		
		static let addPhotoMenuViewWidth: CGFloat = 60
		static let galleryButtonBottomMargin: CGFloat = 11
		static let cameraButtonLeftMargin: CGFloat = 12
		
		static let messageInputViewCornerRadius: CGFloat = 20
		static let inputMessageTextViewMinHeight: CGFloat = 30.333333333333332
		static let inputMessageTextViewMaxHeight: CGFloat = 73.33333333333333
		static let inputMessageTextViewVerticalMargin: CGFloat = 8
		static let inputMessageTextViewLeftMargin: CGFloat = 16
		static let inputMessageTextViewRightMargin: CGFloat = 45
		static let sendMessageButtonBottomMargin: CGFloat = 11
		static let sendMessageButtonRightMargin: CGFloat = 12
		
		static let defaultButtinSize: CGFloat = 24
	}
	
	// MARK: - UI Property
	public let navigationBarView: ChatRoomNavigationBar = ChatRoomNavigationBar()
	
	private let compositionalLayout: UICollectionViewCompositionalLayout = {
		var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
		listConfiguration.showsSeparators = false
		listConfiguration.backgroundColor = AppTheme.Color.neutral50
		let compositionalLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
		return compositionalLayout
	}()
	
	public lazy var chatListCollectionView: UICollectionView = UICollectionView(
		frame: .zero,
		collectionViewLayout: compositionalLayout
	).then {
		$0.backgroundColor = AppTheme.Color.neutral50
		$0.register(
			ChatByFriendWithProfileImageCell.self,
			forCellWithReuseIdentifier: ChatByFriendWithProfileImageCell.identifier
		)
		$0.register(
			ChatByFriendCell.self,
			forCellWithReuseIdentifier: ChatByFriendCell.identifier
		)
		$0.register(
			ChatByOwnerCell.self,
			forCellWithReuseIdentifier: ChatByOwnerCell.identifier
		)
		$0.contentInset = UIEdgeInsets(top: 60, left: 0, bottom: 0, right: 0)
	}
	
	private let chatRoomBottomView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.white
	}
	
	private let addPhotoMenuButtonView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.white
	}
	
	fileprivate let addPhotoMenuButton: UIButton = UIButton().then {
		$0.setImage(AppTheme.Image.plus, for: .normal)
		$0.tintColor = AppTheme.Color.neutral900
	}
	
	private let addPhotoMenuView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.white
	}
	
	fileprivate let cameraButton: UIButton = UIButton().then {
		$0.setImage(AppTheme.Image.useCamera, for: .normal)
		$0.tintColor = AppTheme.Color.neutral900
	}
	
	fileprivate let galleryButton: UIButton = UIButton().then {
		$0.setImage(AppTheme.Image.selectPhoto, for: .normal)
		$0.tintColor = AppTheme.Color.neutral900
	}
	
	private let messageInputView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.neutral50
		$0.makeCornerRadiusWithBorder(
			Metric.messageInputViewCornerRadius,
			borderColor: AppTheme.Color.neutral100
		)
	}
	
	fileprivate let inputMessageTextView: UITextView = UITextView().then {
		$0.font = AppTheme.Font.Regular_12
		$0.textColor = AppTheme.Color.neutral900
		$0.backgroundColor = AppTheme.Color.neutral50
		$0.isScrollEnabled = false
	}
	
	fileprivate let sendMessageButton: UIButton = UIButton().then {
		$0.setImage(AppTheme.Image.send, for: .normal)
	}
	
	private lazy var bottomStackView: UIStackView = UIStackView(
		arrangedSubviews: [
			addPhotoMenuButtonView,
			addPhotoMenuView,
			messageInputView
		]).then {
			$0.axis = .horizontal
			$0.distribution = .fill
			$0.spacing = Metric.bottomStackViewSpcing
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
	
	// MARK: - PUBLIC METHOD
	public func addPhotoMenuButtonAnimation(with isMenuOpen: Bool) {
		UIView.animate(withDuration: Metric.animateWithDuration, animations: {
			self.addPhotoMenuView.alpha = isMenuOpen ? 0.0 : 1.0
			self.addPhotoMenuView.isHidden = isMenuOpen
			self.addPhotoMenuButton.transform = isMenuOpen ?
				.identity : CGAffineTransform(rotationAngle: .pi / 4 )
		})
	}
	
	public func sendMessageButtonAnimation(with isHidden: Bool) {
		UIView.animate(withDuration: Metric.animateWithDuration, animations: {
			self.sendMessageButton.isHidden = isHidden
			self.sendMessageButton.alpha = isHidden ? 0.0 : 1.0
			
			if isHidden {
				self.inputMessageTextView.text = ""
			}
		})
	}
	
	public func setSizingInputMessageTextView() {
		let size = CGSize(width: self.inputMessageTextView.frame.width, height: .infinity)
		let estimatedSize = inputMessageTextView.sizeThatFits(size)

		if estimatedSize.height > Metric.inputMessageTextViewMaxHeight {
			self.inputMessageTextView.snp.updateConstraints { make in
				make.height.equalTo(Metric.inputMessageTextViewMaxHeight)
			}
			self.inputMessageTextView.isScrollEnabled = true
			
		} else {
			self.inputMessageTextView.snp.updateConstraints { make in
				make.height.equalTo(estimatedSize.height)
			}
			self.inputMessageTextView.isScrollEnabled = false
		}
	}
	
	public func setOriginalSizingInputMessageTextView() {
		self.inputMessageTextView.snp.updateConstraints { make in
			make.height.equalTo(Metric.inputMessageTextViewMinHeight)
		}
		self.inputMessageTextView.isScrollEnabled = false
	}
}

// MARK: - Viewable METHOD
extension ChatRoomView: Viewable {
	func setupConfigures() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupViews() {
		addSubview(chatListCollectionView)
		addSubview(chatRoomBottomView)
		addSubview(navigationBarView)

		chatRoomBottomView.addSubview(bottomStackView)
		
		addPhotoMenuButtonView.addSubview(addPhotoMenuButton)
		
		addPhotoMenuView.addSubview(cameraButton)
		addPhotoMenuView.addSubview(galleryButton)
		
		messageInputView.addSubview(inputMessageTextView)
		messageInputView.addSubview(sendMessageButton)
		
		setupConstraints()
	}
	
	func setupConstraints() {
		navigationBarView.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.horizontalEdges.equalToSuperview()
		}
		
		chatListCollectionView.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.horizontalEdges.equalToSuperview()
			make.bottom.equalTo(chatRoomBottomView.snp.top)
		}
		
		chatRoomBottomView.snp.makeConstraints { make in
			make.horizontalEdges.equalToSuperview()
			make.bottom.equalTo(keyboardLayoutGuide.snp.top)
		}
		
		bottomStackView.snp.makeConstraints { make in
			make.verticalEdges.equalToSuperview().inset(Metric.bottomStackViewVerticalMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.bottomStackViewHorizontalMargin)
		}
		
		addPhotoMenuButtonView.snp.makeConstraints { make in
			make.width.equalTo(Metric.addPhotoMenuButtonViewWidth)
		}
		
		addPhotoMenuButton.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.bottom.equalToSuperview().inset(Metric.addPhotoMenuButtonBottomMargin)
			make.size.equalTo(Metric.defaultButtinSize)
		}
		
		addPhotoMenuView.snp.makeConstraints { make in
			make.width.equalTo(Metric.addPhotoMenuViewWidth)
		}
		
		galleryButton.snp.makeConstraints { make in
			make.bottom.equalToSuperview().inset(Metric.galleryButtonBottomMargin)
			make.leading.equalToSuperview()
			make.size.equalTo(Metric.defaultButtinSize)
		}
		
		cameraButton.snp.makeConstraints { make in
			make.centerY.equalTo(galleryButton)
			make.leading.equalTo(galleryButton.snp.trailing).offset(Metric.cameraButtonLeftMargin)
			make.size.equalTo(Metric.defaultButtinSize)
		}
		
		inputMessageTextView.snp.makeConstraints { make in
			make.height.equalTo(Metric.inputMessageTextViewMinHeight)
			make.verticalEdges.equalToSuperview().inset(Metric.inputMessageTextViewVerticalMargin)
			make.leading.equalToSuperview().inset(Metric.inputMessageTextViewLeftMargin)
			make.trailing.equalToSuperview().inset(Metric.inputMessageTextViewRightMargin)
		}
		
		sendMessageButton.snp.makeConstraints { make in
			make.bottom.equalToSuperview().inset(Metric.sendMessageButtonBottomMargin)
			make.trailing.equalToSuperview().inset(Metric.sendMessageButtonRightMargin)
			make.size.equalTo(Metric.defaultButtinSize)
		}
	}
	
	func setupBinds() { }
}

// MARK: - Reactive Extension
extension Reactive where Base: ChatRoomView {
	var didTapSendMessageButton: ControlEvent<Void> {
		let source = base.sendMessageButton.rx.touchHandler()
		return ControlEvent(events: source)
	}
	
	var didTapAddPhotoMenuButton: ControlEvent<Void> {
		let source = base.addPhotoMenuButton.rx.touchHandler()
		return ControlEvent(events: source)
	}
	
	var didTapCameraButton: ControlEvent<Void> {
		let source = base.cameraButton.rx.touchHandler()
		return ControlEvent(events: source)
	}
	
	var didTapGalleryButton: ControlEvent<Void> {
		let source = base.galleryButton.rx.touchHandler()
		return ControlEvent(events: source)
	}
	
	var didTapChatListCollectionView: ControlEvent<Void> {
		let source = base.chatListCollectionView.rx.tapGesture().when(.recognized).map { _ in }
		return ControlEvent(events: source)
	}
	
	var inputMessageTextViewCurrentText: ControlProperty<String?> {
		return base.inputMessageTextView.rx.text
	}
	
	var didChangeInputMessageTextView: ControlEvent<Void> {
		let source = base.inputMessageTextView.rx.didChange
		return ControlEvent(events: source)
	}
}
