//
//  LoginViewController.swift
//  Login
//
//  Created by 구본의 on 2023/10/17.
//

import UIKit

import DesignSystem
import ResourceKit

import RxSwift
import SnapKit
import Then

public final class LoginViewController: UIViewController {
	private let rootView: LoginView = LoginView()
	private var emailLoginButton: SocialLoginButton { rootView.emailLoginButton }
	
	public override func loadView() {
		 view = rootView
	}
	
	private let disposeBag = DisposeBag()
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		setupGestures()
	}
}

private extension LoginViewController {
	func setupGestures() {
		emailLoginButton.rx.touchHandler()
			.bind { [weak self] in
				guard let self else { return }
				
				let EmailLoginViewController = EmailLoginViewController()
				let emailSiginUpNavi = EmailSiginUpNavigationController(
					rootViewController: EmailLoginViewController
				)
				emailSiginUpNavi.modalPresentationStyle = UIModalPresentationStyle.fullScreen
				self.present(emailSiginUpNavi, animated: true, completion: nil)
			}.disposed(by: disposeBag)
	}
}

