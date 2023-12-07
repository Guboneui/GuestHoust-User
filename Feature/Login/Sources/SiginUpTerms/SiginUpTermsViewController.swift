//
//  SiginUpTermsViewController.swift
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

public final class SiginUpTermsViewController: UIViewController, DimModalPresentable {
	private let rootView: SiginUpTermsView = SiginUpTermsView()
	public var goSiginUpButton: DefaultButton { rootView.goSiginUpButton }
	public var parentVC: UIViewController?
	public var backgroundView: UIView { rootView.backgroundView }
	public var modalView: UIView { rootView.modalView }
	
	public override func loadView() {
		view = rootView
	}
	
	private let disposeBag = DisposeBag()
	
	public override func viewDidLoad() {
		super.viewDidLoad()
		setupGestures()
	}
}

private extension SiginUpTermsViewController {
	func setupGestures() {
		backgroundView.rx.tapGesture()
			.when(.recognized)
			.bind { [weak self] _ in
				guard let self else { return }
				self.hideModal()
			}.disposed(by: disposeBag)
		
		goSiginUpButton.rx.touchHandler()
			.bind { [weak self] in
				guard let self else { return }
				if let navigation = self.navigationController as? EmailSiginUpNavigationController {
					let EmailSiginUpViewController = EmailSiginUpEmailViewController()
					navigation.pushViewController(EmailSiginUpViewController, animated: true)
				}
				self.hideModal()
			}.disposed(by: disposeBag)
	}
}
