//
//  LiveView.swift
//  greek_kino
//
//  Created by Nikola Rosic on 3.8.24..
//

import SwiftUI

struct LiveView: View {
    
    @StateObject private var viewModel = LiveViewCoordinator()

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    showShortModal
                }) {
                    Image(systemName: "list.bullet.circle")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .padding()
                }
                Spacer()
                Button(action: {
                    viewModel.reload()
                }) {
                    Image(systemName: "arrow.clockwise.circle")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .padding()
                }
                
            }
            ZStack {
                LiveDrawView(viewModel: viewModel)
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        viewModel.load(urlString: Constants.shared.livePreviewUrl)
                    }
                if viewModel.isLoading {
                    LoadingView()
                }
            }
            Spacer()
        }
    }
}

