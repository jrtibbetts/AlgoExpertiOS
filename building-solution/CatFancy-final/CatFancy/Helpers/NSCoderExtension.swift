// Created by Josh Adams, who holds the copyright and reserves all rights, on 9/27/23.

import Foundation

extension NSCoder {
  static func fatalErrorNotImplemented() -> Never {
    fatalError("init(coder:) has not been implemented.")
  }
}
