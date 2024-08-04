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
            Color("MozzartYellow")
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
}

#Preview {
    MyGamesView()
        .environmentObject(GameManager.shared)
}


struct UserGameCellView: View {
    let game: UserGameModel
    let columns = Array(repeating: GridItem(.flexible()), count: 5)

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("Kolo: \(game.game.visualDraw)")
                Spacer()
                Text("Vreme: \(formatUnixTime(game.game.drawTime))")
            }
            Text("Izabrani brojevi:")
            LazyVGrid(columns: columns, spacing: 2) {
                ForEach(game.numbers, id: \.self) { item in
                    CustomNumberView(number: item, backgroundColor: Color.blue)
                        .frame(width: 30, height: 30)
                }
            }
        }
        .padding(4)
        .padding(.horizontal, 10)
        .background(Color("ContentBackground"))
        .cornerRadius(8)
    }

    private func formatUnixTime(_ unixTime: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unixTime / 1000))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
}
