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
    private var onDidAppear: () -> Void = { }
    private var onDidDisappear: () -> Void = { }
    
    init(
        onWillAppear: @escaping () -> Void = {},
        onWillDisappear: @escaping () -> Void = {},
        onDidAppear: @escaping () -> Void = {},
        onDidDisappear: @escaping () -> Void = {}
    ) {
        self.onWillAppear = onWillAppear
        self.onWillDisappear = onWillDisappear
        self.onDidAppear = onDidAppear
        self.onDidDisappear = onDidDisappear
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        context.coordinator
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onWillAppear: onWillAppear, onWillDisappear: onWillDisappear, onDidAppear: onDidAppear, onDidDisappear: onDidDisappear)
    }

    final class Coordinator: UIViewController {
        private let onWillAppear: () -> Void
        private let onWillDisappear: () -> Void
        private var onDidAppear: () -> Void = { }
        private var onDidDisappear: () -> Void = { }
        

        init(onWillAppear: @escaping () -> Void, onWillDisappear: @escaping () -> Void, onDidAppear: @escaping () -> Void, onDidDisappear: @escaping () -> Void) {
            self.onWillAppear = onWillAppear
            self.onWillDisappear = onWillDisappear
            self.onDidAppear = onDidAppear
            self.onDidDisappear = onDidDisappear
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
        
        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            onDidAppear()
        }
        
        override func viewDidDisappear(_ animated: Bool) {
            onDidDisappear()
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

//MARK: - DidAppearModifier

private struct DidAppearModifier: ViewModifier {
    
    private let callback: () -> Void
    
    fileprivate init(callback: @escaping () -> Void) {
        self.callback = callback
    }

    func body(content: Content) -> some View {
        content.background(UIViewLifeCycleHandler(onDidAppear: callback))
    }
}

extension View {
    func onDidAppear(_ perform: @escaping () -> Void) -> some View {
        modifier(DidAppearModifier(callback: perform))
    }
}

//MARK: - DidDisappearModifier

private struct DidDisappearModifier: ViewModifier {
    
    private let callback: () -> Void
    
    fileprivate init(callback: @escaping () -> Void) {
        self.callback = callback
    }

    func body(content: Content) -> some View {
        content.background(UIViewLifeCycleHandler(onDidDisappear: callback))
    }
}

extension View {
    func onDidDisappear(_ perform: @escaping () -> Void) -> some View {
        modifier(DidDisappearModifier(callback: perform))
    }
}
