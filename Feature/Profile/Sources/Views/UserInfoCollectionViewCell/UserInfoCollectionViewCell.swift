//
//  UserInfoCollectionViewCell.swift
//  Profile
//
//  Created by 구본의 on 2024/03/01.
//

import UIKit

import ResourceKit
import UtilityKit

final class UserInfoCollectionViewCell: UICollectionViewCell {
	// MARK: - Metric
	private enum Metric {
		static let horizontalMargin: CGFloat = 24.0
		static let profileImageViewSize: CGSize = .init(width: 82.0, height: 82.0)
		static let userLoginTypeImageViewSize: CGSize = .init(width: 16.0, height: 16.0)
		static let userEmailStackViewSpacing: CGFloat = 4
		static let userInfoVerticalStackViewSpacing: CGFloat = 8.0
		static let navigationButtonSize: CGSize = .init(width: 16.0, height: 16.0)
		static let userInfoStackViewSpacing: CGFloat = 16.0
		static let userInfoStackViewTopMargin: CGFloat = 20.0
		static let cellGroupEstimatedHeight: CGFloat = 126.0
	}
	
	// MARK: - UI Property
	private let profileImageView: UIImageView = UIImageView().then {
		$0.backgroundColor = AppTheme.Color.primary
		$0.makeCornerRadiusWithBorder(Metric.profileImageViewSize.height / 2.0)
	}
	
	private let nameLabel: UILabel = UILabel().then {
		$0.text = "구본의"
		$0.font = AppTheme.Font.Bold_16
		$0.textColor = AppTheme.Color.black
	}
	
	private let userLoginTypeImageView: UIImageView = UIImageView().then {
		$0.backgroundColor = AppTheme.Color.primary
	}
	
	private let userEmailLabel: UILabel = UILabel().then {
		$0.text = "starku2249@naver.com"
		$0.font = AppTheme.Font.Medium_12
		$0.textColor = AppTheme.Color.grey40
	}
	
	private lazy var userEmailStackView: UIStackView = UIStackView(
		arrangedSubviews: [
			userLoginTypeImageView,
			userEmailLabel
		]
	).then {
		$0.axis = .horizontal
		$0.spacing = Metric.userEmailStackViewSpacing
		$0.alignment = .center
	}
	
	private lazy var userInfoVerticalStackView: UIStackView = UIStackView(
		arrangedSubviews: [
			nameLabel,
			userEmailStackView
		]
	).then {
		$0.axis = .vertical
		$0.spacing = Metric.userInfoVerticalStackViewSpacing
	}
	
	private let navigationButton: UIButton = UIButton(type: .system).then {
		$0.setImage(AppTheme.Image.arrowRight, for: .normal)
		$0.tintColor = AppTheme.Color.grey40
	}
	
	private lazy var userInfoStackView: UIStackView = UIStackView(
		arrangedSubviews: [
			profileImageView,
			userInfoVerticalStackView,
			navigationButton
		]
	).then {
		$0.axis = .horizontal
		$0.spacing = Metric.userInfoStackViewSpacing
		$0.alignment = .center
	}
	
	// MARK: - Initialize
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupConfigures()
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Viewable
extension UserInfoCollectionViewCell: Viewable {
	func setupConfigures() {
		contentView.backgroundColor = AppTheme.Color.white
	}
	
	func setupViews() {
		contentView.addSubview(userInfoStackView)
		setupConstraints()
	}
	
	func setupConstraints() {
		profileImageView.snp.makeConstraints { make in
			make.size.equalTo(Metric.profileImageViewSize)
		}
		
		userLoginTypeImageView.snp.makeConstraints { make in
			make.size.equalTo(Metric.userLoginTypeImageViewSize)
		}
		
		navigationButton.snp.makeConstraints { make in
			make.size.equalTo(Metric.navigationButtonSize)
		}
		
		userInfoStackView.snp.makeConstraints { make in
			make.top.equalToSuperview().offset(Metric.userInfoStackViewTopMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
			make.bottom.equalToSuperview().offset(-24)
		}
	}
	
	func setupBinds() { }
}

// MARK: - UserInfoCollectionViewCell Compositonal Layout
extension UserInfoCollectionViewCell {
	static func cellLayout() -> NSCollectionLayoutSection {
		// MARK: Item
		let itemSize: NSCollectionLayoutSize = .init(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .fractionalHeight(1.0)
		)
		let item: NSCollectionLayoutItem = .init(layoutSize: itemSize)
		
		// MARK: Group
		let groupSize: NSCollectionLayoutSize = .init(
			widthDimension: .fractionalWidth(1.0),
			heightDimension: .estimated(Metric.cellGroupEstimatedHeight)
		)
		let group: NSCollectionLayoutGroup = .horizontal(
			layoutSize: groupSize,
			subitems: [item]
		)
		
		// MARK: Section
		let section: NSCollectionLayoutSection = .init(group: group)
		return section
	}
}
