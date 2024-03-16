//
//  TravelSpotExtendedView.swift
//  SearchFilter
//
//  Created by 구본의 on 2023/11/19.
//

import UIKit

import DesignSystem
import ResourceKit

import RxCocoa
import RxRelay
import RxSwift
import SnapKit
import Then

final class TravelSpotExtendedView: UIView {
	
	// MARK: - METRIC
	private enum Metric {
		static let radius: CGFloat = 12
		
		static let stackViewSpacing: CGFloat = 24
		static let stackViewTopMargin: CGFloat = 24
		static let stackViewHorizontalMargin: CGFloat = 24
		
		static let subViewHorizontalMargin: CGFloat = 24
		static let locationContainerViewHeight: CGFloat = 50
		static let searchImageSize: CGFloat = 18
		static let searchLabelLeftMargin: CGFloat = 8
		
		static let popularSpotCollectionViewTopMargin: CGFloat = 8
		static let popularSpotCollectionViewBottomMargin: CGFloat = -30
		static let popularSpotCollectionViewHeight: CGFloat = 56
		static let popularSpotCollectionViewCellSize: CGSize = .init(width: 56, height: 56)
		static let popularSpotCollectionViewSpacing: CGFloat = 6
		static let popularSpotCollectionViewVerticalInset: CGFloat = 0
		static let popularSpotCollectionViewHorizontalInset: CGFloat = 20
	}
	
	private enum TextSet {
		static let titleLabelText: String = "게스트하우스 위치를 알려주세요"
		static let searchLabelText: String = "위치 검색"
		static let popularSearchLabelText: String = "인기 검색어"
	}
	
	// MARK: - UI PROPERTY
	private let titleLabel: UILabel = UILabel().then {
		$0.text = TextSet.titleLabelText
		$0.font = AppTheme.Font.Bold_20
		$0.textColor = AppTheme.Color.black
	}
	
	fileprivate let locationSearchContainerButton: UIButton = UIButton().then {
		$0.backgroundColor = AppTheme.Color.grey90
		$0.makeCornerRadius(Metric.radius)
	}
	
	private let searchImageView: UIImageView = UIImageView().then {
		$0.image = AppTheme.Image.search
		$0.tintColor = AppTheme.Color.black
	}
	
	fileprivate let searchLabel: UILabel = UILabel().then {
		$0.text = TextSet.searchLabelText
		$0.font = AppTheme.Font.Regular_12
		$0.textColor = AppTheme.Color.black
	}
	
	private let popularSearchLabel: UILabel = UILabel().then {
		$0.text = TextSet.popularSearchLabelText
		$0.font = AppTheme.Font.Regular_12
		$0.textColor = AppTheme.Color.black
	}
	
	private lazy var popularSpotCollectionView: UICollectionView = UICollectionView(
		frame: .zero,
		collectionViewLayout: .init()
	).then {
		$0.backgroundColor = AppTheme.Color.white
		$0.register(
			PopularTranvelSpotCollectionViewCell.self,
			forCellWithReuseIdentifier: PopularTranvelSpotCollectionViewCell.identifier
		)
		$0.bounces = false
		$0.showsHorizontalScrollIndicator = false
		$0.collectionViewLayout = makeCollectionViewLayout()
	}
	
	private lazy var stackView: UIStackView = UIStackView(
		arrangedSubviews: [
			titleLabel,
			locationSearchContainerButton,
			popularSearchLabel
		]).then {
			$0.axis = .vertical
			$0.spacing = Metric.stackViewSpacing
		}
	
	// MARK: - PROPERTY
	fileprivate let popularSpots: BehaviorRelay<[String]> = .init(value: [])
	fileprivate let selectedSpot: BehaviorRelay<String?> = .init(value: nil)
	
	private let disposeBag: DisposeBag = .init()
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupConfigure()
		setupSubViews()
		setupCollectionView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - PRIVATE METHOD
private extension TravelSpotExtendedView {
	func setupConfigure() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupSubViews() {
		addSubview(stackView)
		locationSearchContainerButton.addSubview(searchImageView)
		locationSearchContainerButton.addSubview(searchLabel)
		addSubview(popularSpotCollectionView)
		
		setupConstraints()
	}
	
	func setupConstraints() {
		stackView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(Metric.stackViewTopMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.subViewHorizontalMargin)
		}
		
		locationSearchContainerButton.snp.makeConstraints { make in
			make.height.equalTo(Metric.locationContainerViewHeight)
		}
		
		searchImageView.snp.makeConstraints { make in
			make.leading.equalToSuperview().offset(Metric.subViewHorizontalMargin)
			make.centerY.equalToSuperview()
			make.size.equalTo(Metric.searchImageSize)
		}
		
		searchLabel.snp.makeConstraints { make in
			make.leading.equalTo(self.searchImageView.snp.trailing).offset(Metric.searchLabelLeftMargin)
			make.trailing.equalToSuperview().offset(-Metric.subViewHorizontalMargin)
			make.centerY.equalToSuperview()
		}
		
		popularSpotCollectionView.snp.makeConstraints { make in
			make.top.equalTo(self.stackView.snp.bottom).offset(Metric.popularSpotCollectionViewTopMargin)
			make.bottom.equalToSuperview().offset(Metric.popularSpotCollectionViewBottomMargin)
			make.horizontalEdges.equalToSuperview()
			make.height.equalTo(Metric.popularSpotCollectionViewHeight)
		}
	}
}

// MARK: - COLLECTIONVIEW {
private extension TravelSpotExtendedView {
	func setupCollectionView() {
		popularSpots
			.observe(on: MainScheduler.instance)
			.bind(to: popularSpotCollectionView.rx.items(
				cellIdentifier: PopularTranvelSpotCollectionViewCell.identifier,
				cellType: PopularTranvelSpotCollectionViewCell.self)
			) { indexPath, spotInfo, cell in
				cell.updateValue(with: spotInfo, isSelected: indexPath % 2 == 0)
			}.disposed(by: disposeBag)
		
		Observable.zip(
			popularSpotCollectionView.rx.itemSelected,
			popularSpotCollectionView.rx.modelSelected(String.self)
		)
		.observe(on: MainScheduler.instance)
		.bind { [weak self] indexPath, spotInfo in
			guard let self else { return }
			self.selectedSpot.accept(spotInfo)
		}.disposed(by: disposeBag)
	}
	
	func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
		let configuration = UICollectionViewCompositionalLayoutConfiguration()
		configuration.scrollDirection = .horizontal
		configuration.interSectionSpacing = .zero
		let size: CGSize = Metric.popularSpotCollectionViewCellSize
		
		let layout = UICollectionViewCompositionalLayout(
			sectionProvider: { (_, _) -> NSCollectionLayoutSection? in
				let itemSize = NSCollectionLayoutSize(
					widthDimension: .absolute(size.width),
					heightDimension: .absolute(size.height)
				)
				let item = NSCollectionLayoutItem(layoutSize: itemSize)
				item.contentInsets = .zero
				
				let groupSize = NSCollectionLayoutSize(
					widthDimension: .absolute(size.width),
					heightDimension: .absolute(size.height)
				)
				let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
				let section = NSCollectionLayoutSection(group: group)
				section.interGroupSpacing = Metric.popularSpotCollectionViewSpacing
				section.contentInsets = NSDirectionalEdgeInsets(
					top: Metric.popularSpotCollectionViewVerticalInset,
					leading: Metric.popularSpotCollectionViewHorizontalInset,
					bottom: Metric.popularSpotCollectionViewVerticalInset,
					trailing: Metric.popularSpotCollectionViewHorizontalInset
				)
				return section
			}, configuration: configuration)
		
		return layout
	}
}

// MARK: - REACTIVE EXTENSION
extension Reactive where Base: TravelSpotExtendedView {
	var didTapLocationSearchContainer: ControlEvent<Void> {
		let source = base.locationSearchContainerButton.rx.touchHandler()
		return ControlEvent(events: source)
	}
	
	var popularSpotsRelay: Binder<[String]> {
		return Binder(base) { view, popularSpots in
			view.popularSpots.accept(popularSpots)
		}
	}
	
	var selectedSpot: Binder<String> {
		return Binder(base) { view, selectedSpot in
			view.searchLabel.text = selectedSpot
		}
	}
	
	var selectedSpotRelay: Observable<String?> {
		return base.selectedSpot.asObservable()
	}
}
