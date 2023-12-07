//
//  EmailSiginUpPasswordView.swift
//  Login
//
//  Created by 김민희 on 2023/11/21.
//

import UIKit

import DesignSystem
import ResourceKit

import SnapKit
import Then

public final class EmailSiginUpPasswordView: UIView {
	private enum Metric {
		static let horizontalMargin: CGFloat = 24
		static let passwordLabelTopMargin: CGFloat = 38
		static let passwordTextFieldTopMargin: CGFloat = 8
		static let passwordConditionsLabelTopMargin: CGFloat = 8
		static let passwordConditionsLabelRightMargin: CGFloat = -8
		static let checkPasswordLabelTopMargin: CGFloat = 32
		static let checkPasswordTextFieldTopMargin: CGFloat = 8
		static let nextButtonBottomMargin: CGFloat = -34
	}
	
	private enum TextSet {
		static let navigationBarText: String = "회원가입"
		static let nextButtonText: String = "다음"
		static let passwordLabelText: String = "비밀번호"
		static let passwordConditionsLabelText: String = "영문+숫자+특수문자 8~20자리"
		static let checkPasswordLabelText: String = "비밀번호 확인"
		static let checkPasswordConditionsLabelText: String = "영문+숫자+특수문자 8~20자리"
	}
	
	private(set) var navigationBar: NavigationBar = NavigationBar(
		.back,
		title: TextSet.navigationBarText
	)
	private(set) var nextButton: DefaultButton = DefaultButton(
		title: TextSet.nextButtonText,
		initEnableState: true
	)
	
	private let passwordLabel: UILabel = UILabel().then {
		$0.text = TextSet.passwordLabelText
		$0.font = AppTheme.Font.Bold_16
		$0.textColor = AppTheme.Color.black
	}
	
	private let passwordTextField: DefaultTextField = DefaultTextField(.password)
	
	private let passwordConditionsLabel: UILabel = UILabel().then {
		$0.text = TextSet.passwordConditionsLabelText
		$0.font = AppTheme.Font.Regular_12
		$0.textColor = AppTheme.Color.grey70
	}
	
	private let checkPasswordLabel: UILabel = UILabel().then {
		$0.text = TextSet.checkPasswordLabelText
		$0.font = AppTheme.Font.Bold_16
		$0.textColor = AppTheme.Color.black
	}
	
	private let checkPasswordTextField: DefaultTextField = DefaultTextField(.password)
	
	private let checkPasswordConditionsLabel: UILabel = UILabel().then {
		$0.text = TextSet.checkPasswordConditionsLabelText
		$0.font = AppTheme.Font.Regular_12
		$0.textColor = AppTheme.Color.grey70
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
		
		passwordLabel.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom).offset(Metric.passwordLabelTopMargin)
			make.leading.equalToSuperview().offset(Metric.horizontalMargin)
		}
		
		passwordTextField.snp.makeConstraints { make in
			make.top.equalTo(passwordLabel.snp.bottom).offset(Metric.passwordTextFieldTopMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
		}
		
		passwordConditionsLabel.snp.makeConstraints { make in
			make.top.equalTo(passwordTextField.snp.bottom)
				.offset(Metric.passwordConditionsLabelTopMargin)
			make.trailing.equalTo(passwordTextField.snp.trailing)
				.offset(Metric.passwordConditionsLabelRightMargin)
		}
		
		checkPasswordLabel.snp.makeConstraints { make in
			make.top.equalTo(passwordConditionsLabel.snp.bottom).offset(Metric.checkPasswordLabelTopMargin)
			make.leading.equalToSuperview().offset(Metric.horizontalMargin)
		}
		
		checkPasswordTextField.snp.makeConstraints { make in
			make.top.equalTo(checkPasswordLabel.snp.bottom).offset(Metric.checkPasswordTextFieldTopMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
		}
		
		checkPasswordConditionsLabel.snp.makeConstraints { make in
			make.top.equalTo(checkPasswordTextField.snp.bottom)
				.offset(Metric.passwordConditionsLabelTopMargin)
			make.trailing.equalTo(checkPasswordTextField.snp.trailing)
				.offset(Metric.passwordConditionsLabelRightMargin)
		}
		
		nextButton.snp.makeConstraints { make in
			make.bottom.equalTo(safeAreaLayoutGuide).offset(Metric.nextButtonBottomMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
		}
		
		super.updateConstraints()
	}
}

private extension EmailSiginUpPasswordView {
	func setupViews() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupSubViews() {
		addSubview(navigationBar)
		addSubview(passwordLabel)
		addSubview(passwordTextField)
		addSubview(passwordConditionsLabel)
		addSubview(checkPasswordLabel)
		addSubview(checkPasswordTextField)
		addSubview(checkPasswordConditionsLabel)
		addSubview(nextButton)
	}
}
