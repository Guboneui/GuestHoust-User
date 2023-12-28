//
//  LoginViewController.swift
//  Login
//
//  Created by 김동겸 on 2023/10/17.
//

import UIKit

import DesignSystem
import ResourceKit

import SnapKit
import Then

public final class LoginViewController: UIViewController {
  
  private let mainLogoView: UIView = UIView().then {
    $0.backgroundColor = .AppColor.appGrey70
  }
  
  private let loginLabel: UILabel = UILabel().then {
    $0.text = "로그인/회원가입"
    $0.font = .AppFont.Regular_14
    $0.textColor = .AppColor.appBlack
    $0.textAlignment = .center
  }
  
  private lazy var stackViewSubViews: [SocialLoginButton] = [
    naverLoginButton, 
    appleLoginButton,
    kakaoLoginButton,
    emailLoginButton
  ]
  
  private lazy var socialLoginsStackView: UIStackView = UIStackView(
    arrangedSubviews: stackViewSubViews
  ).then {
    $0.axis = .horizontal
    $0.alignment = .fill
    $0.distribution = .fillEqually
    $0.spacing = 24
  }
  
  private let naverLoginButton: SocialLoginButton = SocialLoginButton(.naver)
  private let appleLoginButton: SocialLoginButton = SocialLoginButton(.apple)
  private let kakaoLoginButton: SocialLoginButton = SocialLoginButton(.kakao)
  private let emailLoginButton: SocialLoginButton = SocialLoginButton(.email)
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupViews()
  }
}

private extension LoginViewController {
  
  func setupUI() {
    view.backgroundColor = .white
  }
  
  func setupViews() {
    view.addSubview(mainLogoView)
    view.addSubview(loginLabel)
    view.addSubview(socialLoginsStackView)
    
    setupConstraints()
  }
  
  func setupConstraints() {
    mainLogoView.snp.makeConstraints { make in
      make.width.height.equalTo(100)
      make.centerX.equalToSuperview()
      make.bottom.equalTo(loginLabel.snp.top).offset(-38)
    }
    
    loginLabel.snp.makeConstraints { make in
      make.horizontalEdges.equalToSuperview()
      make.centerY.equalToSuperview() 
    }
    
    socialLoginsStackView.snp.makeConstraints { make in
      make.top.equalTo(loginLabel.snp.bottom).offset(28)
      make.horizontalEdges.equalToSuperview().inset(52)
    }
  }
}
