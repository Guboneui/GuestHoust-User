//
//  FilterButton.swift
//  DesignSystem
//
//  Created by 김민희 on 3/11/24.
//

import UIKit

import ResourceKit

import RxSwift
import SnapKit
import Then

public class FilterButton: UIView {
	
	// MARK: METRIC
	private enum Metric {
		static let buttonHeight: CGFloat = 32
		static let buttonRadius: CGFloat = 16
		static let iconImageViewLeftMargin: CGFloat = 12
		static let iconImageViewVerticalInset: CGFloat = 8
		static let iconImageViewSize: CGFloat = 16
		static let deleteButtonRightMargin: CGFloat = -12
		static let deleteButtonSize: CGFloat = 16
		static let titleLabelLeftMargin: CGFloat = 4
		static let titleLabelSelectedRightMargin: CGFloat = -4
		static let titleLabelFilterRightMargin: CGFloat = -12
		static let buttonBorderWidth: CGFloat = 1
	}
	
	// MARK: Font
	private enum Font {
		static let buttonFont: UIFont = AppTheme.Font.Regular_12
	}
	
	// MARK: COLORSET
	private enum ColorSet {
		static let backgroundColor: UIColor = AppTheme.Color.white
		static let textColor: UIColor = AppTheme.Color.neutral900
		static let ImageColor: UIColor = AppTheme.Color.neutral900
		static let selectedFilterBorderColor: UIColor = AppTheme.Color.primary
		static let filterBorderColor: UIColor = AppTheme.Color.neutral100
	}
	
	// MARK: INPUT PROPERTY
	private let icon: UIImage
	private let title: String
	private let initSelectedState: Bool
	
	// MARK: PROPERTY
	private let disposeBag: DisposeBag
	
	// MARK: UI PROPERTY
	private let iconImageView: UIImageView = UIImageView()
	private let titleLabel: UILabel = UILabel()
	private let deleteButton: UIButton = UIButton().then {
		$0.setImage(AppTheme.Image.delete, for: .normal)
		$0.tintColor = AppTheme.Color.neutral100
	}
	
	public init(
		icon: UIImage,
		title: String,
		initSelectedState: Bool
	) {
		self.icon = icon
		self.title = title
		self.initSelectedState = initSelectedState
		self.disposeBag = .init()
		super.init(frame: .zero)
		self.setupSubViews()
		self.setupConfiguration()
		self.setupGeustures()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - PRIVATE METHOD
private extension FilterButton {
	func setupSubViews() {
		addSubview(iconImageView)
		addSubview(titleLabel)
		addSubview(deleteButton)
		
		setupConstraints()
	}
	
	func setupConstraints() {
		snp.makeConstraints { make in
			make.height.equalTo(Metric.buttonHeight)
		}
		
		iconImageView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(Metric.iconImageViewLeftMargin)
			make.verticalEdges.equalToSuperview().inset(Metric.iconImageViewVerticalInset)
			make.size.equalTo(Metric.iconImageViewSize)
		}
		
		deleteButton.snp.makeConstraints { make in
			make.trailing.equalToSuperview().offset(Metric.deleteButtonRightMargin)
			make.centerY.equalToSuperview()
			make.size.equalTo(Metric.deleteButtonSize)
		}
		
		titleLabel.snp.remakeConstraints { make in
			make.leading.equalTo(iconImageView.snp.trailing).offset(Metric.titleLabelLeftMargin)
			if initSelectedState {
				make.trailing.equalTo(deleteButton.snp.leading).offset(Metric.titleLabelSelectedRightMargin)
			} else {
				make.trailing.equalToSuperview().offset(Metric.titleLabelFilterRightMargin)
			}
			make.centerY.equalTo(iconImageView.snp.centerY)
		}
	}
	
	func setupConfiguration() {
		backgroundColor = ColorSet.backgroundColor
		
		iconImageView.image = icon
		iconImageView.tintColor = ColorSet.ImageColor
		
		titleLabel.text = title
		titleLabel.textColor = ColorSet.textColor
		titleLabel.font = Font.buttonFont
		
		if initSelectedState {
			makeCornerRadiusWithBorder(
				Metric.buttonRadius,
				borderWidth: Metric.buttonBorderWidth,
				borderColor: ColorSet.selectedFilterBorderColor
			)
		} else {
			makeCornerRadiusWithBorder(
				Metric.buttonRadius,
				borderWidth: Metric.buttonBorderWidth,
				borderColor: ColorSet.filterBorderColor
			)
			
			deleteButton.isHidden = true
		}
	}
	
	func setupGeustures() {
		deleteButton.rx.touchHandler()
			.bind { [weak self] in
				self?.isHidden = true
			}.disposed(by: disposeBag)
	}
}
