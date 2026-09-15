//
//  InteractivePopGestureModifier.swift
//  FinQ
//
//  Created by 권대윤 on 9/15/26.
//

import Foundation
import SwiftUI
import UIKit

private struct InteractivePopGestureModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background(InteractivePopGestureController())
    }
}

private struct InteractivePopGestureController: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> Controller { Controller() }
    func updateUIViewController(_ uiViewController: Controller, context: Context) { }

    final class Controller: UIViewController {
        private weak var popGestureRecognizer: UIGestureRecognizer?
        private var originalDelegate: (any UIGestureRecognizerDelegate)?

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            guard let navigationController, navigationController.viewControllers.count > 1, let gestureRecognizer = navigationController.interactivePopGestureRecognizer, popGestureRecognizer == nil else { return }
            popGestureRecognizer = gestureRecognizer
            originalDelegate = gestureRecognizer.delegate
            gestureRecognizer.delegate = nil
            gestureRecognizer.isEnabled = true
        }

        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            if let popGestureRecognizer, popGestureRecognizer.delegate == nil { popGestureRecognizer.delegate = originalDelegate }
            popGestureRecognizer = nil
            originalDelegate = nil
        }
    }
}

extension View {
    func enableInteractivePopGesture() -> some View {
        modifier(InteractivePopGestureModifier())
    }
}
