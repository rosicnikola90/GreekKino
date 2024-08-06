//
//  LiveDrawView.swift
//  greek_kino
//
//  Created by Nikola Rosic on 3.8.24..
//

import SwiftUI
import WebKit

struct LiveDrawView: UIViewRepresentable {
    
    @ObservedObject var viewModel: LiveViewCoordinator

    func makeUIView(context: Context) -> WKWebView {
        return viewModel.getWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}
