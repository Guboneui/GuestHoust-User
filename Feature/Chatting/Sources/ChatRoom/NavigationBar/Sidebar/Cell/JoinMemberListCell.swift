//
//  JoinMemberListCell.swift
//  Chatting
//
//  Created by 김동겸 on 3/14/24.
//

import UIKit

import ResourceKit
import UtilityKit

import SnapKit
import Then

final class JoinMemberListCell: UICollectionViewCell {
	// MARK: - METRIC
	private enum Metric {
		static let memberlProfileImageViewCornerRadius: CGFloat = 18
		static let memberlProfileImageViewVerticalMargin: CGFloat = 8
		static let memberlProfileImageViewLeftMargin: CGFloat = 16
		static let memberlProfileImageViewSize: CGFloat = 36
		
		static let memberNameLabelLeftMargin: CGFloat = 8
	}
	
	// MARK: - UI Property
	private let memberlProfileImageView: UIImageView = UIImageView().then {
		$0.backgroundColor = AppTheme.Color.primary
		$0.makeCornerRadius(Metric.memberlProfileImageViewCornerRadius)
	}
	
	public let memberNameLabel: UILabel = UILabel().then {
		$0.font = AppTheme.Font.Regular_12
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

extension JoinMemberListCell: Viewable {
	func setupConfigures() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupViews() {
		addSubview(memberlProfileImageView)
		addSubview(memberNameLabel)

		setupConstraints()
	}
	
	func setupConstraints() {
		memberlProfileImageView.snp.makeConstraints { make in
			make.verticalEdges.equalToSuperview().inset(Metric.memberlProfileImageViewVerticalMargin)
			make.leading.equalToSuperview().inset(Metric.memberlProfileImageViewLeftMargin)
			make.size.equalTo(Metric.memberlProfileImageViewSize)
		}
		
		memberNameLabel.snp.makeConstraints { make in
			make.centerY.equalTo(memberlProfileImageView)
			make.leading.equalTo(memberlProfileImageView.snp.trailing)
				.offset(Metric.memberNameLabelLeftMargin)
		}
	}
	
	func setupBinds() { }
}
