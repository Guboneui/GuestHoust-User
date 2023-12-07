//
//  LoginView.swift
//  Login
//
//  Created by 김민희 on 2023/11/21.
//

import UIKit

import DesignSystem
import ResourceKit

import SnapKit
import Then

public final class LoginView: UIView {
	private enum Metric {
		static let loginStackViewTop = 28
		static let loginStackViewInset = 52
	}
	
	private enum TextSet {
		static let loginLabelText: String = "로그인/회원가입"
	}
	
	private(set) var naverLoginButton: SocialLoginButton = SocialLoginButton(.naver)
	private(set) var kakaoLoginButton: SocialLoginButton = SocialLoginButton(.kakao)
	private(set) var appleLoginButton: SocialLoginButton = SocialLoginButton(.apple)
	private(set) var emailLoginButton: SocialLoginButton = SocialLoginButton(.email)
	
	private let logoView: UIView = UIView().then {
		$0.backgroundColor = .lightGray
	}
	
	private let loginLabel: UILabel = UILabel().then {
		$0.text = TextSet.loginLabelText
		$0.font = AppTheme.Font.Regular_14
		$0.textColor = AppTheme.Color.black
	}
	
	private let loginStackView: UIStackView = UIStackView().then {
		$0.axis = .horizontal
		$0.distribution = .equalSpacing
	}

	private var needUpdateConstrains: Bool = true
	
	override init(frame: CGRect) {
		super.init(frame: frame)
		setupViews()
		setupSubViews()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	public override func updateConstraints() {
		guard needUpdateConstrains else { return }
		needUpdateConstrains = false
		
		loginLabel.snp.makeConstraints { make in
			make.center.equalToSuperview()
		}
		
		// MARK: TODO 민희
		logoView.snp.makeConstraints { make in
			make.size.equalTo(100)
			make.height.width.equalTo(100)
			make.centerX.equalToSuperview()
			make.bottom.equalTo(loginLabel.snp.top).offset(-38)
		}
		
		loginStackView.snp.makeConstraints { make in
			make.horizontalEdges.equalToSuperview().inset(Metric.loginStackViewInset)
			make.top.equalTo(loginLabel.snp.bottom).offset(Metric.loginStackViewTop)
		}
		
		super.updateConstraints()
	}
}

private extension LoginView {
	func setupViews() {
		backgroundColor = AppTheme.Color.white
	}

	func setupSubViews() {
		addSubview(logoView)
		addSubview(loginLabel)
		addSubview(loginStackView)
		
		loginStackView.addArrangedSubview(naverLoginButton)
		loginStackView.addArrangedSubview(kakaoLoginButton)
		loginStackView.addArrangedSubview(appleLoginButton)
		loginStackView.addArrangedSubview(emailLoginButton)
	}
}
