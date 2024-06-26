//
//  ChattingView.swift
//  ChattingDemoApp
//
//  Created by 구본의 on 2023/12/28.
//

import UIKit

import DesignSystem
import ResourceKit
import UtilityKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class ChattingRoomView: UIView {
	// MARK: - METRIC
	private enum Metric {
		static let animateWithDuration: TimeInterval = 0.5
		
		static let bottomStackViewSpcing: CGFloat = 12
		static let bottomStackViewVerticalMargin: CGFloat = 8
		static let bottomStackViewHorizontalMargin: CGFloat = 12
		
		static let addPhotoMenuButtonViewWidth: CGFloat = 24
		static let addPhotoMenuButtonBottomMargin: CGFloat = 11
		
		static let addPhotoMenuViewWidth: CGFloat = 60
		static let cameraButtonBottomMargin: CGFloat = 11
		static let galleryButtonLeftMargin: CGFloat = 12
		
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
	private let chattingRoomCollectionViewLayout: UICollectionViewCompositionalLayout = {
		let itemSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1),
			heightDimension: .estimated(1)
		)
		
		let item = NSCollectionLayoutItem(layoutSize: itemSize)
		
		let groupSize = NSCollectionLayoutSize(
			widthDimension: .fractionalWidth(1),
			heightDimension: .estimated(30)
		)
		
		let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
		
		let section = NSCollectionLayoutSection(group: group)
		
		return UICollectionViewCompositionalLayout(section: section)
	}()
	
	public lazy var chattingRoomCollectionView: UICollectionView = UICollectionView(
		frame: .zero,
		collectionViewLayout: chattingRoomCollectionViewLayout
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
	}
	
	private let chattingRoomBottomView: UIView = UIView().then {
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
	
	private let cameraButton: UIButton = UIButton().then {
		$0.setImage(AppTheme.Image.useCamera, for: .normal)
		$0.tintColor = AppTheme.Color.neutral900
	}
	
	private let galleryButton: UIButton = UIButton().then {
		$0.setImage(AppTheme.Image.selectPhoto, for: .normal)
		$0.tintColor = AppTheme.Color.neutral900
	}
	
	private let messageInputView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.neutral50
		$0.makeCornerRadius(Metric.messageInputViewCornerRadius)
		$0.makeBorder()
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
	
	public func scollingBottom() {
		self.chattingRoomCollectionView.setContentOffset(
			CGPoint(
				x: 0,
				y: self.chattingRoomCollectionView.contentSize.height
				- self.chattingRoomCollectionView.bounds.height
			),
			animated: true
		)
	}
}

// MARK: - Viewable METHOD
extension ChattingRoomView: Viewable {
	func setupConfigures() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupViews() {
		addSubview(chattingRoomCollectionView)
		addSubview(chattingRoomBottomView)
		
		chattingRoomBottomView.addSubview(bottomStackView)
		
		addPhotoMenuButtonView.addSubview(addPhotoMenuButton)
		
		addPhotoMenuView.addSubview(cameraButton)
		addPhotoMenuView.addSubview(galleryButton)
		
		messageInputView.addSubview(inputMessageTextView)
		messageInputView.addSubview(sendMessageButton)
		
		setupConstraints()
	}
	
	func setupConstraints() {
		chattingRoomCollectionView.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.horizontalEdges.equalToSuperview()
			make.bottom.equalTo(chattingRoomBottomView.snp.top)
		}
		
		chattingRoomBottomView.snp.makeConstraints { make in
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
		
		cameraButton.snp.makeConstraints { make in
			make.bottom.equalToSuperview().inset(Metric.cameraButtonBottomMargin)
			make.leading.equalToSuperview()
			make.size.equalTo(Metric.defaultButtinSize)
		}
		
		galleryButton.snp.makeConstraints { make in
			make.centerY.equalTo(cameraButton)
			make.leading.equalTo(cameraButton.snp.trailing).offset(Metric.galleryButtonLeftMargin)
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
extension Reactive where Base: ChattingRoomView {
	var didTapSendMessageButton: ControlEvent<Void> {
		let source = base.sendMessageButton.rx.touchHandler()
		return ControlEvent(events: source)
	}
	
	var didTapAddPhotoMenuButton: ControlEvent<Void> {
		let source = base.addPhotoMenuButton.rx.touchHandler()
		return ControlEvent(events: source)
	}
	
	var didTapChattingRoomCollectionView: ControlEvent<Void> {
		let source = base.chattingRoomCollectionView.rx.tapGesture().when(.recognized).map { _ in }
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
