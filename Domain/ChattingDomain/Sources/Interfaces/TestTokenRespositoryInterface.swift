//
//  TestTokenRespositoryInterface.swift
//  ChattingDomain
//
//  Created by 김동겸 on 3/12/24.
//

import Foundation

import ChattingEntity

import RxSwift

public protocol TestTokenRespositoryInterface {
	func fetchTestTokenAPI(email: String, password: String) -> Single<TestTokenResponse>
	func saveTokenToKeyChain(token: String)
}
