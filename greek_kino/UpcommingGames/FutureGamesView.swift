//
//  FutureGamesView.swift
//  greek_kino
//
//  Created by Nikola Rosic on 2.8.24..
//

import SwiftUI

struct FutureGamesView: View {
    @ObservedObject var viewModel = FutureGamesViewModel()
    @State private var selectedGame: FutureGameModel? = nil
    
    var body: some View {
        NavigationStack {
            if viewModel.futureGames.isEmpty {
                LoadingView()
            } else {
                VStack {
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
                                        selectedGame = game
                                    }
                                Divider()
                            }
                        }
                    }
                }
            }
        }
        .fullScreenCover(item: $selectedGame) { game in
            GameDetailView(viewModel: GameDetailsViewModel(game: game), isPresented: $selectedGame)
            
        }
        .onAppear(perform: {
            viewModel.getFutureGames()
        })
        .onChange(of: viewModel.futureGamesOnChange) { _, newValue in
            withAnimation(.easeInOut) {
                viewModel.futureGames = newValue
            }
        }
    }
}


#Preview {
    FutureGamesView()
}



struct FutureGameRowView: View {
    let game: FutureGameModel
    
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

