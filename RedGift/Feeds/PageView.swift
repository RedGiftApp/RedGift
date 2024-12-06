//
//  PageView.swift
//  RedGift
//
//  Created by eliottwang on 2024/12/7.
//

import SwiftUI
import UIKit

struct PageView<Page: View>: UIViewControllerRepresentable {
  let pages: [Page]
  @Binding var currentPage: Int

  func makeCoordinator() -> Coordinator { Coordinator(pages: pages, currentPage: $currentPage) }

  func makeUIViewController(context: Context) -> UIPageViewController {
    let pageViewController = UIPageViewController(
      transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
    pageViewController.dataSource = context.coordinator
    pageViewController.delegate = context.coordinator
    return pageViewController
  }

  func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
    pageViewController.setViewControllers(
      [context.coordinator.controllers[currentPage]], direction: .forward, animated: false)
  }

  class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    var controllers: [UIViewController]
    var currentPage: Binding<Int>

    init(pages: [Page], currentPage: Binding<Int>) {
      self.controllers = pages.enumerated()
        .map {
          let viewController = UIHostingController(rootView: $1)
          viewController.view.tag = $0
          return viewController
        }
      self.currentPage = currentPage
    }

    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
      let index = viewController.view.tag - 1
      return index >= 0 ? controllers[index] : nil
    }

    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
      let index = viewController.view.tag + 1
      return index < controllers.count ? controllers[index] : nil
    }

    func pageViewController(
      _ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
      previousViewControllers: [UIViewController], transitionCompleted completed: Bool
    ) {
      if completed { currentPage.wrappedValue = pageViewController.viewControllers![0].view.tag }
    }
  }
}
