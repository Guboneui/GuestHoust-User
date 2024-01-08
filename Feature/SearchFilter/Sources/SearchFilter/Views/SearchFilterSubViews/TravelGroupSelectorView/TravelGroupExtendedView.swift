//
//  TravelGroupExtendedView.swift
//  SearchFilter
//
//  Created by 구본의 on 2023/11/19.
//

import UIKit

import DesignSystem
import ResourceKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class TravelGroupExtendedView: UIView {
	
	// MARK: - METRIC
	private enum Metric {
		static let stackViewSpacing: CGFloat = 8
		static let stackViewTrailingMargin: CGFloat = -24

		static let groupLabelTopMargin: CGFloat = 21.5
		static let groupLabelLeadingMargin: CGFloat = 28
		static let groupLabelBottomMargin: CGFloat = -33.5
		
		static let titleLabelTopMargin: CGFloat = 24
		static let titleLabelHorizontalMargin: CGFloat = 22
		
		static let buttonSize: CGSize = .init(width: 36, height: 36)
		static let countLabelWidth: CGFloat = 12
		static let resizedImageSize: CGSize = .init(width: 28, height: 28)
	}
	
	// MARK: - UI PROPERTY
	private let titleLabel: UILabel = UILabel().then {
		$0.text = "마지막입니다"
		$0.font = AppTheme.Font.Bold_20
		$0.textColor = AppTheme.Color.black
	}
	
	private let groupLabel: UILabel = UILabel().then {
		$0.text = "인원"
		$0.font = AppTheme.Font.Bold_14
		$0.textColor = AppTheme.Color.black
	}
	
	fileprivate let minusButton: UIButton = UIButton().then {
		let enableImage = AppTheme.Image.minusEnable
		let resizedEnableImage = enableImage.changeImageSize(size: Metric.resizedImageSize)
		let disableImage = AppTheme.Image.minusDiable
		let resizedDisableImage = disableImage.changeImageSize(size: Metric.resizedImageSize)
		
		$0.setImage(resizedEnableImage, for: .normal)
		$0.setImage(resizedDisableImage, for: .disabled)
		$0.isEnabled = false
	}
	
	fileprivate let selectingGroupCountLabel: UILabel = UILabel().then {
		$0.font = AppTheme.Font.Bold_16
		$0.textColor = AppTheme.Color.black
		$0.textAlignment = .center

	}
	
	fileprivate let plusButton: UIButton = UIButton().then {
		let enableImage = AppTheme.Image.plusEnable
		let resizedEnableImage = enableImage.changeImageSize(size: Metric.resizedImageSize)
		let disableImage = AppTheme.Image.plusDisable
		let resizedDisableImage = disableImage.changeImageSize(size: Metric.resizedImageSize)
		
		$0.setImage(resizedEnableImage, for: .normal)
		$0.setImage(resizedDisableImage, for: .disabled)
	}
	
	private lazy var groupCountingStackView: UIStackView = UIStackView(
		arrangedSubviews: [
			minusButton,
			selectingGroupCountLabel,
			plusButton
		]).then {
			$0.spacing = Metric.stackViewSpacing
			$0.axis = .horizontal
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
private extension TravelGroupExtendedView {
	func setupConfigure() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupSubViews() {
		addSubview(titleLabel)
		addSubview(groupLabel)
		addSubview(groupCountingStackView)
		setupConstraints()
	}
	
	func setupConstraints() {
		titleLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(Metric.titleLabelTopMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.titleLabelHorizontalMargin)
		}
		
		groupLabel.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(Metric.groupLabelTopMargin)
			make.leading.equalToSuperview().offset(Metric.groupLabelLeadingMargin)
			make.bottom.equalToSuperview().offset(Metric.groupLabelBottomMargin)
		}
		
		minusButton.snp.makeConstraints { make in
			make.size.equalTo(Metric.buttonSize)
		}
		
		plusButton.snp.makeConstraints { make in
			make.size.equalTo(Metric.buttonSize)
		}
		
		selectingGroupCountLabel.snp.makeConstraints { make in
			make.width.equalTo(Metric.countLabelWidth)
		}
		
		groupCountingStackView.snp.makeConstraints { make in
			make.centerY.equalTo(groupLabel.snp.centerY)
			make.trailing.equalToSuperview().offset(Metric.stackViewTrailingMargin)
		}
	}
}

// MARK: - Reactive Extension
extension Reactive where Base: TravelGroupExtendedView {
	var tapDecreaseButton: ControlEvent<Void> {
		let source: Observable<Void> = base.minusButton.rx.tap.asObservable()
		return ControlEvent(events: source)
	}
	
	var decreaseButtonEnable: Binder<Bool> {
		return Binder(base) { view, isEnable in
			view.minusButton.isEnabled = isEnable
		}
	}
	
	var tapIncreaseButton: ControlEvent<Void> {
		let source: Observable<Void> = base.plusButton.rx.tap.asObservable()
		return ControlEvent(events: source)
	}
	
	var increaseButtonEnable: Binder<Bool> {
		return Binder(base) { view, isEnable in
			view.plusButton.isEnabled = isEnable
		}
	}
	
	var counterValue: Binder<String> {
		return Binder(base) { view, text in
			view.selectingGroupCountLabel.text = text
		}
	}
}
