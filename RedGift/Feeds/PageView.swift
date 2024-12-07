//
//  PageView.swift
//  RedGift
//
//  Created by eliottwang on 2024/12/7.
//

import SwiftUI
import UIKit

struct PageView: UIViewControllerRepresentable {
  let pages: [GifView]
  @Binding var currentPage: Int

  func makeUIViewController(context: Context) -> UIPageViewController {
    let pageViewController = UIPageViewController(
      transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
    pageViewController.dataSource = context.coordinator
    pageViewController.delegate = context.coordinator
    _ = context.coordinator.getOrCreateViewController(index: currentPage + 2)
    _ = context.coordinator.getOrCreateViewController(index: currentPage + 1)
    pageViewController.setViewControllers(
      [context.coordinator.getOrCreateViewController(index: currentPage)!], direction: .forward,
      animated: false)
    pages[currentPage].store.send(.playerAction(.startPlay))
    return pageViewController
  }

  func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {}

  func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

  class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    private let parent: PageView
    private var cache: [Int: UIViewController] = [:]

    init(parent: PageView) { self.parent = parent }

    func getOrCreateViewController(index: Int) -> UIViewController? {
      guard index >= 0 && index < parent.pages.count else { return nil }

      if let viewController = cache[index] { return viewController }

      let gifView = parent.pages[index]
      _ = gifView.playerView.coordinator.createPlayer()
      let viewController = UIHostingController(rootView: gifView)
      viewController.view.tag = index
      viewController.loadView()
      cache[index] = viewController
      return viewController
    }

    // MARK: UIPageViewControllerDataSource
    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
      let index = viewController.view.tag
      return getOrCreateViewController(index: index - 1)
    }

    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
      let index = viewController.view.tag
      return getOrCreateViewController(index: index + 1)
    }

    // MARK: UIPageViewControllerDelegate
    func pageViewController(
      _ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
      previousViewControllers: [UIViewController], transitionCompleted completed: Bool
    ) {
      if completed {
        let index = pageViewController.viewControllers![0].view.tag
        let previousIndex = previousViewControllers[0].view.tag
        let sign = index - previousIndex
        cache.removeValue(forKey: index - 3 * sign)
        _ = getOrCreateViewController(index: index + 2 * sign)
        parent.currentPage = index
      }
    }
  }
}
