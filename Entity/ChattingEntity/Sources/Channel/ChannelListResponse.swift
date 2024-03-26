//
//  ChannelListResponse.swift
//  ChattingEntity
//
//  Created by 김동겸 on 3/7/24.
//

import Foundation

public struct ChannelListResponse: Codable {
	public let channels: [ChannelInfo]
}

public struct ChannelInfo: Codable {
	public let id: String
	public let name: String
	public let icon_url: String
	public let member_count: Int
}
