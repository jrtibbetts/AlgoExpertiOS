// Created by Josh Adams, who holds the copyright and reserves all rights, on 9/28/23.

import Foundation

var Current = World.chooseWorld()

struct World {
  var settings: Settings
  var soundPlayer: SoundPlayer

  static func chooseWorld() -> World {
    if NSClassFromString("XCTest") != nil {
      return World.unitTest
    } else {
      return World.production
    }
  }

  static let production: World = {
    let settings = Settings(getterSetter: GetterSetterReal())

    return World(
      settings: settings,
      soundPlayer: SoundPlayerReal()
    )
  }()

  static let unitTest: World = {
    let settings = Settings(getterSetter: GetterSetterFake())
    settings.sessionType = .stub

    return World(
      settings: settings,
      soundPlayer: SoundPlayerDummy()
    )
  }()
}
