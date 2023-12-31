//
//  Network+Project.swift
//  DataPlugin
//
//  Created by 구본의 on 2023/11/10.
//

import Foundation
import ProjectDescription

extension TargetDependency {
  public struct Network {
    public struct LoginNetwork { }
    public struct ChattingNetwork { }
    public struct MapNetwork { }
  }
}

public extension TargetDependency.Network {
  static let folderName: String = "Network"
  
  static func project(name: String) -> TargetDependency {
    return .project(
      target: "\(name)",
      path: .relativeToRoot("\(folderName)")
    )
  }
  
  static let Main = project(name: "Network")
}

public extension TargetDependency.Network.LoginNetwork {
  static let folderName: String = "LoginNetwork"
  static func project(name: String) -> TargetDependency {
    return .project(
      target: "\(name)",
      path: .relativeToRoot("Network/\(folderName)")
    )
  }
  
  static let Main = project(name: "LoginNetwork")
}

public extension TargetDependency.Network.ChattingNetwork {
  static let folderName: String = "ChattingNetwork"
  static func project(name: String) -> TargetDependency {
    return .project(
      target: "\(name)",
      path: .relativeToRoot("Network/\(folderName)")
    )
  }
  
  static let Main = project(name: "ChattingNetwork")
}

public extension TargetDependency.Network.MapNetwork {
  static let folderName: String = "MapNetwork"
  static func project(name: String) -> TargetDependency {
    return .project(
      target: "\(name)",
      path: .relativeToRoot("Network/\(folderName)")
    )
  }
  
  static let Main = project(name: "MapNetwork")
}