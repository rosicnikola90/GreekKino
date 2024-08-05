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
    @EnvironmentObject var gameManager: GameManager
    @Query private var userGames: [UserGameModel]
    
    var body: some View {
        ZStack {
            if gameManager.loading {
                LoadingView()
            } else {
                NavigationStack {
                    VStack {
                        HStack {
                            Spacer()
                            Text("Naredna Kola")
                                .font(.headline)
                                .padding()
                            Spacer()
                        }
                        HStack {
                            Text("Start Time")
                            Spacer()
                            Text("Countdown")
                        }
                        .padding(.horizontal, 20)
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(viewModel.futureGames) { game in
                                    FutureGameRowView(game: game)
                                        .onTapGesture {
//                                            let contains = userGames.filter { $0.drawId == game.drawId }
                                            viewModel.selectedGame = game
                                        }
                                    Divider()
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
        .onAppear(perform: {
            if viewModel.futureGames.isEmpty {
                viewModel.getFutureGames()
            }
        })
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
    
    var body: some View {
        HStack {
            Text(formatUnixTime(game.drawTime))
                .font(.headline)
            
            Spacer()
            
            CountdownView(viewModel: CountdownViewModel(drawTime: game.drawTime))
                .frame(width: 80)
            
        }
        .padding()
        .padding(.horizontal, 20)
        .background(
            Color("ContentBackground")
        )
    }
    
    private func formatUnixTime(_ unixTime: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime) / 1000)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: date)
    }
}

