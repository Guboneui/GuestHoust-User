//
//  ChannelMemberListResponse.swift
//  ChattingEntity
//
//  Created by 김동겸 on 3/7/24.
//

import Foundation

public struct ChannelMemberListResponse: Codable {
	public let members: [ChannelMemberInfo]
}

public struct ChannelMemberInfo: Codable {
	public let id: String
	public let role: Int
	public let name: String
	public let avatar_url: String
}
