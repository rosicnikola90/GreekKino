//
//  HistoryView.swift
//  greek_kino
//
//  Created by Nikola Rosic on 4.8.24..
//

import SwiftUI

struct HistoryView: View {
    
    @StateObject var viewModel = HistoryViewModel()
    
    var body: some View {
        if viewModel.historyGames.isEmpty {
            LoadingView()
        } else {
            ZStack {
                Color("MozzartYellow")
                    .ignoresSafeArea()
                VStack {
                    HStack {
                        Spacer()
                        Text("Istorija")
                            .font(.headline)
                            .padding()
                        Spacer()
                    }
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(viewModel.historyGames) { game in
                                HStack {
                                    Text(game.status ?? "--")
                                }
                                Divider()
                            }
                        }
                    }
                    .refreshable {
                        print("refresh")
                    }
                }
            }
            .onAppear(perform: {
                if viewModel.historyGames.isEmpty {
                    viewModel.getHistoryGames()
                }
            })
            .onChange(of: viewModel.historyGamesOnChange) { _, newValue in
                withAnimation(.easeInOut) {
                    viewModel.historyGames = newValue
                }
            }
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(GameManager.shared)
}
