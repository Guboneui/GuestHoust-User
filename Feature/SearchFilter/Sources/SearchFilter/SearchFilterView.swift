//
//  SearchFilterView.swift
//  SearchFilter
//
//  Created by 구본의 on 2023/11/27.
//

import UIKit

import DesignSystem
import ResourceKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class SearchFilterView: UIView {
	
	// MARK: - METRIC
	private enum Metric {
		static let radius: CGFloat = 16
		static let animationStackViewSpcing: CGFloat = 0
		static let guideLineHeight: CGFloat = 1.0
		
		static let travelViewVerticalMargin: CGFloat = 22
		static let verticalMargin: CGFloat = 16
		static let horizontalMargin: CGFloat = 14
		static let extendedDateViewBottomMargin: CGFloat = -24
		
		static let bottomButtonTopMargin: CGFloat = 12
		static let bottomButtonHorizontalMargin: CGFloat = 20
		static let bottomButtonBottomMargin: CGFloat = UIDevice.hasNotch ? -66 : -32
		
		static let animationTime: TimeInterval = 0.3
	}
	
	// MARK: - TEXT SET
	private enum TextSet {
		static let navigationTitle: String = "필터"
		static let leftButtonTitle: String = "선택 취소"
		static let rightButtonTitle: String = "검색"
	}
	
	// MARK: - UI PROPERTY
	fileprivate let navigationBar: NavigationBar = NavigationBar(
		.close,
		title: TextSet.navigationTitle,
		hasGuideLine: true
	)
	
	private let containerView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.grey90
	}
	
	fileprivate let travelSpotDefaultView: TravelSpotDefaultView = .init()
	fileprivate let travelSpotExtendedView: TravelSpotExtendedView = .init()
	private lazy var travelSpotStackView: UIStackView = UIStackView(
		arrangedSubviews: [
			travelSpotDefaultView,
			travelSpotExtendedView
		]).then {
			$0.backgroundColor = AppTheme.Color.white
			$0.axis = .vertical
			$0.spacing = Metric.animationStackViewSpcing
			$0.makeCornerRadiusWithBorder(Metric.radius)
			$0.clipsToBounds = true
		}
	
	fileprivate let travelDateDefaultView: TravelDateDefaultView = .init()
	fileprivate let travelDateExtendedView: TravelDateExtendedView = .init()
	private lazy var travelDateStackView: UIStackView = UIStackView(
		arrangedSubviews: [
			travelDateDefaultView,
			travelDateExtendedView
		]).then {
			$0.backgroundColor = AppTheme.Color.white
			$0.axis = .vertical
			$0.spacing = Metric.animationStackViewSpcing
			$0.makeCornerRadiusWithBorder(Metric.radius)
			$0.clipsToBounds = true
		}
	
	fileprivate let travelGroupDefaultView: TravelGroupDefaultView = .init()
	fileprivate let travelGroupExtendedView: TravelGroupExtendedView = .init()
	private lazy var travelGroupStackView: UIStackView = UIStackView(
		arrangedSubviews: [
			travelGroupDefaultView,
			travelGroupExtendedView
		]).then {
			$0.backgroundColor = AppTheme.Color.white
			$0.axis = .vertical
			$0.spacing = Metric.animationStackViewSpcing
			$0.makeCornerRadiusWithBorder(Metric.radius)
			$0.clipsToBounds = true
		}
	
	private let bottomContainerView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.white
	}
	
	private let bottomContainerGuideLineView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.grey70
	}
	
	fileprivate let bottomButton: TwoButton = TwoButton(
		sizeType: .rightLarger,
		buttonType: (.origin, .primary),
		leftButtonTitle: TextSet.leftButtonTitle,
		rightButtonTitle: TextSet.rightButtonTitle
	)
	
	// MARK: - INITIALIZE
	public override init(frame: CGRect) {
		super.init(frame: frame)
		setupViewConfigure()
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public func updateExtendedState(with state: SearchFilterExtendedState) {
		switch state {
		case .travelSpot:
			updateView(travelSpotDefaultView, travelSpotExtendedView, isExtended: true)
			updateView(travelDateDefaultView, travelDateExtendedView, isExtended: false)
			updateView(travelGroupDefaultView, travelGroupExtendedView, isExtended: false)
		case .travelDate:
			updateView(travelSpotDefaultView, travelSpotExtendedView, isExtended: false)
			updateView(travelDateDefaultView, travelDateExtendedView, isExtended: true)
			updateView(travelGroupDefaultView, travelGroupExtendedView, isExtended: false)
		case .travelGroup:
			updateView(travelSpotDefaultView, travelSpotExtendedView, isExtended: false)
			updateView(travelDateDefaultView, travelDateExtendedView, isExtended: false)
			updateView(travelGroupDefaultView, travelGroupExtendedView, isExtended: true)
		}
		updateBottomView(with: state)
	}
	
	private func updateBottomView(with state: SearchFilterExtendedState) {
		UIView.animate(withDuration: Metric.animationTime, animations: {
			switch state {
			case .travelDate:
				self.travelDateStackView.snp.remakeConstraints { make in
					make.top.equalTo(self.travelSpotStackView.snp.bottom).offset(Metric.verticalMargin)
					make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
					make.bottom.equalToSuperview().offset(Metric.extendedDateViewBottomMargin)
				}
				
				self.bottomContainerView.snp.remakeConstraints { make in
					make.horizontalEdges.equalToSuperview()
					make.top.equalTo(self.snp.bottom)
				}
				
				self.travelGroupStackView.isHidden = true
				
			default:
				self.travelDateStackView.snp.remakeConstraints { make in
					make.top.equalTo(self.travelSpotStackView.snp.bottom).offset(Metric.verticalMargin)
					make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
				}
				
				self.bottomContainerView.snp.remakeConstraints { make in
					make.horizontalEdges.equalToSuperview()
					make.bottom.equalToSuperview()
				}
				
				self.travelGroupStackView.isHidden = false
			}
			self.layoutIfNeeded()
		})
	}
}

// MARK: - PRIVATE METHOD
private extension SearchFilterView {
	func setupViewConfigure() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupViews() {
		addSubview(navigationBar)
		addSubview(containerView)
		containerView.addSubview(travelSpotStackView)
		containerView.addSubview(travelDateStackView)
		containerView.addSubview(travelGroupStackView)
		containerView.addSubview(bottomContainerView)
		bottomContainerView.addSubview(bottomContainerGuideLineView)
		bottomContainerView.addSubview(bottomButton)
		
		setupConstraints()
	}
	
	func setupConstraints() {
		navigationBar.snp.makeConstraints { make in
			make.top.equalTo(safeAreaLayoutGuide)
			make.horizontalEdges.equalToSuperview()
		}
		
		containerView.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom)
			make.horizontalEdges.equalToSuperview()
			make.bottom.equalToSuperview()
		}
		
		travelSpotStackView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(Metric.travelViewVerticalMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
		}
		
		travelDateStackView.snp.makeConstraints { make in
			make.top.equalTo(travelSpotStackView.snp.bottom).offset(Metric.verticalMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
		}
		
		travelGroupStackView.snp.makeConstraints { make in
			make.top.equalTo(travelDateStackView.snp.bottom).offset(Metric.verticalMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
		}
		
		bottomContainerView.snp.makeConstraints { make in
			make.bottom.equalToSuperview()
			make.horizontalEdges.equalToSuperview()
		}
		
		bottomContainerGuideLineView.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.horizontalEdges.equalToSuperview()
			make.height.equalTo(Metric.guideLineHeight)
		}
		
		bottomButton.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(Metric.bottomButtonTopMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.bottomButtonHorizontalMargin)
			make.bottom.equalToSuperview().offset(Metric.bottomButtonBottomMargin)
		}
		
		layoutIfNeeded()
	}
	
	func updateView(_ defaultView: UIView, _ extendedView: UIView, isExtended: Bool) {
		defaultView.alpha = isExtended ? 0 : 1.0
		defaultView.isHidden = isExtended
		extendedView.alpha = isExtended ? 1.0 : 0
		extendedView.isHidden = !isExtended
	}
}

// MARK: - Reactive Extension
extension Reactive where Base: SearchFilterView {
	var didTapNavigationLeftButton: ControlEvent<Void> {
		let source = base.navigationBar.rx.tapLeftButton.asObservable()
		return ControlEvent(events: source)
	}
	
	var didTapBottomLeftButton: ControlEvent<Void> {
		let source = base.bottomButton.rx.tapLeftButton.asObservable()
		return ControlEvent(events: source)
	}
	
	var didTapBottomRightButton: ControlEvent<Void> {
		let source = base.bottomButton.rx.tapRightButton.asObservable()
		return ControlEvent(events: source)
	}
	
	// MARK: - Travel Spot
	var didTapTravelSpotDefaultView: ControlEvent<Void> {
		let source = base.travelSpotDefaultView.rx.tapGesture().when(.recognized).map { _ in }
		return ControlEvent(events: source)
	}
	
	var didTapLocationSearchContainer: ControlEvent<Void> {
		let source = base.travelSpotExtendedView.rx.didTapLocationSearchContainer
		return ControlEvent(events: source)
	}
	
	var popularSpots: Binder<[String]> {
		return Binder(base) { view, popularSpots in
			view.travelSpotExtendedView.rx.popularSpotsRelay.onNext(popularSpots)
		}
	}
	
	var selectedSpotValueInDefaultView: Binder<String> {
		return base.travelSpotDefaultView.rx.selectedSpot
	}
	
	var selectedSpotValueInExtendedView: Binder<String> {
		return base.travelSpotExtendedView.rx.selectedSpot
	}
	
	var selectedSpotRelay: Observable<String?> {
		return base.travelSpotExtendedView.rx.selectedSpotRelay
	}
	
	// MARK: - Travel Date
	var didTapTravelDateDefaultView: ControlEvent<Void> {
		let source = base.travelDateDefaultView.rx.tapGesture().when(.recognized).map { _ in }
		return ControlEvent(events: source)
	}
	
	var didTapSearchDateButton: ControlEvent<Void> {
		return base.travelDateExtendedView.rx.didTapSearchDateButton
	}
	
	// MARK: - Travel Group
	var didTapTravelGroupDefaultView: ControlEvent<Void> {
		let source = base.travelGroupDefaultView.rx.tapGesture().when(.recognized).map { _ in }
		return ControlEvent(events: source)
	}
	
	var didTapDecreaseButton: ControlEvent<Void> {
		let source = base.travelGroupExtendedView.rx.tapDecreaseButton.asObservable()
		return ControlEvent(events: source)
	}
	
	var didTapIncreaseButton: ControlEvent<Void> {
		let source = base.travelGroupExtendedView.rx.tapIncreaseButton.asObservable()
		return ControlEvent(events: source)
	}
	
	var isEnableIncreaseButton: Binder<Bool> {
		return base.travelGroupExtendedView.rx.increaseButtonEnable
	}
	
	var isEnableDecreaseButton: Binder<Bool> {
		return base.travelGroupExtendedView.rx.decreaseButtonEnable
	}
	
	var groupCounterValueInDefaultView: Binder<String> {
		return base.travelGroupDefaultView.rx.counterValue
	}
	
	var groupCounterValueInExtendedView: Binder<String> {
		return base.travelGroupExtendedView.rx.counterValue
	}
}
