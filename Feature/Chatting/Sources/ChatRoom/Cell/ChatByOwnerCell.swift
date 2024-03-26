//
//  ChatByOwnerCell.swift
//  Chatting
//
//  Created by 김동겸 on 1/15/24.
//

import UIKit

import DesignSystem
import ResourceKit
import UtilityKit

import SnapKit
import Then

final class ChatByOwnerCell: UICollectionViewCell {
	// MARK: - METRIC
	private enum Metric {
		static let messageBubbleViewCornerRadius: CGFloat = 12
		static let messageBubbleViewRightMargin: CGFloat = 12
		static let messageBubbleViewBottomMargin: CGFloat = 8
		
		static let messageLabelNumberOfLines: Int = 0
		static let messageLabelVerticalMargin: CGFloat = 8
		static let messageLabelHorizontalMargin: CGFloat = 10
		
		static let timeLabelCompressionResistancePriority: Float = 751
		static let timeLabelRightMargin: CGFloat = -4
		static let timeLabelLefttMargin: CGFloat = 90
	}
	
	// MARK: - UI Property
	private let messageBubbleView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.white
		$0.makeCornerRadius(Metric.messageBubbleViewCornerRadius)
		$0.makeBorder(borderColor: AppTheme.Color.primary)
	}
	
	public let messageLabel: UILabel = UILabel().then {
		$0.font = AppTheme.Font.Regular_12
		$0.textColor = AppTheme.Color.neutral900
		$0.numberOfLines = Metric.messageLabelNumberOfLines
		$0.lineBreakMode = .byCharWrapping
	}
	
	public let timeLabel: UILabel = UILabel().then {
		$0.font = AppTheme.Font.Regular_10
		$0.textColor = AppTheme.Color.neutral900
		$0.setContentCompressionResistancePriority(
			UILayoutPriority(Metric.timeLabelCompressionResistancePriority),
			for: .horizontal
		)
	}
	
	// MARK: - Iitialize
	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupConfigures()
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Viewable METHOD
extension ChatByOwnerCell: Viewable {
	func setupConfigures() {
		self.backgroundColor = AppTheme.Color.neutral50
	}
	
	func setupViews() {
		self.addSubview(messageBubbleView)
		messageBubbleView.addSubview(messageLabel)
		self.addSubview(timeLabel)
		
		setupConstraints()
	}
	
	func setupConstraints() {
		messageBubbleView.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.trailing.equalToSuperview().inset(Metric.messageBubbleViewRightMargin)
			make.bottom.equalToSuperview().inset(Metric.messageBubbleViewBottomMargin)
		}
		
		messageLabel.snp.makeConstraints { make in
			make.verticalEdges.equalToSuperview().inset(Metric.messageLabelVerticalMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.messageLabelHorizontalMargin)
		}
		
		timeLabel.snp.makeConstraints { make in
			make.bottom.equalTo(messageBubbleView.snp.bottom)
			make.trailing.equalTo(messageBubbleView.snp.leading).offset(Metric.timeLabelRightMargin)
			make.leading.greaterThanOrEqualToSuperview().inset(Metric.timeLabelLefttMargin)
		}
	}
	
	func setupBinds() { }
}
