//
//  ChannelListCell.swift
//  Chatting
//
//  Created by 김동겸 on 3/11/24.
//

import UIKit

import DesignSystem
import ResourceKit
import UtilityKit

import SnapKit
import Then

final class ChannelListCell: UICollectionViewCell {
	// MARK: - METRIC
	private enum Metric {
		static let channelProfileImageViewCornerRadius: CGFloat = 18
	}
	
	// MARK: - UI Property
	private let channelProfileImageView: UIImageView = UIImageView().then {
		$0.backgroundColor = AppTheme.Color.primary
		$0.makeCornerRadius(Metric.channelProfileImageViewCornerRadius)
	}
	
	public let channelNameLabel: UILabel = UILabel().then {
		$0.font = AppTheme.Font.Bold_20
		$0.textColor = AppTheme.Color.neutral900
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

extension ChannelListCell: Viewable {
	func setupConfigures() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupViews() {
		addSubview(channelProfileImageView)
		addSubview(channelNameLabel)

		setupConstraints()
	}
	
	func setupConstraints() {
		channelProfileImageView.snp.makeConstraints { make in
			make.verticalEdges.equalToSuperview().inset(8)
			make.leading.equalToSuperview().inset(12)
			make.size.equalTo(36)
		}
		
		channelNameLabel.snp.makeConstraints { make in
			make.centerY.equalTo(channelProfileImageView)
			make.leading.equalTo(channelProfileImageView.snp.trailing).offset(10)
		}
	}
	
	func setupBinds() { }
}
