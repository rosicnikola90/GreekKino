//
//  LiveView.swift
//  greek_kino
//
//  Created by Nikola Rosic on 3.8.24..
//

import SwiftUI
import SwiftData

struct LiveView: View {
    
    @StateObject private var viewModel = LiveViewCoordinator()
    @State private var showModal = false
    @Query(sort: \UserGameModel.game.drawTime, order: .reverse) private var games: [UserGameModel]
    var body: some View {
        ZStack {
            Color(.contentBackground)
                .ignoresSafeArea()
            VStack {
                HStack(alignment: .top) {
                    Button(action: {
                        showModal.toggle()
                    }) {
                        Image(systemName: "list.bullet.circle")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                            .padding()
                    }
                    Spacer()
                    Text("Uživo")
                        .font(.headline)
                        .padding()
                    Spacer()
                    Button(action: {
                        viewModel.reload()
                    }) {
                        Image(systemName: "arrow.clockwise.circle")
                            .font(.largeTitle)
                            .foregroundColor(.primary)
                            .padding()
                    }
                }
                ZStack {
                    LiveDrawView(viewModel: viewModel)
                        .edgesIgnoringSafeArea(.all)
                        .onAppear {
                            viewModel.load(urlString: URLs.livePreviewUrl.urlString)
                        }
                    if viewModel.isLoading {
                        LoadingView()
                    }
                }
                Spacer()
            }
            .sheet(isPresented: $showModal) {
                List {
                    ForEach(games, id: \.game.drawId) { game in
                        UserGameCellView(game: game, action: nil)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
                .padding(.horizontal, -10)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 2)
                .presentationDetents([.large, .medium, .fraction(0.4)])
                
            }
        }
    }
}

