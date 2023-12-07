//
//  EmailSiginUpPhoneView.swift
//  Login
//
//  Created by 김민희 on 2023/11/21.
//

import UIKit

import DesignSystem
import ResourceKit

import SnapKit
import Then

public final class EmailSiginUpPhoneView: UIView {
	private enum Metric {
		static let horizontalMargin: CGFloat = 24
		static let nameLabelTopMargin: CGFloat = 54
		static let nameLabelLeftMargin: CGFloat = 24
		static let phoneNumberInputViewTopMargin: CGFloat = 36
		static let phoneNumberInputViewHorizontalMargin: CGFloat = 22
		static let nextButtonBottomMargin: CGFloat = -34
	}
	
	private enum TextSet {
		static let navigationBarText: String = "회원가입"
		static let nextButtonText: String = "회원가입 완료"
		static let nameLabelText: String = "핸드폰 번호를 입력해 주세요"
		static let phoneNumberInputViewTextArray: [String] = ["010", "011", "017", "018", "019", "116"]
	}
	
	private(set) var navigationBar: NavigationBar = NavigationBar(
		.back,
		title: TextSet.navigationBarText
	)
	private(set) var nextButton: DefaultButton = DefaultButton(
		title: TextSet.nextButtonText,
		initEnableState: true
	)
	
	private let nameLabel: UILabel = UILabel().then {
		$0.text = TextSet.nameLabelText
		$0.font = AppTheme.Font.Bold_20
		$0.textColor = AppTheme.Color.black
	}
	
	public let phoneNumberInputView = PhoneNumberInputView(
		with: TextSet.phoneNumberInputViewTextArray
	)
	
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
		
		nameLabel.snp.makeConstraints { make in
			make.top.equalTo(navigationBar.snp.bottom).offset(Metric.nameLabelTopMargin)
			make.leading.equalToSuperview().offset(Metric.nameLabelLeftMargin)
		}
		
		phoneNumberInputView.snp.makeConstraints { make in
			make.top.equalTo(nameLabel.snp.bottom).offset(Metric.phoneNumberInputViewTopMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.phoneNumberInputViewHorizontalMargin)
		}
		
		nextButton.snp.makeConstraints { make in
			make.bottom.equalTo(safeAreaLayoutGuide).offset(Metric.nextButtonBottomMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
		}
		
		super.updateConstraints()
	}
}

private extension EmailSiginUpPhoneView {
	func setupViews() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupSubViews() {
		addSubview(navigationBar)
		addSubview(nameLabel)
		addSubview(phoneNumberInputView)
		addSubview(nextButton)
	}
}
