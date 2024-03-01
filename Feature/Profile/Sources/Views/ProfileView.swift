//
//  ProfileView.swift
//  Profile
//
//  Created by 구본의 on 2024/03/01.
//

import UIKit

import DesignSystem
import ResourceKit
import UtilityKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class ProfileView: UIView {
	// MARK: - Typealias
	private typealias DataSource = UICollectionViewDiffableDataSource<Section, AnyHashable>
	private typealias SnapShot = NSDiffableDataSourceSnapshot<Section, AnyHashable>
	
	// MARK: - Section
	private enum Section {
		case userInfo
	}
	
  // MARK: - Metric
  
  // MARK: - TextSet
	private enum TextSet {
		static let navigationTitle: String = "마이페이지"
	}
  
  // MARK: - UI Property
	private let navigationBar: NavigationBar = .init(title: TextSet.navigationTitle)
	private lazy var collectionView: UICollectionView = .init(
		frame: .zero,
		collectionViewLayout: makeCollectionViewLayout()
	).then {
		$0.register(
			UserInfoCollectionViewCell.self,
			forCellWithReuseIdentifier: UserInfoCollectionViewCell.identifier
		)
		$0.bounces = false
		$0.backgroundColor = AppTheme.Color.white
	}
  
  // MARK: - Property
	private lazy var dataSource: DataSource = makeDataSource()
	private var currentSection: [Section] {
		dataSource.snapshot().sectionIdentifiers as [Section]
	}
	
  // MARK: - Initialize
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupConfigures()
    setupViews()
    setupBinds()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Public Method
	
	/// ProfileView의 CollectionView DataSource의 변경을 감지해 CollectionView를 업데이트 합니다.
	public func setupSnapShot(with viewModel: ProfileViewModel ) {
		var snapShot: SnapShot = .init()
		
		if let userInfo: [UserInfoCellectionViewCellViewModel] = viewModel.userInfo {
			snapShot.appendSections([.userInfo])
			snapShot.appendItems(userInfo, toSection: .userInfo)
		}
		
		dataSource.apply(snapShot)
	}
}

// MARK: - Viewable
extension ProfileView: Viewable {
  func setupConfigures() {
		backgroundColor = AppTheme.Color.white
  }
  
  func setupViews() {
		addSubview(navigationBar)
		addSubview(collectionView)
    setupConstraints()
  }
  
  func setupConstraints() {
		navigationBar.snp.makeConstraints { make in
			make.top.equalTo(safeAreaLayoutGuide)
			make.horizontalEdges.equalToSuperview()
		}
		
		collectionView.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom)
			make.horizontalEdges.equalToSuperview()
			make.bottom.equalToSuperview()
		}
  }
  
  func setupBinds() {
    
  }
}

// MARK: - CollectionView
extension ProfileView {
	/// ProfileView의 CollectionView Compositional Layout을 생성합니다.
	private func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
		UICollectionViewCompositionalLayout { [weak self] section, _ in
			switch self?.currentSection[section] {
			case .userInfo:
				return UserInfoCollectionViewCell.cellLayout()
			case .none:
				return nil
			}
		}
	}
	
	/// ProfileView의 CollectionView DiffableDataSource를 생성합니다.
	private func makeDataSource() -> DataSource {
		let dataSource: DataSource = .init(
			collectionView: collectionView,
			cellProvider: { [weak self] collectionView, indexPath, viewModel in
				guard let self else { return UICollectionViewCell() }
				switch self.currentSection[indexPath.section] {
				case .userInfo:
					return self.makeUserInfoCell(collectionView, indexPath, viewModel)
				}
			}
		)
		
		return dataSource
	}
	
	private func makeUserInfoCell(
		_ collectionView: UICollectionView,
		_ indexPath: IndexPath,
		_ viewModel: AnyHashable
	) -> UICollectionViewCell {
		guard 
			let cell: UserInfoCollectionViewCell = collectionView.dequeueReusableCell(
				withReuseIdentifier: UserInfoCollectionViewCell.identifier,
				for: indexPath
			) as? UserInfoCollectionViewCell
		else {
			return .init()
		}
		return cell
	}
}