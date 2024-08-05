//
//  MyGameDetails.swift
//  greek_kino
//
//  Created by Nikola Rosic on 5.8.24..
//

import SwiftUI

struct MyGameDetails: View {
    
    @StateObject var viewModel: MyGameDetailsViewModel
    @Binding var isPresented: UserGameModel?
    
    var body: some View {
        VStack {
            if viewModel.loading {
                LoadingView()
            } else {
                ZStack {
                    Color(.contentBackground)
                        .ignoresSafeArea()
                    VStack {
                        HStack(alignment: .top) {
                            Spacer()
                            Spacer()
                            Text("Rezultati Kola \n\(FormatHelper.formatNumber(viewModel.game?.visualDraw ?? 0))")
                                .font(.headline)
                                .padding()
                                .multilineTextAlignment(.center)
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    isPresented = nil
                                }
                            }) {
                                Image(systemName: "xmark.circle")
                                    .font(.largeTitle)
                                    .foregroundColor(.primary)
                                    .padding()
                            }
                        }
                        if let game = viewModel.game, let userGame = viewModel.userGame {
                            
                            ResultCellView(historyGame: game, userGame: userGame)
                                .padding(8)
                        }
                        Spacer()
                    }
                }
            }
        }
        .onChange(of: viewModel.gameOnChange) { _, newValue in
            withAnimation(.easeInOut) {
                viewModel.game = newValue
            }
        }
        .errorAlert(alertMessage: $viewModel.alertMessage)
    }
}


final class MyGameDetailsViewModel: ObservableObject {
    
    @Published var game: HistoryGameModel?
    @Published var gameOnChange: HistoryGameModel?
    let userGame: UserGameModel?
    @Published var alertMessage: String?
    @Published var loading = false
    
    init(game: UserGameModel?) {
        self.userGame = game
        getGame()
    }
    
    func getGame() {
        loading = true
        GameManager.shared.getGame(forDraw: userGame?.game.drawId ?? 0) { [weak self] result in
            self?.loading = false
            switch result {
            case .success(let game):
                self?.gameOnChange = game
            case .failure(let failure):
                self?.alertMessage = failure.localizedDescription
            }
        }
    }
}



struct ResultCellView: View {
    let userGame: UserGameModel
    let columns = Array(repeating: GridItem(.flexible()), count: 5)
    let historyGame: HistoryGameModel
    let guesses: Int
    
    init(historyGame: HistoryGameModel, userGame: UserGameModel) {
        self.historyGame = historyGame
        self.userGame = userGame
        var count = 0
        for num in historyGame.winningNumbers?.list ?? [] {
            if userGame.numbers.contains(num) {
                count += 1
            }
        }
        self.guesses = count
    }
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Izvučeni Brojevi:")
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(historyGame.winningNumbers?.list ?? [], id: \.self) { item in
                        CustomNumberView(number: item, backgroundColor: getColor(forNum: item))
                            .frame(width: 40, height: 40)
                            .disabled(true)
                    }
                }
                HStack {
                    Text("Pogodaka: \(guesses)")
                    Spacer()
                    Text("Kvota: \(String(format: "%.2f", userGame.quote))")
                }
            }
        }
        .padding(4)
        .padding(.horizontal, 10)
        .background(Color(.tertiarySystemBackground))
        .cornerRadius(8)
    }
    
    private func getColor(forNum num: Int) -> Color {
        if userGame.numbers.contains(num) {
            return .green
        } else {
            return .blue
        }
    }
}
