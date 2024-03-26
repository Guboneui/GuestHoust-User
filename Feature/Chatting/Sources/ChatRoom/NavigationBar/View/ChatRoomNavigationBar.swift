//
//  ChatRoomNavigationBar.swift
//  Chatting
//
//  Created by 김동겸 on 3/9/24.
//

import UIKit

import ResourceKit
import UtilityKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class ChatRoomNavigationBar: UIView {
	// MARK: METRIC
	private enum Metric {
		static let navigationBarAlpha: CGFloat = 0.7
		static let navigationBarHeight: CGFloat = 98
		
		static let backButtonSize: CGFloat = 24
		static let backButtonLeftMargin: CGFloat = 16
		
		static let titleStackViewSpacing: CGFloat = 4
		static let titleStackViewTopMargin: CGFloat = 58
		
		static let sideBarButtonSize: CGFloat = 24
		static let sideBarButtonRightMargin: CGFloat = 16
	}
	
	// MARK: - PROPERTY
	public let titleLabel: UILabel = UILabel().then {
		$0.font = AppTheme.Font.Bold_18
		$0.textColor = AppTheme.Color.neutral900
	}
	
	public let memberCountLabel: UILabel = UILabel().then {
		$0.font = AppTheme.Font.Bold_18
		$0.textColor = AppTheme.Color.neutral300
	}
	
	private lazy var titleStackView: UIStackView = UIStackView(
		arrangedSubviews: [
			titleLabel,
			memberCountLabel
		]
	).then {
		$0.axis = .horizontal
		$0.distribution = .fill
		$0.spacing = Metric.titleStackViewSpacing
	}
	
	fileprivate let backButton: UIButton = UIButton().then {
		$0.setImage(AppTheme.Image.arrowLeft, for: .normal)
		$0.tintColor = AppTheme.Color.neutral900
	}
	
	fileprivate let sideBarButton: UIButton = UIButton().then {
		$0.setImage(AppTheme.Image.hamburger, for: .normal)
		$0.tintColor = AppTheme.Color.neutral900
	}
	
	// MARK: - Iitialize
	public init() {
		super.init(frame: .zero)
		setupConfigures()
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Viewable METHOD
extension ChatRoomNavigationBar: Viewable {
	func setupConfigures() {
		backgroundColor = AppTheme.Color.white
		alpha = Metric.navigationBarAlpha
	}
	
	func setupViews() {
		addSubview(titleStackView)
		addSubview(backButton)
		addSubview(sideBarButton)
		
		setupConstraints()
	}
	
	func setupConstraints() {
		snp.makeConstraints { make in
			make.height.equalTo(Metric.navigationBarHeight)
		}
		
		titleStackView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(Metric.titleStackViewTopMargin)
			make.centerX.equalToSuperview()
		}
		
		backButton.snp.makeConstraints { make in
			make.leading.equalToSuperview().inset(Metric.backButtonLeftMargin)
			make.centerY.equalTo(titleStackView)
			make.size.equalTo(Metric.backButtonSize)
		}
		
		sideBarButton.snp.makeConstraints { make in
			make.trailing.equalToSuperview().inset(Metric.sideBarButtonRightMargin)
			make.centerY.equalTo(titleStackView)
			make.size.equalTo(Metric.sideBarButtonSize)
		}
	}
	
	func setupBinds() { }
}

// MARK: - Reactive Extension
extension Reactive where Base: ChatRoomNavigationBar {
	var didTapBackButton: ControlEvent<Void> {
		let source = base.backButton.rx.touchHandler()
		return ControlEvent(events: source)
	}
	
	var didTapSideBarButton: ControlEvent<Void> {
		let source = base.sideBarButton.rx.touchHandler()
		return ControlEvent(events: source)
	}
}
