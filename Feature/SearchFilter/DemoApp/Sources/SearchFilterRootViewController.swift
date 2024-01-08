//
//  SearchFilterRootViewController.swift
//  SearchFilterDemoApp
//
//  Created by 구본의 on 2023/11/19.
//

import UIKit

import SearchFilter

import DesignSystem
import ResourceKit

import RxSwift
import SnapKit
import Then

final class SearchFilterRootViewController: UIViewController {
	
	// MARK: - METRIC
	private enum Metric {
		static let buttonSize: CGSize = .init(width: 120, height: 120)
	}
	
	// MARK: - UI PROPERTY
	private let button: UIButton = UIButton(type: .system).then {
		$0.setTitle("PRESENT", for: .normal)
		$0.tintColor = AppTheme.Color.white
		$0.titleLabel?.font = AppTheme.Font.Bold_14
		$0.backgroundColor = AppTheme.Color.primary
	}
	
	// MARK: - PRIVATE PROPERTY
	private let disposeBag: DisposeBag = DisposeBag()
	
	// MARK: - LIFE CYCLE
	override func viewDidLoad() {
		super.viewDidLoad()
		setupViewConfigure()
		setupViews()
		setupGestures()
	}
}

private extension SearchFilterRootViewController {
	
	func setupViewConfigure() {
		view.backgroundColor = AppTheme.Color.white
	}
	
	func setupViews() {
		view.addSubview(button)
		setupConstraints()
	}
	
	func setupConstraints() {
		button.snp.makeConstraints { make in
			make.center.equalToSuperview()
			make.size.equalTo(Metric.buttonSize)
		}
	}
	
	func setupGestures() {
		button.rx.touchHandler()
			.bind { [weak self] in
				guard let self else { return }
				let filterSearchViewController = SearchFilterViewController()
				filterSearchViewController.reactor = SearchFilterViewReactor()
				let navigation = UINavigationController(rootViewController: filterSearchViewController)
				navigation.modalPresentationStyle = .overFullScreen
				navigation.navigationBar.isHidden = true
				self.present(navigation, animated: true)
			}.disposed(by: disposeBag)
	}
}
