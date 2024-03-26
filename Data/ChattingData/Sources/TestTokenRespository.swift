//
//  TestTokenRespository.swift
//  ChattingData
//
//  Created by 김동겸 on 3/12/24.
//

import Foundation

import ChattingDomain
import ChattingEntity
import ChattingService
import NetworkHelper
import SecureStorageKit

import RxSwift
import SocketIO

public final class TestTokenRespository: NetworkRepository<TestTokenAPI>, 
																					TestTokenRespositoryInterface {
	public func fetchTestTokenAPI(email: String, password: String) -> Single<TestTokenResponse> {
		request(endPoint: .testTokenLogin(email: email, password: password))
	}
	
	public func saveTokenToKeyChain(token: String) {
		KeyChainManager.create(key: .accessToken, value: token)
	}
	
	public init() {
		super.init(networkProvider: NetworkProvider())
	}
}
