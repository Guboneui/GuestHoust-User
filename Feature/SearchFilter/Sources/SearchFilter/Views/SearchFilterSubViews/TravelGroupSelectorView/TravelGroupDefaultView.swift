//
//  TravelGroupDefaultView.swift
//  SearchFilter
//
//  Created by 구본의 on 2023/11/28.
//

import UIKit

import DesignSystem
import ResourceKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class TravelGroupDefaultView: UIView {
	
	// MARK: - METRIC
	private enum Metric {
		static let travelerLabelVerticalMargin: CGFloat = 24
		static let travelerLabelLeadingMargin: CGFloat = 32
		
		static let counterLabelTrailingMargin: CGFloat = -32
	}
	
	// MARK: - UI PROPERTY
	private let travlerLabel: UILabel = UILabel().then {
		$0.text = "여행자"
		$0.font = AppTheme.Font.Regular_12
		$0.textColor = AppTheme.Color.black
	}
	
	fileprivate let counterLabel: UILabel = UILabel().then {
		$0.text = "0 명"
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
private extension TravelGroupDefaultView {
	func setupConfigure() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupSubViews() {
		addSubview(travlerLabel)
		addSubview(counterLabel)
		setupConstraints()
	}
	
	func setupConstraints() {
		travlerLabel.snp.makeConstraints { make in
			make.verticalEdges.equalToSuperview().inset(Metric.travelerLabelVerticalMargin)
			make.leading.equalToSuperview().offset(Metric.travelerLabelLeadingMargin)
		}
		
		counterLabel.snp.makeConstraints { make in
			make.centerY.equalTo(travlerLabel.snp.centerY)
			make.trailing.equalToSuperview().offset(Metric.counterLabelTrailingMargin)
		}
	}
}

// MARK: - Reactive Extension
extension Reactive where Base: TravelGroupDefaultView {
	var counterValue: Binder<String> {
		return Binder(base) { view, text in
			view.counterLabel.text = text
		}
	}
}
