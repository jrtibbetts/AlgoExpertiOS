// Created by Josh Adams, who holds the copyright and reserves all rights, on 9/28/23.

import UIKit

class TestingSceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?
  static var connectionOptions: UIScene.ConnectionOptions?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    TestingSceneDelegate.connectionOptions = connectionOptions

    guard let windowScene = (scene as? UIWindowScene) else {
      return
    }
    window = UIWindow(windowScene: windowScene)
    window?.rootViewController = TestingRootVC()
    window?.makeKeyAndVisible()
  }
}
