// Copyright © 2023 AlgoExpert LLC. All rights reserved.

import UIKit

class ConditionsVC: UIViewController, UITableViewDataSource {
  private var conditionsDict: [String: String] = [:]
  private var startTime: CFAbsoluteTime = 0.0
  private var endTime: CFAbsoluteTime = 0.0

  private var conditionsView: ConditionsView {
    if let castedView = view as? ConditionsView {
      return castedView
    } else {
      fatalError(fatalCastMessage(view: ConditionsView.self))
    }
  }

  override func loadView() {
    view = ConditionsView(frame: UIScreen.main.bounds)
    conditionsView.setupTable(dataSource: self)
    setupButtons()
  }

  private func setupButtons() {
    setupButton(conditionsView.seriallyGCDButton, handler: { self.requestSeriallyGCD() })
    setupButton(conditionsView.inParallelGCDButton, handler: { self.requestInParallelGCD() })
    setupButton(conditionsView.seriallySCButton, handler: { self.requestSeriallySC() })
    setupButton(conditionsView.inParallelSCButton, handler: { self.requestInParallelSC() })
  }

  private func setupButton(_ button: UIButton, handler: @escaping () -> ()) {
    let action = UIAction { _ in
      handler()
    }
    button.addAction(action, for: .touchUpInside)
  }

  private func requestSeriallyGCD() {
    startTiming()
    requestConditionsGCD(index: 0)
  }

  private func requestConditionsGCD(index: Int) {
    if index < Region.regions.count {
      let region = Region.regions[index]
      ConditionsRequester.getConditionsClassic(
        latitude: region.latitude,
        longitude: region.latitude,
        completion: { conditions in
          self.conditionsDict[region.capital] = conditions
          self.requestConditionsGCD(index: index + 1)
        }
      )
    } else {
      endTiming()
    }
  }

  private func requestInParallelGCD() {
      startTiming()
      let group = DispatchGroup()

      for region in Region.regions {
          group.enter()
          ConditionsRequester.getConditionsClassic(
            latitude: region.latitude,
            longitude: region.latitude,
            completion: { conditions in
                self.conditionsDict[region.capital] = conditions
                group.leave()
            }
          )
      }

      group.notify(queue: .main) {
          self.endTiming()
      }
  }

  private func requestSeriallySC() {
      Task {
          startTiming()

          for region in Region.regions {
              let conditions = await ConditionsRequester.getConditionsSC(latitude: region.latitude, longitude: region.longitude)
              conditionsDict[region.capital] = conditions
          }

          endTiming()
      }
  }

  private func requestInParallelSC() {
      Task {
          startTiming()

          let regionConditions = await withTaskGroup(of: (Region, String).self, returning: [String: String].self) { (taskGroup) in
              for region in Region.regions {
                  taskGroup.addTask {
                      print("Getting conditions for \(region.capital)")
                      let conditions = await ConditionsRequester.getConditionsSC(latitude: region.latitude, longitude: region.longitude)
                      print("Got conditions for \(region.capital)")
                      return (region, conditions)
                  }
              }

              var results: [String: String] = [:]

              for await regionCondition in taskGroup {
                  results[regionCondition.0.capital] = regionCondition.1
              }

              return results
          }

          self.conditionsDict = regionConditions

          // By default, tasks are run on the same thread they were started from.
          endTiming()
      }
  }

  private func startTiming() {
    conditionsDict = [:]
    conditionsView.showRequestingConditionsState()
    startTime = CFAbsoluteTimeGetCurrent()
  }

  private func endTiming() {
    endTime = CFAbsoluteTimeGetCurrent()
    let elapsedTime = endTime - startTime
    let rounder = 1000.0
    let roundedElapsedTime = round(elapsedTime * rounder) / rounder
    conditionsView.showConditionsReceivedState(elapsedTime: roundedElapsedTime)
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    Region.regions.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: "\(ConditionsCell.self)") as? ConditionsCell {
      let region = Region.regions[indexPath.row]
      cell.configure(region: region, conditions: conditionsDict[region.capital])
      return cell
    } else {
      fatalError("Could not initialize \(ConditionsCell.self).")
    }
  }
}
