//
//  UpcomingGamesView.swift
//  greek_kino
//
//  Created by Nikola Rosic on 2.8.24..
//

import SwiftUI
import SwiftData

struct UpcomingGamesView: View {
    
    @StateObject var viewModel = UpcomingGamesViewModel()
    @Query private var userGames: [UserGameModel]
    
    var body: some View {
        VStack {
            if viewModel.futureGames.isEmpty {
                LoadingView()
            } else {
                ZStack {
                    Color(.contentBackground)
                        .ignoresSafeArea()
                    VStack {
                        HStack {
                            Spacer()
                            Text("Naredna Kola")
                                .font(.headline)
                                .padding()
                            Spacer()
                        }
                        HStack {
                            VStack(alignment: .leading) {
                                Text("Početak")
                            }
                            Spacer()
                            VStack(alignment: .trailing) {
                                Text("Preostalo")
                            }
                        }
                        .padding(.horizontal, 30)
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(viewModel.futureGames) { game in
                                    if let countdownViewModel = viewModel.countdownViewModels[game.drawId] {
                                        FutureGameRowView(game: game, countdownModel: countdownViewModel)
                                            .onTapGesture {
                                                viewModel.selectedGame = game
                                            }
                                        ColoredDivider(horizontalPadding: 10)
                                    }
                                }
                            }
                        }
                        .refreshable {
                            viewModel.getFutureGames()
                        }
                    }
                }
            }
        }
        .fullScreenCover(item: $viewModel.selectedGame) { game in
            GameDetailView(viewModel: GameDetailsViewModel(game: game), isPresented: $viewModel.selectedGame)
        }
        .onAppear {
            viewModel.getFutureGames()
        }
        .onChange(of: viewModel.futureGamesOnChange) { _, newValue in
            withAnimation(.easeInOut) {
                viewModel.futureGames = newValue
            }
        }
        .errorAlert(alertMessage: $viewModel.alertMessage)
    }
}

#Preview {
    UpcomingGamesView()
}

struct FutureGameRowView: View {
    let game: UpcomingGameModel
    let countdownViewModel: CountdownViewModel
    
    init(game: UpcomingGameModel, countdownModel: CountdownViewModel) {
        self.game = game
        self.countdownViewModel = countdownModel
    }
    
    var body: some View {
        HStack {
            Text(FormatHelper.formatUnixTimeHHmm(game.drawTime))
                .font(.headline)
            Spacer()
            HStack {
                CountdownView(viewModel: countdownViewModel)
                    .frame(width: 80)
                Image(systemName: "chevron.right")
                    .font(.footnote)
                    .foregroundColor(.primary)
                    .frame(width: 10)
            }
        }
        .padding()
        .padding(.leading, 20)
        .padding(.vertical, 5)
        .background(Color(.tertiarySystemBackground))
    }
}


struct ColoredDivider: View {
    var color: Color = Color(.mozzartYellow)
    var height: CGFloat = 1
    var padding: CGFloat = 0
    var horizontalPadding: CGFloat = 0
    
    var body: some View {
        Rectangle()
            .fill(color)
            .frame(height: height)
            .padding(.vertical, padding)
            .padding(.horizontal, horizontalPadding)
    }
}
