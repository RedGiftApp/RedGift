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

  func makeCoordinator() -> Coordinator { Coordinator(parent: self) }

  func makeUIViewController(context: Context) -> UIPageViewController {
    let pageViewController = UIPageViewController(
      transitionStyle: .scroll, navigationOrientation: .vertical, options: nil)
    pageViewController.dataSource = context.coordinator
    pageViewController.delegate = context.coordinator
    return pageViewController
  }

  func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
    pageViewController.setViewControllers(
      [context.coordinator.makeViewController(index: currentPage)], direction: .forward,
      animated: false)
  }

  class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    let parent: PageView

    init(parent: PageView) { self.parent = parent }

    func makeViewController(index: Int) -> UIViewController {
      let viewController = UIHostingController(rootView: parent.pages[index])
      viewController.view.tag = index
      return viewController
    }

    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
      let index = viewController.view.tag - 1
      return index >= 0 ? makeViewController(index: index) : nil
    }

    func pageViewController(
      _ pageViewController: UIPageViewController,
      viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
      let index = viewController.view.tag + 1
      return index < parent.pages.count ? makeViewController(index: index) : nil
    }

    func pageViewController(
      _ pageViewController: UIPageViewController, didFinishAnimating finished: Bool,
      previousViewControllers: [UIViewController], transitionCompleted completed: Bool
    ) { if completed { parent.currentPage = pageViewController.viewControllers![0].view.tag } }
  }
}
