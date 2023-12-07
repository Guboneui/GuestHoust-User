//
//  EmailSiginUpNameView.swift
//  Login
//
//  Created by 김민희 on 2023/11/21.
//

import UIKit

import DesignSystem
import ResourceKit

import SnapKit
import Then

public final class EmailSiginUpNameView: UIView {
	private enum Metric {
		static let horizontalMargin: CGFloat = 24
		static let profileViewTopMargin: CGFloat = 52
		static let profileViewSize: CGFloat = 108
		static let profileImageViewSize: CGFloat = 48
		static let cameraViewSize: CGFloat = 36
		static let cameraImageViewSize: CGFloat = 18
		static let cameraViewRightMargin: CGFloat = 4
		static let cameraViewBottomMargin: CGFloat = 4
		static let nameLabelTopMargin: CGFloat = 60
		static let nameLabelLeftMargin: CGFloat = 24
		static let nameTextFieldTopMargin: CGFloat = 8
		static let nextButtonBottomMargin: CGFloat = -34
	}
	
	private enum TextSet {
		static let navigationBarText: String = "회원가입"
		static let nextButtonText: String = "다음"
		static let nameLabelText: String = "이름을 입력해 주세요"
	}
	
	private(set) var navigationBar: NavigationBar = NavigationBar(
		.back,
		title: TextSet.navigationBarText
	)
	private(set) var nextButton: DefaultButton = DefaultButton(
		title: TextSet.nextButtonText,
		initEnableState: true
	)
	
	private let profileView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.white
		$0.makeCornerRadiusWithBorder(54, borderWidth: 1.5, borderColor: AppTheme.Color.grey70)
	}
	
	private let profileImageView: UIImageView = UIImageView().then {
		$0.image = AppTheme.Image.profile.withRenderingMode(.alwaysTemplate)
		$0.tintColor = AppTheme.Color.grey40
	}
	
	private let cameraView: UIView = UIView().then {
		$0.backgroundColor = AppTheme.Color.primary
		$0.makeCornerRadius(18)
	}
	
	private let cameraImageView: UIImageView = UIImageView().then {
		$0.image = AppTheme.Image.camera.withRenderingMode(.alwaysTemplate)
		$0.tintColor = AppTheme.Color.white
	}
	
	private let nameLabel: UILabel = UILabel().then {
		$0.text = TextSet.nameLabelText
		$0.font = AppTheme.Font.Bold_16
		$0.textColor = AppTheme.Color.black
	}
	
	private let nameTextField: DefaultTextField = DefaultTextField(.name)
	
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
		
		profileView.snp.makeConstraints { make in
			make.size.equalTo(Metric.profileViewSize)
			make.top.equalTo(navigationBar.snp.bottom).offset(Metric.profileViewTopMargin)
			make.centerX.equalToSuperview()
		}
		
		profileImageView.snp.makeConstraints { make in
			make.size.equalTo(Metric.profileImageViewSize)
			make.center.equalToSuperview()
		}
		
		cameraView.snp.makeConstraints { make in
			make.size.equalTo(Metric.cameraViewSize)
			make.bottom.equalTo(profileView.snp.bottom).offset(Metric.cameraViewBottomMargin)
			make.trailing.equalTo(profileView.snp.trailing).offset(Metric.cameraViewRightMargin)
		}
		
		cameraImageView.snp.makeConstraints { make in
			make.size.equalTo(Metric.cameraImageViewSize)
			make.center.equalToSuperview()
		}
		
		nameLabel.snp.makeConstraints { make in
			make.top.equalTo(profileView.snp.bottom).offset(Metric.nameLabelTopMargin)
			make.leading.equalToSuperview().offset(Metric.nameLabelLeftMargin)
		}
		
		nameTextField.snp.makeConstraints { make in
			make.top.equalTo(nameLabel.snp.bottom).offset(Metric.nameTextFieldTopMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
		}
		
		nextButton.snp.makeConstraints { make in
			make.bottom.equalTo(safeAreaLayoutGuide).offset(Metric.nextButtonBottomMargin)
			make.horizontalEdges.equalToSuperview().inset(Metric.horizontalMargin)
		}
		
		super.updateConstraints()
	}
}

private extension EmailSiginUpNameView {
	func setupViews() {
		backgroundColor = AppTheme.Color.white
	}
	
	func setupSubViews() {
		addSubview(navigationBar)
		addSubview(profileView)
		addSubview(cameraView)
		addSubview(nameLabel)
		addSubview(nameTextField)
		addSubview(nextButton)
		
		profileView.addSubview(profileImageView)
		cameraView.addSubview(cameraImageView)
	}
}
