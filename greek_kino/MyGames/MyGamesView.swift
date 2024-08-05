//
//  MyGamesView.swift
//  greek_kino
//
//  Created by Nikola Rosic on 3.8.24..
//

import SwiftUI
import SwiftData

struct MyGamesView: View {
    
    @EnvironmentObject var gameManager: GameManager
    @Query(sort: \UserGameModel.game.drawTime, order: .reverse) private var games: [UserGameModel]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Text("Moje Igre")
                        .font(.headline)
                        .padding()
                    Spacer()
                }
                List {
                    ForEach(games, id: \.game.drawId) { game in
                        UserGameCellView(game: game)
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .onAppear(perform: {
                                if game.result == nil, dateFromUnixMilliseconds(game.game.drawTime) < Date() {
                                    gameManager.getGame(forDraw: game.game.drawId) { result in
                                        switch result {
                                        case .success(let updatedGame):
                                            game.result = updatedGame
                                            do {
                                                try modelContext.save()
                                            } catch {
                                                print("Failed to save updated game: \(error)")
                                            }
                                        case .failure(let error):
                                            print("Failed to fetch game result: \(error)")
                                        }
                                    }
                                }
                            })
                    }
                    .onDelete(perform: deleteGame)
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
                .padding(.horizontal, -10)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 2)
            }
        }
    }
    private func deleteGame(at offsets: IndexSet) {
        for index in offsets {
            let game = games[index]
            withAnimation {
                modelContext.delete(game)
            }
        }
    }
    
    func dateFromUnixMilliseconds(_ milliseconds: Int) -> Date {
        return Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}

#Preview {
    MyGamesView()
        .environmentObject(GameManager.shared)
}


struct UserGameCellView: View {
    let game: UserGameModel?
    let columns = Array(repeating: GridItem(.flexible()), count: 5)
    let historyGame: HistoryGameModel?
    
    init(game: UserGameModel) {
        self.game = game
        self.historyGame = nil
    }
    
    init(historyGame: HistoryGameModel) {
        self.game = nil
        self.historyGame = historyGame
    }

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Kolo: \(game?.game.visualDraw ?? historyGame?.visualDraw ?? 0)")
                Spacer()
                Text("Vreme: \(formatUnixTime((((game?.game.drawTime ?? historyGame?.drawTime) ?? 0))))")
            }
            Text(game == nil ? "Izvuceni Brojevi:" : "Izabrani brojevi:")
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(game?.numbers ?? historyGame?.winningNumbers?.list ?? [], id: \.self) { item in
                    CustomNumberView(number: item, backgroundColor: getColor())
                        .frame(width: 40, height: 40)
                        .disabled(true)
                }
            }
        }
        .padding(4)
        .padding(.horizontal, 10)
        .background(Color("ContentBackground"))
        .cornerRadius(8)
    }
    
    private func getColor() -> Color {
        if let list = game?.numbers, let guess = game?.result?.winningNumbers?.list {
            for num in guess {
                if list.contains(num) {
                    return .green
                } else {
                    return .blue
                }
            }
        } else {
            return .blue
        }
        return .blue
    }

    private func formatUnixTime(_ unixTime: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
}
