// Created by Josh Adams, who holds the copyright and reserves all rights, on 1/6/23.

import SwiftUI

struct BreedDetailsView: View {
  let breed: Breed
  @Environment(\.openURL) var openURL
  @State private var image: UIImage?
  private let photoHeightWidth: CGFloat = 250.0

  var body: some View {
    VStack {
      Group {
        if let image {
          Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .padding()
        } else {
          ProgressView()
        }
      }
      .frame(width: photoHeightWidth, height: photoHeightWidth)
      .task {
        await image = Current.imageLoader.fetch(breed.photoUrl)
      }

      ScrollView {
        Text(breed.description)
      }

      Spacer()

      Text("Photo Credit: \(breed.credit)")

      Spacer()

      HStack {
        Button("Show License") {
          showLicense()
        }

        Spacer()

        Button("View in Wikipedia") {
          viewInWikipedia()
        }
      }
    }
    .navigationTitle(breed.name)
    .padding()
  }

  private func showLicense() {
    openURL(breed.license.url)
  }

  private func viewInWikipedia() {
    openURL(breed.infoUrl)
  }
}

#Preview {
  NavigationStack {
    BreedDetailsView(breed: Breed.mock)
  }
}
