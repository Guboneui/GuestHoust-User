//
//  LoginAppDelegate.swift
//  Login
//
//  Created by 구본의 on 2023/10/17.
//

import UIKit

import Login
import LoginData
import LoginDomain



@main
class LoginAppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?
  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let window = UIWindow(frame: UIScreen.main.bounds)
//		let testRepository: TestRepositoryInterface = TestRepository()
//		let testUseCase: TestUseCaseInterface = TestUseCase(testRepository: testRepository)
//		let testViewModel = TestViewModel(testUseCase: testUseCase)
//    window.rootViewController = TestViewController(testViewModel: testViewModel)

		window.rootViewController = LoginViewController()
    window.makeKeyAndVisible()
    self.window = window
    return true
	}
}

