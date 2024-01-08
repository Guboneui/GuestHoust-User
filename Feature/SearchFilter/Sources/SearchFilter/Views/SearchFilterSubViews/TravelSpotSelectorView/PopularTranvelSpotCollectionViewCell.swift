//
//  PopularTranvelSpotCollectionViewCell.swift
//  SearchFilter
//
//  Created by 구본의 on 2023/11/30.
//

import UIKit

import DesignSystem
import ResourceKit

import SnapKit
import Then

final class PopularTranvelSpotCollectionViewCell: UICollectionViewCell {
	
	// MARK: - IDENTIFIER
	static let identifier: String = "PopularTranvelSpotCollectionViewCell"
	
	// MARK: - METRIC
	private enum Metric {
		static let radius: CGFloat = 28
		static let titleLabelHorizontalMargin: CGFloat = 8
		static let selectedWidth: CGFloat = 2
	}
	
	// MARK: - UI PROPERTY
	private let titleLabel: UILabel = UILabel().then {
		$0.font = AppTheme.Font.Regular_12
		$0.textAlignment = .center
	}
	
	// MARK: - INITIALIZE
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViewConfigures()
		setupSubViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func prepareForReuse() {
		super.prepareForReuse()
		titleLabel.text = nil
	}
	
	// MARK: - PUBLIC METHOD
	func updateValue(
		with spotInfo: String,
		isSelected: Bool
	) {
		titleLabel.text = spotInfo
		if isSelected {
			contentView.makeCornerRadiusWithBorder(
				Metric.radius,
				borderWidth: Metric.selectedWidth,
				borderColor: AppTheme.Color.primary
			)
			titleLabel.textColor = AppTheme.Color.black
		} else {
			contentView.makeCornerRadiusWithBorder(Metric.radius)
			titleLabel.textColor = AppTheme.Color.grey40
		}
	}
}

private extension PopularTranvelSpotCollectionViewCell {
	func setupViewConfigures() {
		contentView.makeCornerRadiusWithBorder(Metric.radius)
	}
	
	func setupSubViews() {
		addSubview(titleLabel)
		
		setupConstraints()
	}
	
	func setupConstraints() {
		titleLabel.snp.makeConstraints { make in
			make.centerY.equalToSuperview()
			make.horizontalEdges.equalToSuperview().inset(Metric.titleLabelHorizontalMargin)
		}
	}
}
