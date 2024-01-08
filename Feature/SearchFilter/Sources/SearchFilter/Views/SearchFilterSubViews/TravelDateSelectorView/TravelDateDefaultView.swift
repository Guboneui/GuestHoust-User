//
//  TravelDateDefaultView.swift
//  SearchFilter
//
//  Created by 구본의 on 2023/12/06.
//

import UIKit

import DesignSystem
import ResourceKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class TravelDateDefaultView: UIView {
	
	// MARK: - METRIC
	private enum Metric {
		static let dateLabelVerticalMargin: CGFloat = 24
		static let dateLabelLeadingMargin: CGFloat = 32
		
		static let selectedDateLabelTrailingMargin: CGFloat = -32
	}
	
	// MARK: - UI PROPERTY
	private let dateLabel: UILabel = UILabel().then {
		$0.text = "날짜"
		$0.font = AppTheme.Font.Regular_12
		$0.textColor = AppTheme.Color.black
	}
	
	fileprivate let selectedDateLabel: UILabel = UILabel().then {
		$0.text = "-"
		$0.font = AppTheme.Font.Regular_12
		$0.textColor = AppTheme.Color.black
	}
	
	private let disposeBag: DisposeBag = .init()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupConfigure()
		setupSubViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - PRIVATE METHOD
private extension TravelDateDefaultView {
	func setupConfigure() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupSubViews() {
		addSubview(dateLabel)
		addSubview(selectedDateLabel)
		setupConstraints()
	}
	
	func setupConstraints() {
		dateLabel.snp.makeConstraints { make in
			make.verticalEdges.equalToSuperview().inset(Metric.dateLabelVerticalMargin)
			make.leading.equalToSuperview().offset(Metric.dateLabelLeadingMargin)
		}
		
		selectedDateLabel.snp.makeConstraints { make in
			make.centerY.equalTo(dateLabel.snp.centerY)
			make.trailing.equalToSuperview().offset(Metric.selectedDateLabelTrailingMargin)
		}
	}
}

// MARK: - Reactive Extension
extension Reactive where Base: TravelDateDefaultView {
	var dateValue: Binder<String> {
		return Binder(base) { view, text in
			view.selectedDateLabel.text = text
		}
	}
}
