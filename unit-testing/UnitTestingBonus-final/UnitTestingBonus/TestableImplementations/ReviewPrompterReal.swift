// Copyright © 2023 AlgoExpert LLC. All rights reserved.

import StoreKit

class ReviewPrompterReal: ReviewPrompter {
  private var promptableActionsCount = 0
  private let actionsBetweenPromptsCount = 5

  func promptableActionHappened() {
    promptableActionsCount += 1
    if promptableActionsCount == actionsBetweenPromptsCount {
      requestReview()
      promptableActionsCount = 0
    }
  }

  private func requestReview() {
    (UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene)
      .map { SKStoreReviewController.requestReview(in: $0) }
  }
}
