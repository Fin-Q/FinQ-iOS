//
//  TermsDetailView.swift
//  FinQ
//
//  Created by 권대윤 on 9/6/26.
//

import SwiftUI
import WebKit
import ComposableArchitecture

struct TermsDetailView: View {
    let store: StoreOf<TermsDetailFeature>
    @State private var isLoading = true
    
    var body: some View {
        ZStack {
            TermsWebView(url: store.url, isLoading: $isLoading)
            
            if isLoading {
                ProgressView()
                    .controlSize(.large)
            }
        }
        .navigationTitle(store.navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom, spacing: 0) {
            Button {
                HapticManager.selection()
                store.send(.agreeButtonTapped)
            } label: {
                Text("동의")
            }
            .buttonStyle(.customDefault)
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
    }
}

private struct TermsWebView: UIViewRepresentable {
    let url: URL
    @Binding var isLoading: Bool
    
    func makeCoordinator() -> Coordinator {
        Coordinator(isLoading: $isLoading)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard context.coordinator.loadedURL != url else {
            return
        }
        
        context.coordinator.loadedURL = url
        webView.load(URLRequest(url: url))
    }
    
    final class Coordinator: NSObject, WKNavigationDelegate {
        @Binding private var isLoading: Bool
        var loadedURL: URL?
        
        init(isLoading: Binding<Bool>) {
            self._isLoading = isLoading
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation?) {
            isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation?) {
            isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation?, withError error: any Error) {
            isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation?, withError error: any Error) {
            isLoading = false
        }
    }
}

#Preview {
    NavigationStack {
        TermsDetailView(
            store: Store(initialState: TermsDetailFeature.State(term: .serviceTerms)) {
                TermsDetailFeature()
            }
        )
    }
}
