//
//  EmailSiginUpEmailViewController.swift
//  Login
//
//  Created by 김민희 on 2023/11/06.
//

import UIKit

import DesignSystem
import ResourceKit

import RxSwift
import SnapKit
import Then

public final class EmailSiginUpEmailViewController: UIViewController {
	private let rootView: EmailSiginUpEmailView = EmailSiginUpEmailView()
	private var navigationBar: NavigationBar { rootView.navigationBar }
	private var authCodeLabel: UILabel { rootView.authCodeLabel }
	private var resendAuthCodeLabel: UILabel { rootView.resendAuthCodeLabel }
	private var authCodeTextField: DefaultTextField { rootView.authCodeTextField }
	private var authCodeNoticeLabel: UILabel { rootView.authCodeNoticeLabel }
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

private extension EmailSiginUpEmailViewController {
	
	func setupGestures() {
		var emailAuth: Bool = false
		
		navigationBar.rx.tapLeftButton
			.bind { [weak self] in
				guard let self else { return }
				if let navigation = self.navigationController as? EmailSiginUpNavigationController {
					navigation.popViewController(animated: true)
				}
			}.disposed(by: disposeBag)
		
		nextButton.rx.touchHandler()
			.bind { [weak self] in
				guard let self else { return }
				if !emailAuth {
					self.authCodeLabel.isHidden = false
					self.resendAuthCodeLabel.isHidden = false
					self.authCodeTextField.isHidden = false
					self.authCodeNoticeLabel.isHidden = false
					self.nextButton.setTitle("다음", for: .normal)
					emailAuth = true
				} else {
					if let navigation = self.navigationController as? EmailSiginUpNavigationController {
						let EmailSiginUpPasswordViewController = EmailSiginUpPasswordViewController()
						navigation.pushViewController(EmailSiginUpPasswordViewController, animated: true)
						navigation.pageController.moveToNextPage()
					}
				}
			}.disposed(by: disposeBag)
	}
}
