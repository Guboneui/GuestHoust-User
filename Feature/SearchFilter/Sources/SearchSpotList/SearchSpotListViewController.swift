//
//  SearchSpotListViewController.swift
//  SearchFilter
//
//  Created by 구본의 on 2023/11/29.
//

import UIKit

import RxSwift

public final class SearchSpotListViewController: UIViewController {
	
	private let rootView: SearchSpotListView = SearchSpotListView()
	private let disposeBag: DisposeBag = .init()
	
	// MARK: - LIFE CYCLE
	public override func loadView() {
		self.view = rootView
	}
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		setupGestures()
	}
}

// MARK: - PRIVATE EXTENSION
private extension SearchSpotListViewController {
	private func setupGestures() {
		rootView.rx.didTapNavigationLeftButton
			.bind(onNext: { [weak self] in
				guard let self else { return }
				self.navigationController?.popViewController(animated: true)
			}).disposed(by: disposeBag)
	}
}
