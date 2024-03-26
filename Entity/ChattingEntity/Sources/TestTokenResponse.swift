//
//  TestTokenResponse.swift
//  ChattingEntity
//
//  Created by 김동겸 on 3/1/24.
//

import Foundation

public struct TestTokenResponse: Codable {
	public let accessToken: String
	public let refreshToken: String
}
