//
//  TravelSpotDefaultView.swift
//  SearchFilter
//
//  Created by 구본의 on 2023/11/29.
//

import UIKit

import DesignSystem
import ResourceKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class TravelSpotDefaultView: UIView {
	
	// MARK: - METRIC
	private enum Metric {
		static let travelerLabelVerticalMargin: CGFloat = 24
		static let travelerLabelLeadingMargin: CGFloat = 32
		
		static let counterLabelTrailingMargin: CGFloat = -32
	}
	
	// MARK: - TextSet
	private enum TextSet {
		static let locationText: String = "위치"
	}
	
	// MARK: - UI PROPERTY
	fileprivate let locationLabel: UILabel = UILabel().then {
		$0.text = TextSet.locationText
		$0.font = AppTheme.Font.Regular_12
		$0.textColor = AppTheme.Color.black
	}
	
	fileprivate let selectedLocationLabel: UILabel = UILabel().then {
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
private extension TravelSpotDefaultView {
	func setupConfigure() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupSubViews() {
		addSubview(locationLabel)
		addSubview(selectedLocationLabel)
		setupConstraints()
	}
	
	func setupConstraints() {
		locationLabel.snp.makeConstraints { make in
			make.verticalEdges.equalToSuperview().inset(Metric.travelerLabelVerticalMargin)
			make.leading.equalToSuperview().offset(Metric.travelerLabelLeadingMargin)
		}
		
		selectedLocationLabel.snp.makeConstraints { make in
			make.centerY.equalTo(locationLabel.snp.centerY)
			make.trailing.equalToSuperview().offset(Metric.counterLabelTrailingMargin)
		}
	}
}

// MARK: - Reactive Extension
extension Reactive where Base: TravelSpotDefaultView {
	var locationValue: Binder<String> {
		return Binder(base) { view, text in
			view.selectedLocationLabel.text = text
		}
	}
	
	var selectedSpot: Binder<String> {
		return Binder(base) { view, selectedSpot in
			view.selectedLocationLabel.text = selectedSpot
		}
	}
}
