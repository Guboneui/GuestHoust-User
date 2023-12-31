//
//  EmailSignupPWViewModel.swift
//  Login
//
//  Created by 김동겸 on 12/6/23.
//

import Foundation

import LoginEntity

import RxRelay

// MARK: - VIEWMODEL INTERFACE
public protocol EmailSignupPWViewModelInterface {
	var pwRelay: BehaviorRelay<String> { get }
	var pwCheckRelay: BehaviorRelay<String> { get }
	var pwBool: BehaviorRelay<Bool?> { get }
	var pwCheckBool: BehaviorRelay<Bool?> { get }
	var userSignupDTO: UserSignupDTO { get set }
	
	func isValiedPW()
	func isValiedPWCheck()
}

public final class EmailSignupPWViewModel: EmailSignupPWViewModelInterface {
	// MARK: - PUBLIC PROPERTY
	public var pwRelay: BehaviorRelay<String> = .init(value: "")
	public var pwCheckRelay: BehaviorRelay<String> = .init(value: "")
	public var pwBool: BehaviorRelay<Bool?> = .init(value: nil)
	public var pwCheckBool: BehaviorRelay<Bool?> = .init(value: nil)
	public var userSignupDTO: UserSignupDTO

	// MARK: - PRIVATE PROPERTY
	let pwRegex: String = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,20}"
	
	// MARK: - INITIALIZE
	init(userSignupDTO: UserSignupDTO) {
		self.userSignupDTO = userSignupDTO
	}
	
	// MARK: - PUBLIC METHOD
	public func isValiedPW() {
		NSPredicate(format: "SELF MATCHES %@", pwRegex).evaluate(with: pwRelay.value) ?
		pwBool.accept(true) : pwBool.accept(false)
	}
	
	public func isValiedPWCheck() {
		pwCheckRelay.value == pwRelay.value ?
		pwCheckBool.accept(true) : pwCheckBool.accept(false)
	}
}
