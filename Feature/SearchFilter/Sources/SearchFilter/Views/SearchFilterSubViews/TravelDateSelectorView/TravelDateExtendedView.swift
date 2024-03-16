//
//  TravelDateExtendedView.swift
//  SearchFilter
//
//  Created by 구본의 on 2023/12/06.
//

import UIKit

import DesignSystem
import ResourceKit
import UtilityKit

import HorizonCalendar
import RxCocoa
import RxSwift
import SnapKit
import Then

final class TravelDateExtendedView: UIView {
	
	// MARK: - METRIC
	private enum Metric {
		static let radius: CGFloat = 12
		
		static let selectionContainerViewRadius: CGFloat = 24
		static let selectionContainerViewHeight: CGFloat = 48
		static let selectionContainerViewTopMargin: CGFloat = 16
		static let selectionContainerViewHorizontalMargin: CGFloat = 10
		static let selectionViewHeight: CGFloat = 32
		static let selectionViewRadius: CGFloat = 16
		static let containerViewBottomMargin: CGFloat = -20
		static let stackViewSpacing: CGFloat = 112
		static let topMargin: CGFloat = 24
		static let horizontalMargin: CGFloat = 22
		static let searchButtonBottomMargin: CGFloat = -44
		
		static let selectionViewMultiplied: CGFloat = 173.0 / 344.0
		
		static let animationTime: TimeInterval = 0.3
	}
	
	private enum TextSet {
		static let titleLabelText: String = "일정을 알려주세요"
		static let searchText: String = "검색하기"
		static let simpleSelectionButtonTitle: String = "간편 선택"
		static let periodSelectionButtonTitle: String = "기간 선택"
	}
	
	// MARK: - UI PROPERTY
	private let titleLabel: UILabel = UILabel().then {
		$0.text = TextSet.titleLabelText
		$0.font = AppTheme.Font.Bold_20
		$0.textColor = AppTheme.Color.black
	}
	
	private let selectionContainerView: UIView = UIView().then {
		$0.makeCornerRadius(Metric.selectionContainerViewRadius)
		$0.backgroundColor = AppTheme.Color.grey90
	}
	
	private let selectionView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.white
		$0.makeCornerRadius(Metric.selectionViewRadius)
	}
	
	fileprivate let simpleSelectionButton: UIButton = UIButton(type: .system).then {
		$0.setTitle(TextSet.simpleSelectionButtonTitle, for: .normal)
		$0.titleLabel?.font = AppTheme.Font.Bold_12
		$0.tintColor = AppTheme.Color.black
	}
	
	fileprivate let periodSelectionButton: UIButton = UIButton(type: .system).then {
		$0.setTitle(TextSet.periodSelectionButtonTitle, for: .normal)
		$0.titleLabel?.font = AppTheme.Font.Bold_12
		$0.tintColor = AppTheme.Color.black
	}
	
	private lazy var selectionStackView: UIStackView = UIStackView(
		arrangedSubviews: [
			simpleSelectionButton,
			periodSelectionButton
		]).then {
			$0.axis = .horizontal
			$0.spacing = Metric.stackViewSpacing
		}
	
	private var calendarView: CalendarView?
	
	private let containerView: UIView = UIView().then {
		$0.backgroundColor = .blue
	}
	
	fileprivate let searchButton: DefaultButton = DefaultButton(title: TextSet.searchText)
	
	// MARK: - PROPERTY
	fileprivate let popularSpots: BehaviorRelay<[String]> = .init(value: [])
	fileprivate let selectedSpot: BehaviorRelay<String?> = .init(value: nil)
	
	private let disposeBag: DisposeBag = .init()
	
	private var state: PublishSubject<Bool> = .init()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		guard let content = makeContent() else { return }
		self.calendarView = .init(initialContent: content)
		setupConfigures()
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Viewable METHOD
extension TravelDateExtendedView: Viewable {
	func setupConfigures() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupViews() {
		addSubview(titleLabel)
		addSubview(selectionContainerView)
		selectionContainerView.addSubview(selectionView)
		selectionContainerView.addSubview(selectionStackView)
		addSubview(calendarView ?? containerView)
		addSubview(searchButton)
		
		setupConstraints()
	}
	
	func setupConstraints() {
		titleLabel.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(Metric.topMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
		}
		
		selectionContainerView.snp.makeConstraints { make in
			make.top.equalTo(titleLabel.snp.bottom).offset(Metric.selectionContainerViewTopMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.selectionContainerViewHorizontalMargin)
			make.height.equalTo(Metric.selectionContainerViewHeight)
		}
		
		selectionView.snp.makeConstraints { make in
			make.center.equalTo(simpleSelectionButton.snp.center)
			make.height.equalTo(Metric.selectionViewHeight)
			make.width.equalTo(selectionContainerView.snp.width)
				.multipliedBy(Metric.selectionViewMultiplied)
		}
		
		selectionStackView.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
		
		if let calendarView {
			calendarView.snp.makeConstraints { make in
				make.top.equalTo(selectionContainerView.snp.bottom).offset(Metric.topMargin)
				make.horizontalEdges.equalToSuperview()
				make.bottom.equalTo(searchButton.snp.top).offset(Metric.containerViewBottomMargin)
			}
		} else {
			containerView.snp.makeConstraints { make in
				make.top.equalTo(selectionContainerView.snp.bottom).offset(Metric.topMargin)
				make.horizontalEdges.equalToSuperview()
				make.bottom.equalTo(searchButton.snp.top).offset(Metric.containerViewBottomMargin)
			}
		}
		
		searchButton.snp.makeConstraints { make in
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
			make.bottom.equalToSuperview().offset(Metric.searchButtonBottomMargin)
		}
	}
	
	func setupBinds() {
		state
			.distinctUntilChanged()
			.observe(on: MainScheduler.instance)
			.bind { currentState in
				if currentState {
					UIView.animate(withDuration: Metric.animationTime, animations: {
						self.selectionView.snp.remakeConstraints { make in
							make.center.equalTo(self.simpleSelectionButton.snp.center)
							make.height.equalTo(Metric.selectionViewHeight)
							make.width.equalTo(self.selectionContainerView.snp.width)
								.multipliedBy(Metric.selectionViewMultiplied)
						}
						self.layoutIfNeeded()
					})
				} else {
					UIView.animate(withDuration: Metric.animationTime, animations: {
						self.selectionView.snp.remakeConstraints { make in
							make.center.equalTo(self.periodSelectionButton.snp.center)
							make.height.equalTo(Metric.selectionViewHeight)
							make.width.equalTo(self.selectionContainerView.snp.width)
								.multipliedBy(Metric.selectionViewMultiplied)
						}
						self.layoutIfNeeded()
					})
				}
			}.disposed(by: disposeBag)
		
		simpleSelectionButton.rx.touchHandler()
			.bind { [weak self] in
				guard let self else { return }
				self.state.onNext(true)
			}.disposed(by: disposeBag)
		
		periodSelectionButton.rx.touchHandler()
			.bind { [weak self] in
				guard let self else { return }
				self.state.onNext(false)
			}.disposed(by: disposeBag)
		
	}
}

// MARK: - Calendar Method
private extension TravelDateExtendedView {
	private func makeContent() -> CalendarViewContent? {
		let calendar = Calendar.current
		let currentYear: Int = calendar.component(.year, from: .now)
		let currentMonth: Int = calendar.component(.month, from: .now)
		
		guard
			let afterSixMonthFromNow = calendar.date(byAdding: .month, value: 6, to: .now),
			let range = calendar.range(of: .day, in: .month, for: afterSixMonthFromNow),
			let startDate = calendar.date(
				from: DateComponents(
					year: currentYear,
					month: currentMonth,
					day: 01
				)
			),
			let endDate = calendar.date(
				from: DateComponents(
					year: calendar.component(.year, from: afterSixMonthFromNow),
					month: calendar.component(.month, from: afterSixMonthFromNow),
					day: range.count
				)
			)
		else {
			return nil
		}

		return CalendarViewContent(
			calendar: calendar,
			visibleDateRange: startDate...endDate,
			monthsLayout: .vertical(options: VerticalMonthsLayoutOptions())
		)
		.dayItemProvider { day in
			DayLabel.calendarItemModel(
				invariantViewProperties: .init(
					font: AppTheme.Font.Bold_12,
					textColor: AppTheme.Color.black,
					backgroundColor: AppTheme.Color.white
				),
				content: .init(day: day)
			)
		}
		.monthHeaderItemProvider { month in
			MonthLabel.calendarItemModel(
				invariantViewProperties: .init(
					font: AppTheme.Font.Bold_14,
					textColor: AppTheme.Color.black,
					backgroundColor: AppTheme.Color.white
				),
				content: .init(month: month)
			)
		}
	}
}

// MARK: - REACTIVE EXTENSION
extension Reactive where Base: TravelDateExtendedView {
	var didTapSearchDateButton: ControlEvent<Void> {
		let source: Observable<Void> = base.searchButton.rx.tap.asObservable()
		return ControlEvent(events: source)
	}
}
