//
//  ThirdPartyDependency+Project.swift
//  MyPlugin
//
//  Created by 구본의 on 2023/09/09.
//

import Foundation
import ProjectDescription

extension TargetDependency {
  public struct ThirdParty { }
  public struct DesignSystem { }
}

public extension TargetDependency.ThirdParty {
  static let folderName: String = "ThirdPartyDependency"
  
  static let dependency: [TargetDependency] = [
    SnapKit,
    Then,
    RxSwift,
    RxGesture,
    NMapsMap,
    ReactorKit,
    HorizontalCalendar
  ]
  
  static func project(name: String) -> TargetDependency {
    return .project(
      target: "\(name)",
      path: .relativeToRoot("\(folderName)")
    )
  }
  
  static let Main = project(name: "ThirdPartyDependency")
}

extension TargetDependency.ThirdParty {
  static let SnapKit = TargetDependency.external(name: "SnapKit")
  static let Then = TargetDependency.external(name: "Then")
  static let RxSwift = TargetDependency.external(name: "RxSwift")
  static let RxGesture = TargetDependency.external(name: "RxGesture")
  static let Moya = TargetDependency.external(name: "Moya")
  static let NMapsMap = TargetDependency.external(name: "NMapsMap")
  static let ReactorKit = TargetDependency.external(name: "ReactorKit")
  static let HorizontalCalendar = TargetDependency.external(name: "HorizonCalendar")
}
