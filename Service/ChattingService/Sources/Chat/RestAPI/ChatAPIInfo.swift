//
//  ChatAPIInfo.swift
//  ChattingNetwork
//
//  Created by 김동겸 on 3/4/24.
//

import Foundation

public enum GuestHouseAPIInfo {
	static let baseURLString: String = "http://144.24.95.47:80/v2/channel"
	
	static let channelURLString: String = baseURLString
	static var channelURL: URL {
		guard let url = URL(string: channelURLString) else {
			fatalError("Invalid base URL")
		}
		return url
	}
}
