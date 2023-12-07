//
//  EmailSiginUpNavigationController.swift
//  Login
//
//  Created by 김민희 on 2023/11/20.
//

import DesignSystem
import SnapKit
import UIKit

public class EmailSiginUpNavigationController: UINavigationController {
	public let pageController = PageController(
			pageCount: 4,
			defaultControllerSize: .init(width: 8, height: 8),
			selectedControllerHeight: 10
		)

	public override func viewDidLoad() {
		super.viewDidLoad()
		navigationBar.isHidden = true
		pageController.isHidden = true
		setupSubViews()
	}
	
	public func setupSubViews() {
		view.addSubview(pageController)
		setupLayouts()
	}
	
	public func setupLayouts() {
		pageController.snp.makeConstraints { make in
			make.top.equalTo(view.safeAreaLayoutGuide).offset(62)
			make.centerX.equalToSuperview()
		}
	}
}
