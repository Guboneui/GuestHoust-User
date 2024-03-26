//
//  ChannelListView.swift
//  Chatting
//
//  Created by 김동겸 on 3/11/24.
//

import UIKit

import ResourceKit
import UtilityKit

final class ChannelListView: UIView {	
	// MARK: - UI Property
	private let compositionalLayout: UICollectionViewCompositionalLayout = {
		var listConfiguration = UICollectionLayoutListConfiguration(appearance: .plain)
		listConfiguration.showsSeparators = false
		listConfiguration.backgroundColor = AppTheme.Color.white
		let compositionalLayout = UICollectionViewCompositionalLayout.list(using: listConfiguration)
		return compositionalLayout
	}()
	
	public lazy var channelListCollectionView: UICollectionView = UICollectionView(
		frame: .zero,
		collectionViewLayout: compositionalLayout
	).then {
		$0.backgroundColor = AppTheme.Color.white
		$0.register(
			ChannelListCell.self,
			forCellWithReuseIdentifier: ChannelListCell.identifier
		)
	}
	
	// MARK: - Iitialize
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupConfigures()
		setupViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

// MARK: - Viewable METHOD
extension ChannelListView: Viewable {
	func setupConfigures() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupViews() {
		addSubview(channelListCollectionView)
		
		setupConstraints()
	}
	
	func setupConstraints() {
		channelListCollectionView.snp.makeConstraints { make in
			make.top.equalToSuperview()
			make.horizontalEdges.equalToSuperview()
			make.bottom.equalTo(safeAreaLayoutGuide)
		}
	}
	
	func setupBinds() { }
}
