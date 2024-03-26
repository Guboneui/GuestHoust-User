//
//  TestTokenAPI.swift
//  ChattingNetwork
//
//  Created by 김동겸 on 3/1/24.
//

import Foundation

import Moya

public enum TestTokenAPI {
	case testTokenLogin(email: String, password: String)
}

extension TestTokenAPI: TargetType {
	public var baseURL: URL {
		guard let url = URL(string: "http://144.24.95.47:80/v1/auth") else {
			fatalError("Invalid base URL")
		}
		return url
	}
	
	public var path: String {
		switch self {
		case .testTokenLogin:
			return "/login"
		}
	}
	
	public var method: Moya.Method {
		switch self {
		case .testTokenLogin:
			return .post
		}
	}
	
	public var task: Moya.Task {
		switch self {
		case let .testTokenLogin(email, password):
			return .requestParameters(
				parameters: ["email": email, "password": password],
				encoding: JSONEncoding.default
			)
		}
	}
	
	public var headers: [String: String]? {
		switch self {
		case .testTokenLogin:
			return nil
		}
	}
}
