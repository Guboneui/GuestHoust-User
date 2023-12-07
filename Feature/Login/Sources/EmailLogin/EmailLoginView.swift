//
//  EmailLoginView.swift
//  Login
//
//  Created by 김민희 on 2023/11/18.
//

import UIKit

import DesignSystem
import ResourceKit

import SnapKit
import Then

public final class EmailLoginView: UIView {
	private enum Metric {
		static let emailLoginLabelTopMargin: CGFloat = 24
		static let emailLoginLabelLeftMargin: CGFloat = 24
		static let loginTextFieldHorzontalMargin: CGFloat = 24
		static let emailTextFieldTopMargin: CGFloat = 28
		static let passwordTextFieldTopMargin: CGFloat = 18
		static let loginButtonTopMargin: CGFloat = 30
		static let loginButtonHorzontalMargin: CGFloat = 24
		static let saveIdentifierCheckBoxSize: CGFloat = 16
		static let saveIdentifierCheckBoxTopMargin: CGFloat = 12
		static let saveIdentifierCheckBoxLeftMargin: CGFloat = 4
		static let saveIdentifierLabelLeftMargin: CGFloat = 8
		static let findPasswordLabelRightMargin: CGFloat = -4
		static let loginStackViewInset: CGFloat = 103
		static let loginStackViewBottomMargin: CGFloat = -28
		static let siginUpStackViewBottomMargin: CGFloat = -30
		static let siginUpStackViewspacing: CGFloat = 7
	}
	
	private enum TextSet {
		static let loginButtonText: String = "로그인"
		static let emailSiginUpButtonText: String = "이메일로 가입하기"
		static let emailLoginLabelText: String = "이메일 로그인"
		static let saveIdentifierLabelText: String = "이메일 기억하기"
		static let findPasswordLabelText: String = "비밀번호 찾기"
		static let siginUpLabelText: String = "아직 게하 회원이 아니신가요?"
	}
	
	private(set) var headerSlideView: HeaderSlideView = HeaderSlideView(.loginError)
	private(set) var navigationBar: NavigationBar = NavigationBar(.close)
	private(set) var loginButton: DefaultButton = DefaultButton(
		title: TextSet.loginButtonText,
		initEnableState: true
	)
	private(set) var saveIdentifierCheckBox: UIButton = UIButton().then {
		$0.setImage(AppTheme.Image.checkBoxOff, for: .normal)
		$0.setImage(AppTheme.Image.checkBoxOn, for: .selected)
	}
	private(set) var saveIdentifierView: UIView = UIView()
	private(set) var emailSiginUpButton: UIButton = UIButton().then {
		$0.setTitle(TextSet.emailSiginUpButtonText, for: .normal)
		$0.setTitleColor(AppTheme.Color.black, for: .normal)
		$0.titleLabel?.font = AppTheme.Font.Bold_14
	}
	
	private let emailLoginLabel: UILabel = UILabel().then {
		$0.text = TextSet.emailLoginLabelText
		$0.font = AppTheme.Font.Bold_20
		$0.textColor = AppTheme.Color.black
	}
	
	private let emailTextField: IconBorderTextField = IconBorderTextField(.email)
	private let passwordTextField: IconBorderTextField = IconBorderTextField(.password)
	
	private let saveIdentifierLabel: UILabel = UILabel().then {
		$0.text = TextSet.saveIdentifierLabelText
		$0.font = AppTheme.Font.Regular_12
		$0.textColor = AppTheme.Color.black
	}
	
	private let findPasswordLabel: UILabel = UILabel().then {
		$0.text = TextSet.findPasswordLabelText
		$0.font = AppTheme.Font.Regular_12
		$0.textColor = AppTheme.Color.black
	}
	
	private lazy var loginStackView: UIStackView = UIStackView().then {
		$0.axis = .horizontal
		$0.distribution = .equalSpacing
	}
	
	private let naverLoginButton: SocialLoginButton = SocialLoginButton(.naver)
	private let kakaoLoginButton: SocialLoginButton = SocialLoginButton(.kakao)
	private let appleLoginButton: SocialLoginButton = SocialLoginButton(.apple)
	
	private let siginUpStackView: UIStackView = UIStackView().then {
		$0.axis = .horizontal
		$0.spacing = Metric.siginUpStackViewspacing
	}
	
	private let siginUpLabel: UILabel = UILabel().then {
		$0.text = TextSet.siginUpLabelText
		$0.font = AppTheme.Font.Regular_14
		$0.textColor = AppTheme.Color.black
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
		navigationBar.snp.makeConstraints { make in
			make.top.equalTo(safeAreaLayoutGuide)
			make.horizontalEdges.equalToSuperview()
		}
		
		emailLoginLabel.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom).offset(Metric.emailLoginLabelTopMargin)
			make.leading.equalToSuperview().offset(Metric.emailLoginLabelLeftMargin)
		}
		
		emailTextField.snp.makeConstraints { make in
			make.top.equalTo(emailLoginLabel.snp.bottom).offset(Metric.emailTextFieldTopMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.loginTextFieldHorzontalMargin)
		}
		
		passwordTextField.snp.makeConstraints { make in
			make.top.equalTo(emailTextField.snp.bottom).offset(Metric.passwordTextFieldTopMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.loginTextFieldHorzontalMargin)
		}
		
		loginButton.snp.makeConstraints { make in
			make.top.equalTo(passwordTextField.snp.bottom).offset(Metric.loginButtonTopMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.loginButtonHorzontalMargin)
		}
		
		saveIdentifierCheckBox.snp.makeConstraints { make in
			make.size.equalTo(Metric.saveIdentifierCheckBoxSize)
			make.top.equalTo(loginButton.snp.bottom).offset(Metric.saveIdentifierCheckBoxTopMargin)
			make.leading.equalTo(loginButton.snp.leading).offset(Metric.saveIdentifierCheckBoxLeftMargin)
		}
		
		saveIdentifierLabel.snp.makeConstraints { make in
			make.centerY.equalTo(saveIdentifierCheckBox.snp.centerY)
			make.leading.equalTo(saveIdentifierCheckBox.snp.trailing)
				.offset(Metric.saveIdentifierLabelLeftMargin)
		}
		
		saveIdentifierView.snp.makeConstraints { make in
			make.top.equalTo(saveIdentifierCheckBox.snp.top)
			make.bottom.equalTo(saveIdentifierCheckBox.snp.bottom)
			make.leading.equalTo(saveIdentifierCheckBox.snp.leading)
			make.trailing.equalTo(saveIdentifierLabel.snp.trailing)
		}
		
		findPasswordLabel.snp.makeConstraints { make in
			make.centerY.equalTo(saveIdentifierCheckBox.snp.centerY)
			make.trailing.equalTo(loginButton.snp.trailing).offset(Metric.findPasswordLabelRightMargin)
		}
		
		siginUpStackView.snp.makeConstraints { make in
			make.centerX.equalToSuperview()
			make.bottom.equalTo(safeAreaLayoutGuide).offset(Metric.siginUpStackViewBottomMargin)
		}
		
		loginStackView.snp.makeConstraints { make in
			make.horizontalEdges.equalToSuperview().inset(Metric.loginStackViewInset)
			make.bottom.equalTo(siginUpLabel.snp.top).offset(Metric.loginStackViewBottomMargin)
		}
		
		super.updateConstraints()
	}
}

private extension EmailLoginView {
	func setupViews() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupSubViews() {
		addSubview(navigationBar)
		addSubview(emailLoginLabel)
		addSubview(emailTextField)
		addSubview(passwordTextField)
		addSubview(loginButton)
		addSubview(saveIdentifierCheckBox)
		addSubview(saveIdentifierLabel)
		addSubview(saveIdentifierView)
		addSubview(findPasswordLabel)
		addSubview(loginStackView)
		addSubview(siginUpStackView)
		
		loginStackView.addArrangedSubview(naverLoginButton)
		loginStackView.addArrangedSubview(kakaoLoginButton)
		loginStackView.addArrangedSubview(appleLoginButton)
		siginUpStackView.addArrangedSubview(siginUpLabel)
		siginUpStackView.addArrangedSubview(emailSiginUpButton)
	}
}
