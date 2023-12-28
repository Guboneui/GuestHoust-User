//
//  EmailSiginUpNameViewController.swift
//  Login
//
//  Created by 김민희 on 2023/11/07.
//

import UIKit

import DesignSystem
import ResourceKit

import RxSwift
import SnapKit
import Then

public final class EmailSiginUpNameViewController: UIViewController {
	private let rootView: EmailSiginUpNameView = EmailSiginUpNameView()
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

private extension EmailSiginUpNameViewController {
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
					let emailSiginUpPhoneViewController = EmailSiginUpPhoneViewController()
					navigation.pushViewController(emailSiginUpPhoneViewController, animated: true)
					navigation.pageController.moveToNextPage()
				}
			}.disposed(by: disposeBag)
	}
}
