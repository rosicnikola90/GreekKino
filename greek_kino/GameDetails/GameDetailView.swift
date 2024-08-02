//
//  GameDetailView.swift
//  greek_kino
//
//  Created by Nikola Rosic on 3.8.24..
//

import SwiftUI

struct GameDetailView: View {

    @StateObject var viewModel: GameDetailsViewModel
    @Binding var isPresented: FutureGameModel?
    let columns = Array(repeating: GridItem(.flexible()), count: 8)

    var body: some View {
        VStack {
            HStack {
                Button(action: {
                    isPresented = nil
                }) {
                    Image(systemName: "checkmark.circle")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                        .padding()
                }
                Spacer()
                CountdownView(viewModel: viewModel.countdownViewModel)
                Spacer()
                Button(action: {
                    isPresented = nil
                }) {
                    Text("Close")
                        .padding()
                }
            }
            Text("Game No.: \(viewModel.game.drawId)")
                .font(.headline)
            Spacer()
            LazyVGrid(columns: columns, spacing: 4) {
                ForEach(1...80, id: \.self) { number in
                    Button(action: {
                        print("Button \(number) tapped")
                        withAnimation(.easeInOut) {
                            viewModel.numberPressed(number: number)
                        }
                    }) {
                        Text("\(number)")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .aspectRatio(1, contentMode: .fit)
                            .background(viewModel.selectedNumbers.contains(number) ? Color.green : Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                    }
                }
            }
            .padding()
        }
        .alert(isPresented: $viewModel.maxReached) {
            Alert(
                title: Text("Maximum reached!"),
                message: Text("You tried to selected more than 15 numbers"),
                dismissButton: .default(Text("OK"))
            )
        }
        .alert(isPresented: $viewModel.countdownViewModel.reachedZero, content: {
            Alert(
                title: Text("Time Out!"),
                message: Text("Game started"),
                dismissButton: .default(Text("OK"), action: {
                    isPresented = nil
                })
            )
        })
    }
}


final class GameDetailsViewModel: ObservableObject {
    
    let game: FutureGameModel
    @Published var selectedNumbers: [Int] = []
    var countdownViewModel: CountdownViewModel
    @Published var maxReached = false
    
    init(game: FutureGameModel) {
        self.game = game
        self.countdownViewModel = CountdownViewModel(drawTime: game.drawTime)
    }
    
    func numberPressed(number: Int) {
        if let index = selectedNumbers.firstIndex(of: number) {
            selectedNumbers.remove(at: index)
        } else {
            if selectedNumbers.count == 15 {
                maxReached = true
            } else {
                selectedNumbers.append(number)
            }
        }
    }
    
    func createGamePressed() {
        
    }
}
