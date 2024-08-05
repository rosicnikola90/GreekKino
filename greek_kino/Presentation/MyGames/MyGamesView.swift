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
    @State var selectedGame: UserGameModel?

    var body: some View {
        ZStack {
            Color(.contentBackground)
                .ignoresSafeArea()
            VStack {
                HStack {
                    Spacer()
                    Text("Moje Igre")
                        .font(.headline)
                        .padding()
                    Spacer()
                }
                if games.isEmpty {
                    Text("Nema zapisa...")
                        .padding()
                    Spacer()
                } else {
                    List {
                        ForEach(games, id: \.game.drawId) { game in
                            UserGameCellView(game: game) {
                                selectedGame = game
                            }
                                .listRowSeparator(.hidden)
                                .frame(maxWidth: .infinity, alignment: .leading)
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
        .fullScreenCover(item: $selectedGame) { game in
            MyGameDetails(viewModel: MyGameDetailsViewModel(game: game), isPresented: $selectedGame)
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


