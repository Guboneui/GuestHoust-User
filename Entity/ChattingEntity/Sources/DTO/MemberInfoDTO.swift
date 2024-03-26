//
//  MemberInfoDTO.swift
//  ChattingEntity
//
//  Created by 김동겸 on 3/15/24.
//

import Foundation

public struct MemberInfoDTO {
	public let id: String
	public let role: Int
	public let name: String
	public let avatar_url: String
	
	public init(
		id: String,
		role: Int,
		name: String,
		avatar_url: String
	) {
		self.id = id
		self.role = role
		self.name = name
		self.avatar_url = avatar_url
	}
}
