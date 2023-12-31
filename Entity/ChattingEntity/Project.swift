//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/12/29.
//

import ProjectDescription
import ProjectDescriptionHelpers

import EntityPlugin

let projectName: String = "ChattingEntity"
let iOSTargetVersion: String = "16.0"

let project = Project.makeLibraryProject(
  name: "ChattingEntity",
  iOSTargetVersion: "16.0",
  baseSetting: .init(),
  dependencies: [],
  isDynamic: false,
  needTestTarget: false,
  needDemoAppTarget: false
)
