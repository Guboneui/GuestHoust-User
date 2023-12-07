//
//  SiginUpTermsView.swift
//  Login
//
//  Created by 김민희 on 2023/11/21.
//

import UIKit

import DesignSystem
import ResourceKit

import SnapKit
import Then

final class SiginUpTermsView: UIView {
	private enum Metric {
		static let goSiginUpButtonHorzontalMargin: CFloat = 24
		static let goSiginUpButtonBottomMargin: CFloat = -34
		static let goSiginUpButtonTopMargin: CFloat = 330
	}
	
	private enum TextSet {
		static let goSiginUpButtonText: String = "동의하고 회원가입 계속하기"
	}
	
	private(set) var backgroundView: UIView = UIView()
	private(set) var modalView: UIView = UIView()
	
	private(set) var goSiginUpButton = DefaultButton(title: TextSet.goSiginUpButtonText)
	
	private var needUpdateConstrains: Bool = true
	
	override init(frame: CGRect) {
		super.init(frame: frame)

		setupSubViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func updateConstraints() {
		guard needUpdateConstrains else { return }
		needUpdateConstrains = false
		
		goSiginUpButton.snp.makeConstraints { make in
			make.horizontalEdges.equalToSuperview().inset(Metric.goSiginUpButtonHorzontalMargin)
			make.bottom.equalTo(modalView.safeAreaLayoutGuide).offset(Metric.goSiginUpButtonBottomMargin)
			make.topMargin.equalTo(Metric.goSiginUpButtonTopMargin)
		}
		
		super.updateConstraints()
	}
}

private extension SiginUpTermsView {
	func setupSubViews() {
		modalView.addSubview(goSiginUpButton)
	}
}
