//
//  UIViewLifeCycleHandler.swift
//  FinQ
//
//  Created by 권대윤 on 9/8/26.
//

import SwiftUI

struct UIViewLifeCycleHandler: UIViewControllerRepresentable {
    
    private var onWillAppear: () -> Void = { }
    private var onWillDisappear: () -> Void = { }
    
    init(onWillAppear: @escaping () -> Void = { }, onWillDisappear: @escaping () -> Void = { }) {
        self.onWillAppear = onWillAppear
        self.onWillDisappear = onWillDisappear
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        context.coordinator
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onWillAppear: onWillAppear, onWillDisappear: onWillDisappear)
    }

    final class Coordinator: UIViewController {
        private let onWillAppear: () -> Void
        private let onWillDisappear: () -> Void

        init(onWillAppear: @escaping () -> Void, onWillDisappear: @escaping () -> Void) {
            self.onWillAppear = onWillAppear
            self.onWillDisappear = onWillDisappear
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder _: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            onWillAppear()
        }
        
        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            onWillDisappear()
        }
    }
}

//MARK: - WillAppearModifier

private struct WillAppearModifier: ViewModifier {
    
    private let callback: () -> Void
    
    fileprivate init(callback: @escaping () -> Void) {
        self.callback = callback
    }

    func body(content: Content) -> some View {
        content.background(UIViewLifeCycleHandler(onWillAppear: callback))
    }
}

extension View {
    func onWillAppear(_ perform: @escaping () -> Void) -> some View {
        modifier(WillAppearModifier(callback: perform))
    }
}

//MARK: - WillDisappearModifier

private struct WillDisappearModifier: ViewModifier {
    
    private let callback: () -> Void
    
    fileprivate init(callback: @escaping () -> Void) {
        self.callback = callback
    }

    func body(content: Content) -> some View {
        content.background(UIViewLifeCycleHandler(onWillDisappear: callback))
    }
}

extension View {
    func onWillDisappear(_ perform: @escaping () -> Void) -> some View {
        modifier(WillDisappearModifier(callback: perform))
    }
}
