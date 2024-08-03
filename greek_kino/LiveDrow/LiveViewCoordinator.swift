//
//  LiveViewCoordinator.swift
//  greek_kino
//
//  Created by Nikola Rosic on 3.8.24..
//

import SwiftUI
import WebKit
import Combine

class LiveViewCoordinator: NSObject, ObservableObject {
    @Published var isLoading: Bool = false
    private var webView: WKWebView
    private var loadingStateDebounce: AnyCancellable?

    override init() {
        self.webView = WKWebView()
        super.init()
        self.webView.navigationDelegate = self
    }

    func load(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }

    func reload() {
        webView.reload()
    }

    func getWebView() -> WKWebView {
        return webView
    }

    private func debounceLoadingState(_ isLoading: Bool) {
        loadingStateDebounce?.cancel()
        loadingStateDebounce = Just(isLoading)
            .debounce(for: .milliseconds(100), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.isLoading = $0
            }
    }
}

extension LiveViewCoordinator: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        debounceLoadingState(true)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        debounceLoadingState(false)
    }

    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        debounceLoadingState(false)
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        debounceLoadingState(false)
    }
}
