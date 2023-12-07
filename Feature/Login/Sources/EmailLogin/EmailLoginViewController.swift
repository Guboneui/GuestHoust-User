//
//  EmailLoginViewController.swift
//  Login
//
//  Created by 김민희 on 2023/11/01.
//

import UIKit

import DesignSystem
import ResourceKit

import RxSwift
import SnapKit
import Then

public final class EmailLoginViewController: UIViewController {
	private let rootView: EmailLoginView = EmailLoginView()
	private var headerSlideView: HeaderSlideView { rootView.headerSlideView }
	private var navigationBar: NavigationBar { rootView.navigationBar }
	private var loginButton: DefaultButton { rootView.loginButton }
	private var saveIdentifierCheckBox: UIButton { rootView.saveIdentifierCheckBox }
	private var saveIdentifierView: UIView { rootView.saveIdentifierView }
	private var emailSiginUpButton: UIButton { rootView.emailSiginUpButton }
	
	public override func loadView() {
		view = rootView
	}
	
	private let disposeBag = DisposeBag()
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		setupGestures()
	}
	
	public override func viewWillAppear(_ animated: Bool) {
		if let navigation = self.navigationController as? EmailSiginUpNavigationController {
			navigation.pageController.isHidden = true
			navigation.pageController.moveToFirstPage()
		}
	}
	
	public override func viewWillDisappear(_ animated: Bool) {
		if let navigation = self.navigationController as? EmailSiginUpNavigationController {
			navigation.pageController.isHidden = false
		}
	}
}

private extension EmailLoginViewController {
	func setupGestures() {
		navigationBar.rx.tapLeftButton
			.bind { [weak self] in
				guard let self else { return }
				self.dismiss(animated: true)
			}.disposed(by: disposeBag)
		
		saveIdentifierView.rx.tapGesture()
			.when(.recognized)
			.throttle(.milliseconds(300),
								latest: false,
								scheduler: MainScheduler.instance)
			.bind { [weak self] _ in
				guard let self else { return }
				self.saveIdentifierCheckBox.isSelected.toggle()
			}.disposed(by: disposeBag)

		loginButton.rx.touchHandler()
			.bind { [weak self] in
				guard let self else { return }
				self.headerSlideView.startAnimation(at: self)
			}.disposed(by: disposeBag)
		
		emailSiginUpButton.rx.touchHandler()
			.bind { [weak self] in
				guard let self else { return }
				let SiginUpTermsViewController: SiginUpTermsViewController = SiginUpTermsViewController()
				SiginUpTermsViewController.parentVC = self
				SiginUpTermsViewController.showModal()
			}.disposed(by: disposeBag)
	}
}
