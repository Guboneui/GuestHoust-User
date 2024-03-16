//
//  SearchSpotListView.swift
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

final class SearchSpotListView: UIView {
	
	// MARK: - METRIC
	private enum Metric {
		static let modalViewRadius: CGFloat = 22
		static let modalViewTopMargin: CGFloat = 22
		static let searchSpotTextFieldTopMargin: CGFloat = 24
		static let searchSpotTextFieldHorizontalMargin: CGFloat = 24
	}
	
	// MARK: - TEXT SET
	private enum TextSet {
		static let navigationTitle: String = "필터"
		static let textFiledPlaceHolder: String = "위치 검색"
	}
	
	fileprivate let navigationBar: NavigationBar = NavigationBar(
		.back,
		title: TextSet.navigationTitle,
		hasGuideLine: true
	)
	
	private let containerView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.grey90
	}
	
	private let modalView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.white
		$0.makeCornerRadius(
			Metric.modalViewRadius,
			edge: .onlyTop
		)
	}
	
	private let searchSpotTextField: IconTextField = .init(
		icon: AppTheme.Image.search,
		placeHolder: TextSet.textFiledPlaceHolder
	)
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViewConfigure()
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

private extension SearchSpotListView {
	func setupViewConfigure() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupViews() {
		addSubview(navigationBar)
		addSubview(containerView)
		containerView.addSubview(modalView)
		modalView.addSubview(searchSpotTextField)
		
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
		
		modalView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(Metric.modalViewTopMargin)
			make.horizontalEdges.equalToSuperview()
			make.bottom.equalToSuperview()
		}
		
		searchSpotTextField.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(Metric.searchSpotTextFieldTopMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.searchSpotTextFieldHorizontalMargin)
		}
	}
}

extension Reactive where Base: SearchSpotListView {
	var didTapNavigationLeftButton: ControlEvent<Void> {
		let source = base.navigationBar.rx.tapLeftButton.asObservable()
		return ControlEvent(events: source)
	}
}
