//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 구본의 on 2023/10/17.
//

import ProjectDescription
import ProjectDescriptionHelpers

import ResourceKitPlugin
import ThirdPartyDependencyPlugin
import UtilityKitPlugin

let projectName: String = "DesignSystem"
let iOSTargetVersion: String = "16.0"

let project = Project.makeFrameworkProject(
  name: projectName,
  iOSTargetVersion: iOSTargetVersion,
  dependencies: [
    .ResourceKit.Main,
    .UtilityKit.Main,
    .ThirdParty.Main
  ],
  isDynamic: false,
  needTestTarget: false,
  needDemoAppTarget: false
)
