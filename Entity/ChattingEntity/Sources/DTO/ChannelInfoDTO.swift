//
//  ChannelInfoDTO.swift
//  ChattingEntity
//
//  Created by 김동겸 on 3/14/24.
//

import Foundation

public struct ChannelInfoDTO {
	public let id: String
	public let name: String
	public let icon_url: String
	public var member_count: Int
	public var members: [MemberInfoDTO]?
	
	public init(
		id: String,
		name: String,
		icon_url: String,
		member_count: Int
	) {
		self.id = id
		self.name = name
		self.icon_url = icon_url
		self.member_count = member_count
	}
}
