//
//  EmailSiginUpEmailView.swift
//  Login
//
//  Created by 김민희 on 2023/11/21.
//

import UIKit

import DesignSystem
import ResourceKit

import SnapKit
import Then

public final class EmailSiginUpEmailView: UIView {
	private enum Metric {
		static let horizontalMargin: CGFloat = 24
		static let emailLabelTopMargin: CGFloat = 38
		static let emailTextFieldTopMargin: CGFloat = 8
		static let cautionLabelTopMargin: CGFloat = 30
		static let cautionLabelLeftMargin: CGFloat = 8
		static let authCodeLabelTopMargin: CGFloat = 32
		static let resendAuthCodeLabelTopMargin: CGFloat = 7
		static let resendAuthCodeLabelRightMargin: CGFloat = -8
		static let authCodeTextFieldTopMargin: CGFloat = 8
		static let authCodeNoticeLabelTopMargin: CGFloat = 30
		static let authCodeNoticeLabelHorzontalMargin: CGFloat = 32
		static let nextButtonBottomMargin: CGFloat = -34
		static let emailStateImageViewSize: CGFloat = 14
		static let emailStateImageViewleftMargin: CGFloat = 8
		static let authCodeStateImageViewSize: CGFloat = 14
		static let authCodeStateImageViewLeftMargin: CGFloat = 8
	}
	
	private enum TextSet {
		static let navigationBarText: String = "회원가입"
		static let authCodeLabelText: String = "인증번호 6자리"
		static let resendAuthCodeLabelText: String = "인증번호 재전송"
		static let authCodeTextFieldText: String = "이메일 인증"
		static let authCodeNoticeLabelText: String = "인증번호는 입력한 이메일 주소로 발송됩니다. 수신하지 못했다면 스팸함 또는 해당 이메일 서비스의 설정을 확인해주세요."
		static let sendAuthCodeButtonText: String = "인증번호 전송"
		static let nextButtonText: String = "다음"
		static let emailLabelText: String = "이메일"
		static let cautionLabelText: String = "회원 가입시 ID는 반드시 본인 소유의 연락 가능한 이메일 주소를 사용하여야 합니다."
		static let timerLabelText: String = "9분 59초"
	}
	
	private(set) var navigationBar: NavigationBar = NavigationBar(.back, title: TextSet.navigationBarText)
	private(set) var authCodeLabel: UILabel = UILabel().then {
		$0.text = TextSet.authCodeLabelText
		$0.font = AppTheme.Font.Bold_16
		$0.textColor = AppTheme.Color.black
	}
	private(set) var resendAuthCodeLabel: UILabel = UILabel().then {
		let attributedString = NSMutableAttributedString.init(string: TextSet.resendAuthCodeLabelText)
		attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: 1, range: NSRange
			.init(location: 0, length: attributedString.length))
		$0.attributedText = attributedString
		$0.font = AppTheme.Font.Bold_10
		$0.textColor = AppTheme.Color.black
	}
	private (set) var emailTextField: DefaultTextField = DefaultTextField(.email)
	private(set) lazy var authCodeTextField: DefaultTextField = DefaultTextField(
		.custom,
		customView: timerLabel,
		customTypePlaceHolder: TextSet.authCodeTextFieldText
	)
	private (set) var emailStateView: UIView = UIView().then {
		$0.isHidden = true
		$0.backgroundColor = .clear
	}
	private (set) var emailStateImageView: UIImageView = UIImageView()
	private (set) var emailStateLabel: UILabel = UILabel().then {
		$0.font = AppTheme.Font.Regular_12
		$0.textColor = AppTheme.Color.primary
	}
	private(set) var authCodeNoticeLabel: UILabel = UILabel().then {
		$0.text = TextSet.authCodeNoticeLabelText
		$0.font = AppTheme.Font.Regular_12
		$0.textColor = AppTheme.Color.grey70
		$0.numberOfLines = 0
	}
	private(set) var sendAuthCodeButton: DefaultButton = DefaultButton(
		title: TextSet.sendAuthCodeButtonText,
		initEnableState: false
	).then {
		$0.layer.zPosition = 1
	}
	private(set) var nextButton: DefaultButton = DefaultButton(
		title: TextSet.nextButtonText,
		initEnableState: false
	).then {
		$0.layer.zPosition = 0
	}
	private (set) var authCodeStateView: UIView = UIView().then {
		$0.isHidden = true
		$0.backgroundColor = .clear
	}
	private (set) var authCodeStateImageView: UIImageView = UIImageView()
	
	private (set) var authCodeStateLabel: UILabel = UILabel().then {
		$0.font = AppTheme.Font.Regular_12
		$0.textColor = AppTheme.Color.primary
	}
	private (set) var authCodeView: UIView = UIView().then {
		$0.isHidden = true
		$0.backgroundColor = .clear
	}
	
	private let emailLabel: UILabel = UILabel().then {
		$0.text = TextSet.emailLabelText
		$0.font = AppTheme.Font.Bold_16
		$0.textColor = AppTheme.Color.black
	}
	
	private let cautionLabel: UILabel = UILabel().then {
		$0.text = TextSet.cautionLabelText
		$0.font = AppTheme.Font.Regular_12
		$0.textColor = AppTheme.Color.grey70
		$0.numberOfLines = 0
	}
	
	private let timerLabel: UILabel = UILabel().then {
		$0.text = TextSet.timerLabelText
		$0.font = AppTheme.Font.Bold_10
		$0.textColor = AppTheme.Color.primary
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
		
		emailLabel.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom).offset(Metric.emailLabelTopMargin)
			make.leading.equalToSuperview().offset(Metric.horizontalMargin)
		}
		
		emailTextField.snp.makeConstraints { make in
			make.top.equalTo(emailLabel.snp.bottom).offset(Metric.emailTextFieldTopMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
		}
		
		emailStateView.snp.makeConstraints { make in
			make.top.equalTo(emailTextField.snp.bottom)
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
			make.bottom.equalTo(cautionLabel.snp.top)
		}
		
		emailStateImageView.snp.makeConstraints { make in
			make.size.equalTo(Metric.emailStateImageViewSize)
			make.leading.equalToSuperview().offset(Metric.emailStateImageViewleftMargin)
			make.centerY.equalToSuperview()
		}
		
		emailStateLabel.snp.makeConstraints { make in
			make.leading.equalTo(emailStateImageView.snp.trailing).offset(4)
			make.centerY.equalToSuperview()
		}
		
		cautionLabel.snp.makeConstraints { make in
			make.top.equalTo(emailTextField.snp.bottom).offset(Metric.cautionLabelTopMargin)
			make.leading.equalTo(emailTextField.snp.leading).offset(Metric.cautionLabelLeftMargin)
			make.trailing.equalToSuperview().offset(-Metric.horizontalMargin)
		}
		
		authCodeView.snp.makeConstraints { make in
			make.top.equalTo(cautionLabel.snp.bottom)
			make.horizontalEdges.equalToSuperview()
			make.bottom.equalTo(authCodeNoticeLabel.snp.bottom)
		}
		
		authCodeLabel.snp.makeConstraints { make in
			make.top.equalTo(cautionLabel.snp.bottom).offset(Metric.authCodeLabelTopMargin)
			make.leading.equalToSuperview().offset(Metric.horizontalMargin)
		}
		
		resendAuthCodeLabel.snp.makeConstraints { make in
			make.top.equalTo(authCodeLabel.snp.top).offset(Metric.resendAuthCodeLabelTopMargin)
			make.trailing.equalTo(authCodeTextField.snp.trailing).offset(Metric.resendAuthCodeLabelRightMargin)
		}
		
		authCodeTextField.snp.makeConstraints { make in
			make.top.equalTo(authCodeLabel.snp.bottom).offset(Metric.authCodeTextFieldTopMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
		}
		
		authCodeStateView.snp.makeConstraints { make in
			make.top.equalTo(authCodeTextField.snp.bottom)
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
			make.bottom.equalTo(authCodeNoticeLabel.snp.top)
		}
		
		authCodeStateImageView.snp.makeConstraints { make in
			make.size.equalTo(Metric.authCodeStateImageViewSize)
			make.leading.equalToSuperview().offset(Metric.authCodeStateImageViewLeftMargin)
			make.centerY.equalToSuperview()
		}
		
		authCodeStateLabel.snp.makeConstraints { make in
			make.leading.equalTo(authCodeStateImageView.snp.trailing).offset(4)
			make.centerY.equalToSuperview()
		}
		
		authCodeNoticeLabel.snp.makeConstraints { make in
			make.top.equalTo(authCodeTextField.snp.bottom).offset(Metric.authCodeNoticeLabelTopMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.authCodeNoticeLabelHorzontalMargin)
		}
		
		sendAuthCodeButton.snp.makeConstraints { make in
			make.bottom.equalTo(safeAreaLayoutGuide).offset(Metric.nextButtonBottomMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
		}
		
		nextButton.snp.makeConstraints { make in
			make.bottom.equalTo(safeAreaLayoutGuide).offset(Metric.nextButtonBottomMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
		}
		
		super.updateConstraints()
	}
}

private extension EmailSiginUpEmailView {
	func setupViews() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupSubViews() {
		addSubview(navigationBar)
		addSubview(emailLabel)
		addSubview(emailTextField)
		addSubview(cautionLabel)
		addSubview(authCodeLabel)
		addSubview(resendAuthCodeLabel)
		addSubview(authCodeTextField)
		addSubview(authCodeNoticeLabel)
		addSubview(sendAuthCodeButton)
		addSubview(nextButton)
		addSubview(emailStateView)
		addSubview(authCodeStateView)
		addSubview(authCodeView)
		
		authCodeView.addSubview(authCodeLabel)
		authCodeView.addSubview(resendAuthCodeLabel)
		authCodeView.addSubview(authCodeTextField)
		authCodeView.addSubview(authCodeNoticeLabel)
		
		emailStateView.addSubview(emailStateImageView)
		emailStateView.addSubview(emailStateLabel)
		
		authCodeStateView.addSubview(authCodeStateImageView)
		authCodeStateView.addSubview(authCodeStateLabel)
	}
}
