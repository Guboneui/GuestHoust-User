//
//  DefaultTextField.swift
//  DesignSystem
//
//  Created by 구본의 on 2023/10/22.
//

import UIKit

import ResourceKit

import RxCocoa
import RxSwift
import SnapKit
import Then

public class DefaultTextField: UIView {
  
  // MARK: OUTPUT PROPERTY
  public let currentText: BehaviorRelay<String> = BehaviorRelay<String>(value: "")
  
  // MARK: ACTION CLOSURE
  public var didTapTextButton: (() -> Void)?
  
  // MARK: TYPE
  /// DefaultTextField에 적용할 타입입니다.
  public enum DefaultTextFieldType {
    case email
    case password
    case emailAuthCode
    case name
    
    fileprivate var placeHolder: String {
      switch self {
      case .email:
        return "이메일"
      case .password:
        return "비밀번호"
      case .emailAuthCode:
        return "인증번호"
      case .name:
        return "김동겸"
      }
    }
    
    fileprivate var security: Bool {
      switch self {
      case .email, .emailAuthCode, .name:
        return false
      case .password:
        return true
      }
    }
    
    fileprivate var buttonTitle: String {
      switch self {
      case .emailAuthCode:
        return "인증번호 재전송"
      default:
        return ""
      }
    }
  }
  
  // MARK: METRIC
  /// DefaultTextField의 크기 요소를 정의합니다.
  private enum Metric {
    static let textFieldLeftMargin = 16
    static let textFieldRightMargin = -8
    static let textFieldTopMargin = 14
    static let textFieldBottomMargin = -15
    
    static let clearButtonSize = 16
    static let clearButtonRightMargin = -16
    
    static let securityButtonSize = 16
    static let securitRightMargin = -8
    
    static let textButtonVerticalMargin = 17
    static let textButtonRightMargin = -16
    
    static let height = 46
    static let cornerRadius = 16.0
  }
	
	// MARK: Font
	private enum Font {
		static let textFieldFont: UIFont = .AppFont.Regular_12
	}
	
	private enum ColorSet {
		static let baseBackgroundColor: UIColor = .AppColor.appGrey90
		static let textFieldColor: UIColor = .AppColor.appBlack
	}
  
  // MARK: INPUT PROPERTY
  private let type: DefaultTextFieldType
  private let keyboardType: UIKeyboardType
  
  // MARK: PROPERTY
  private let disposeBag: DisposeBag
  
  // MARK: UI PROPERTY
  private let textField: UITextField = UITextField()
  private let clearButton: UIButton = UIButton().then {
    $0.setImage(.AppImage.delete, for: .normal)
    $0.tintColor = .AppColor.appGrey70
  }
  
  private let securityButton: UIButton = UIButton().then {
    $0.setImage(.AppImage.showOff, for: .normal)
    $0.setImage(.AppImage.showOn, for: .selected)
  }
  
  private lazy var textButton: UIButton = UIButton().then {
    $0.setTitle(type.buttonTitle, for: .normal)
    $0.setTitleColor(.AppColor.appBlack, for: .normal)
    $0.titleLabel?.font = .AppFont.Bold_10
  }
  
  // MARK: INITIALIZE
  public init(
    _ type: DefaultTextFieldType,
    keyboardType: UIKeyboardType = .default
  ) {
    self.type = type
    self.keyboardType = keyboardType
    self.disposeBag = .init()
    super.init(frame: .zero)
    self.setupSubViews()
    self.setupConfiguration()
    self.setupBindings()
    self.setupGeustures()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  /// DefaultTextField의 text값을 업데이트 합니다.
  public func updateText(text: String) {
    self.textField.text = text
    self.currentText.accept(text)
  }
}

// MARK: - PRIVATE METHOD
private extension DefaultTextField {
  
  /// DefaultTextField의 SubView들을 관리합니다
  func setupSubViews() {
    addSubview(textField)
    switch type {
    case .email, .name:
      addSubview(clearButton)
    case .password:
      addSubview(securityButton)
      addSubview(clearButton)
    case .emailAuthCode:
      addSubview(textButton)
    }
    
    setupConstrains()
  }
  
  /// DefaultTextField의 SubView의 오토레이아웃을 정의합니다.
  func setupConstrains() {
    snp.makeConstraints { make in
      make.height.equalTo(Metric.height)
    }
    
    switch type {
    case .email, .name:
      clearButton.snp.makeConstraints { make in
        make.trailing.equalToSuperview().offset(Metric.clearButtonRightMargin)
        make.centerY.equalToSuperview()
        make.size.equalTo(Metric.clearButtonSize)
      }
      
      textField.snp.makeConstraints { make in
        make.top.equalToSuperview().offset(Metric.textFieldTopMargin)
        make.leading.equalToSuperview().offset(Metric.textFieldLeftMargin)
        make.trailing.equalTo(clearButton.snp.leading).offset(Metric.textFieldRightMargin)
        make.bottom.equalToSuperview().offset(Metric.textFieldBottomMargin)
      }

    case .password:
      clearButton.snp.makeConstraints { make in
        make.trailing.equalToSuperview().offset(Metric.clearButtonRightMargin)
        make.centerY.equalToSuperview()
        make.size.equalTo(Metric.clearButtonSize)
      }
      
      securityButton.snp.makeConstraints { make in
        make.trailing.equalTo(clearButton.snp.leading).offset(Metric.securitRightMargin)
        make.centerY.equalToSuperview()
        make.size.equalTo(Metric.securityButtonSize)
      }
      
      textField.snp.makeConstraints { make in
        make.top.equalToSuperview().offset(Metric.textFieldTopMargin)
        make.leading.equalToSuperview().offset(Metric.textFieldLeftMargin)
        make.trailing.equalTo(securityButton.snp.leading).offset(Metric.textFieldRightMargin)
        make.bottom.equalToSuperview().offset(Metric.textFieldBottomMargin)
      }

    case .emailAuthCode:
      textButton.snp.makeConstraints { make in
        make.trailing.equalToSuperview().offset(Metric.textButtonRightMargin)
        make.verticalEdges.equalToSuperview().inset(Metric.textButtonVerticalMargin)
        make.width.equalTo(textButton.intrinsicContentSize.width)
      }
      
      textField.snp.makeConstraints { make in
        make.top.equalToSuperview().offset(Metric.textFieldTopMargin)
        make.leading.equalToSuperview().offset(Metric.textFieldLeftMargin)
        make.trailing.equalTo(textButton.snp.leading).offset(Metric.textFieldRightMargin)
        make.bottom.equalToSuperview().offset(Metric.textFieldBottomMargin)
      }
    }
  }
  
  /// DefaultTextField의 타입에 따른 이미지를 정의합니다.
  func setupConfiguration() {
    makeCornerRadius(16)
		backgroundColor = ColorSet.baseBackgroundColor
    
    textField.keyboardType = keyboardType
    textField.placeholder = type.placeHolder
		textField.textColor = ColorSet.textFieldColor
		textField.tintColor = ColorSet.textFieldColor
		textField.font = Font.textFieldFont
    textField.isSecureTextEntry = type.security
  }
  
  /// DefaultTextField의 Binding을 정의합니다.
  func setupBindings() {
    textField.rx.text
      .map { $0 ?? "" }
      .asDriver(onErrorJustReturn: "")
      .drive(onNext: { [weak self] text in
        self?.currentText.accept(text)
      }).disposed(by: disposeBag)
  }
  
  /// DefaultTextField의 CornerRadius 및 Gesture를 정의합니다.
  func setupGeustures() {
    clearButton.rx.tap
      .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
      .bind { [weak self] in
        self?.textField.text = ""
        self?.currentText.accept("")
      }.disposed(by: disposeBag)
    
    securityButton.rx.tap
      .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
      .bind { [weak self] in
        self?.securityButton.isSelected.toggle()
        self?.textField.isSecureTextEntry.toggle()
      }.disposed(by: disposeBag)
    
    textButton.rx.tap
      .throttle(.milliseconds(300), latest: false, scheduler: MainScheduler.instance)
      .bind { [weak self] in
        self?.didTapTextButton?()
      }.disposed(by: disposeBag)
  }
}
