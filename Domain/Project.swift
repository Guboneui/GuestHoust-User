//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/11/10.
//

import ProjectDescription
import ProjectDescriptionHelpers

import DomainPlugin
import EntityPlugin

let projectName: String = "Domain"
let iOSTargetVersion: String = "16.0"

let project = Project.makeLibraryProject(
  name: "Domain",
  iOSTargetVersion: "16.0",
  baseSetting: .init(),
  dependencies: [
    .Domain.LoginDomain.Main,
    .Domain.ChattingDomain.Main,
    .Domain.MapDomain.Main,
    
    .Entity.Main
  ],
  isDynamic: false,
  needTestTarget: false,
  needDemoAppTarget: false
)

