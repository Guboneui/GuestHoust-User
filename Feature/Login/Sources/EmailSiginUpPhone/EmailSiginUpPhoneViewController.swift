//
//  EmailSiginUpPhoneViewController.swift
//  Login
//
//  Created by 김민희 on 2023/11/08.
//

import UIKit

import DesignSystem
import ResourceKit

import RxSwift
import SnapKit
import Then

public class EmailSiginUpPhoneViewController: UIViewController {
	private let rootView: EmailSiginUpPhoneView = EmailSiginUpPhoneView()
	private var navigationBar: NavigationBar { rootView.navigationBar }
	private var nextButton: DefaultButton { rootView.nextButton }
	
	public override func loadView() {
		view = rootView
	}
	
	private let disposeBag = DisposeBag()
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		setupGestures()
	}
}

private extension EmailSiginUpPhoneViewController {
	func setupGestures() {
		navigationBar.rx.tapLeftButton
			.bind { [weak self] in
				guard let self else { return }
				if let navigation = self.navigationController as? EmailSiginUpNavigationController {
					navigation.popViewController(animated: true)
					navigation.pageController.moveToPrevPage()
				}
			}.disposed(by: disposeBag)
		
		nextButton.rx.touchHandler()
			.bind { [weak self] in
				guard let self else { return }
				if let navigation = self.navigationController as? EmailSiginUpNavigationController {
					navigation.popToRootViewController(animated: true)
				}
			}.disposed(by: disposeBag)
	}
}
