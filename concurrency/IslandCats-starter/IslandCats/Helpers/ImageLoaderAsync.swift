// Created by Josh Adams, who holds the copyright and reserves all rights, on 7/18/23.

import UIKit

class ImageLoaderAsync {
  private let session: URLSession
  private let errorImage = UIImage(systemName: "xmark.octagon") ?? UIImage()

  init() {
    let configuration = URLSessionConfiguration.default
    configuration.requestCachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    session = URLSession(configuration: configuration)
  }

  func fetch(_ url: URL) async -> UIImage {
    do {
      let (imageData, _) = try await session.data(from: url)
      return UIImage(data: imageData) ?? errorImage
    } catch {
      return errorImage
    }
  }
}
