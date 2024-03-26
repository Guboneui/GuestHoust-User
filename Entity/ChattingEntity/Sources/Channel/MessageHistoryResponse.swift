//
//  MessageHistoryResponse.swift
//  ChattingEntity
//
//  Created by 김동겸 on 3/7/24.
//

import Foundation

public struct MessageHistoryResponse: Codable {
	public let channelId: String
	public let messages: [ReceiveMessageData]
}
