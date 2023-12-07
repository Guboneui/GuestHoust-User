//
//  TestViewModel.swift
//  Login
//
//  Created by 구본의 on 2023/11/10.
//

import Foundation

import LoginDomain

import RxRelay
import RxSwift

public final class TestViewModel {
	private let testUseCase: TestUseCaseInterface
	private let disposeBag: DisposeBag
	
	public var userGender: BehaviorRelay<String> = .init(value: "kuhgkhjhk")
	
	public init(testUseCase: TestUseCaseInterface) {
		self.testUseCase = testUseCase
		self.disposeBag = .init()
	}
	
	public func testViewModelMethod() {
		testUseCase.testUseCaseMethod()
			.subscribe { [weak self] genter in
				guard let self else { return }
				self.userGender.accept(genter)
			}.disposed(by: disposeBag)
	}
}
